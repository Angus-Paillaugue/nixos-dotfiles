hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
  hl.exec_cmd("~/.config/home-manager/modules/hyprland/scripts/lid-monitor.sh")
end)