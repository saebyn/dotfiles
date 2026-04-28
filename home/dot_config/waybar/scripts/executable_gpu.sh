#!/usr/bin/env bash
# GPU status for waybar - NVIDIA RTX 3090
# Outputs JSON with GPU utilization, memory, power

GPU_DATA=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,power.draw,power.limit --format=csv,noheader,nounits 2>/dev/null | awk -F', ' '{print $1, $2, $3, $4, $5}')
read -r util mem_used mem_total power_draw power_cap <<< "$GPU_DATA"

# Power percentage
power_pct=$(echo "$power_draw $power_cap" | awk '{printf "%.0f", ($1/$2)*100}')

# Color based on power draw percentage
if (( power_pct > 80 )); then
    color="#ff6b6b"      # red - heavy load
elif (( power_pct > 50 )); then
    color="#ffa94d"      # orange - moderate load
else
    color="#69db7c"      # green - light load
fi

echo "{\"text\": \"GPU: ${util}% | ${mem_used}MiB mem | ${power_draw}W/${power_pct}%\", \"class\": \"gpu-${util}\", \"tooltip\": \"GPU: ${util}% utilization, ${mem_used}MiB / ${mem_total}MiB, ${power_draw}W / ${power_cap}W max\", \"markup\": true}"

