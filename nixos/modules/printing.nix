{ ... }:

{
  services.printing.enable = false;

  hardware.printers = {
    ensureDefaultPrinter = "Brother_HL-3170CDW";
    ensurePrinters = [
      {
        deviceUri = "ipp://10.0.0.8/ipp";
        location = "home";
        name = "Brother_HL-3170CDW";
        model = "everywhere";
      }
    ];
  };
}
