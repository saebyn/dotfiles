"""Run with: python3 -m unittest discover -s tests -v (no desktop required)."""
import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
CONTROLLER = ROOT / 'home/dot_config/niri/scripts/executable_toggle-stream-mode.sh'
MONITOR = ROOT / 'home/dot_config/niri/scripts/executable_obs-stream-mode-monitor.sh'
GENERATOR = ROOT / 'home/dot_config/kitty/executable_stream-font-size.sh'


class StreamModeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.runtime = self.home / 'runtime'
        self.runtime.mkdir()
        self.bin = self.home / 'bin'
        self.bin.mkdir()
        self.log = self.home / 'calls.jsonl'
        self.env = dict(os.environ, HOME=str(self.home), XDG_RUNTIME_DIR=str(self.runtime),
                        PATH=f'{self.bin}:{os.environ["PATH"]}', CALL_LOG=str(self.log))
        for name in ('kitty', 'systemctl', 'pkill'):
            self.stub(name, '''import json, os, sys
with open(os.environ['CALL_LOG'], 'a') as log:
    log.write(json.dumps([os.path.basename(sys.argv[0]), *sys.argv[1:]]) + '\\n')
if os.environ.get('FAIL_KITTY') and os.path.basename(sys.argv[0]) == 'kitty':
    sys.exit(1)
''')
        self.flag = self.home / '.stream-mode'

    def stub(self, name, code):
        script = self.bin / name
        script.write_text('#!/usr/bin/env python3\n' + code)
        script.chmod(0o755)

    def run_controller(self, *args, check=True):
        return subprocess.run(['bash', str(CONTROLLER), *args], env=self.env,
                              text=True, capture_output=True, check=check)

    def calls(self, name):
        lines = self.log.read_text().splitlines() if self.log.exists() else []
        return [c for line in lines if (c := json.loads(line))[0] == name]

    def add_socket(self, suffix):
        path = self.runtime / f'kitty-stream-mode-{suffix}'
        # Socket filesystem nodes exercise Bash's -S guard; remote commands
        # are mocked, so no listener or desktop is needed.
        os.mknod(path, stat.S_IFSOCK | 0o600)
        return f'unix:{path}'

    def generated(self):
        return subprocess.check_output(['bash', str(GENERATOR)], env=self.env, text=True)

    def test_new_process_configuration_reads_flag_not_inherited_environment(self):
        self.env['STREAM_MODE'] = '1'
        self.assertEqual(self.generated(), '')
        self.flag.touch()
        self.env.pop('STREAM_MODE')
        output = self.generated()
        self.assertRegex(output, r'^font_size \d+(?:\.\d+)?\n$')
        self.assertGreater(float(output.split()[1]), 10)
        self.flag.unlink()
        self.assertEqual(self.generated(), '')

    def test_all_instances_reset_only_on_transitions(self):
        destinations = [self.add_socket('101'), self.add_socket('202')]
        # Ordinary files and unrelated sockets must not be targeted.
        (self.runtime / 'kitty-stream-mode-regular').touch()
        self.run_controller('on')
        expected = []
        for dest in destinations:
            expected.extend([['kitty', '@', '--to', dest, 'load-config'],
                             ['kitty', '@', '--to', dest, 'set-font-size', '--all', '0']])
        self.assertEqual(self.calls('kitty'), expected)
        self.assertTrue(self.flag.exists())
        self.assertIn(['systemctl', '--user', 'set-environment', 'STREAM_MODE=1'],
                      self.calls('systemctl'))
        self.run_controller('on')  # Does not overwrite manual zoom.
        self.assertEqual(self.calls('kitty'), expected)
        self.run_controller('off')
        self.assertFalse(self.flag.exists())
        self.assertEqual(self.calls('kitty'), expected * 2)
        self.run_controller('off')
        self.assertEqual(self.calls('kitty'), expected * 2)
        self.assertIn(['systemctl', '--user', 'unset-environment', 'STREAM_MODE'],
                      self.calls('systemctl'))
        self.assertEqual(len(self.calls('pkill')), 4)

    def test_default_and_explicit_toggle(self):
        self.run_controller()
        self.assertTrue(self.flag.exists())
        self.run_controller('toggle')
        self.assertFalse(self.flag.exists())
        self.assertEqual(self.calls('kitty'), [])

    def test_invalid_action_does_not_change_state(self):
        self.flag.touch()
        self.assertEqual(self.run_controller('invalid', check=False).returncode, 2)
        self.assertTrue(self.flag.exists())
        self.assertEqual(self.calls('systemctl'), [])
        self.assertEqual(self.calls('kitty'), [])

    def test_dead_socket_failure_does_not_block_other_instances_or_waybar(self):
        self.add_socket('101')
        self.add_socket('202')
        self.env['FAIL_KITTY'] = '1'
        result = self.run_controller('on')
        self.assertEqual(len(self.calls('kitty')), 2)
        self.assertEqual(result.stderr.count('Could not update Kitty'), 2)
        self.assertTrue(self.flag.exists())
        self.assertEqual(len(self.calls('pkill')), 1)

    def test_missing_runtime_directory(self):
        self.env.pop('XDG_RUNTIME_DIR')
        self.run_controller('on')
        self.assertTrue(self.flag.exists())
        self.assertEqual(self.calls('kitty'), [])

    def test_missing_kitty(self):
        (self.bin / 'kitty').unlink()
        if shutil.which('kitty', path=self.env['PATH']):
            self.skipTest('Kitty is installed in the host PATH')
        self.add_socket('101')
        self.run_controller('on')
        self.assertTrue(self.flag.exists())
        self.assertEqual(self.calls('kitty'), [])

    def test_concurrent_toggles_are_serialized(self):
        self.add_socket('101')
        commands = [subprocess.Popen(['bash', str(CONTROLLER)], env=self.env,
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    for _ in range(2)]
        for command in commands:
            command.communicate(timeout=10)
            self.assertEqual(command.returncode, 0)
        self.assertFalse(self.flag.exists())
        self.assertEqual(len(self.calls('kitty')), 4)

    def test_obs_monitor_uses_same_on_off_path(self):
        self.add_socket('101')
        deployed = self.home / '.config/niri/scripts'
        deployed.mkdir(parents=True)
        shutil.copy(CONTROLLER, deployed / 'toggle-stream-mode.sh')
        (deployed / 'toggle-stream-mode.sh').chmod(0o755)
        obs = self.home / 'obs-running'
        obs.touch()
        self.stub('pgrep', '''import os, pathlib, sys
sys.exit(0 if (pathlib.Path(os.environ['HOME']) / 'obs-running').exists() else 1)
''')
        self.stub('sleep', '''import os, pathlib, signal
obs = pathlib.Path(os.environ['HOME']) / 'obs-running'
if obs.exists():
    obs.unlink()
else:
    os.kill(os.getppid(), signal.SIGTERM)
''')
        subprocess.run(['bash', str(MONITOR)], env=self.env, check=True, timeout=10,
                       capture_output=True)
        self.assertFalse(self.flag.exists())
        self.assertFalse((self.home / '.stream-mode.obs-owned').exists())
        self.assertEqual(len(self.calls('kitty')), 4)

    def test_config_wiring_and_shell_syntax(self):
        config = (ROOT / 'home/dot_config/kitty/kitty.conf').read_text()
        self.assertIn('geninclude stream-font-size.sh', config)
        self.assertIn('allow_remote_control socket-only', config)
        self.assertIn('listen_on unix:${XDG_RUNTIME_DIR}/kitty-stream-mode-{kitty_pid}', config)
        for key, amount in [('plus', '+1'), ('minus', '-1'), ('0', '0')]:
            self.assertIn(f'map ctrl+{key} change_font_size all {amount}', config)
        for script in (CONTROLLER, MONITOR, GENERATOR):
            subprocess.run(['bash', '-n', str(script)], check=True)


if __name__ == '__main__':
    unittest.main()
