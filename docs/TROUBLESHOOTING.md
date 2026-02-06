# Troubleshooting Guide

Quick reference for common issues and solutions.

## Audio Interface Not Detected

### Symptoms
- `pw-cli list-objects Device` doesn't show your interface
- pavucontrol shows no audio devices

### Solutions

1. **Check USB connection**:
   ```bash
   lsusb | grep -i audio
   ```
   Device should appear in the list.

2. **Load USB audio module**:
   ```bash
   sudo modprobe snd_usb_audio
   ```

3. **Restart PipeWire**:
   ```bash
   systemctl --user restart wireplumber pipewire
   ```

4. **Check if disabled in BIOS**:
   - Restart computer and enter BIOS
   - Verify USB devices are enabled
   - May need to change USB mode from "Host Only" to "Host+Device"

---

## Audio Crackling/Clicks/Dropouts

### Symptoms
- Audio cuts out randomly
- Crackling noise during playback
- "Xruns" reported in logs

### Causes & Solutions

#### CPU Overload
```bash
top
```
- Audio process (TONEX, Amplitube) should show < 80% CPU
- If > 80%: close other applications, reduce effects

#### Buffer Too Small
- Try increasing from 128 to 256 samples:
  ```bash
  nano ~/.config/wireplumber/wireplumber.conf.d/90-my_audio_interface.conf
  # Change api.alsa.period-size = 256
  systemctl --user restart wireplumber
  ```

#### USB Interference
- Try different USB port (USB 3 preferred)
- Check for USB devices causing interference (hubs, extra devices)
- Consider powered USB hub

#### CPU Frequency Scaling Not Working
```bash
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```
Should show "performance". If not:
```bash
sudo cpupower frequency-set -g performance
```

---

## High Latency (> 15ms)

### Symptoms
- Noticeable delay when playing
- Using `jack_iodelay` shows > 15ms

### Diagnostic Steps

1. **Verify configuration**:
   ```bash
   pw-cli info 0 | grep quantum
   ```
   Should show 128 (not higher)

2. **Check real-time status**:
   ```bash
   rtcqs
   ```
   Should show PASS for preemption

3. **Monitor CPU during playback**:
   ```bash
   top
   ```

### Common Solutions

| Issue | Solution |
|-------|----------|
| Quantum wrong | Check WirePlumber config, restart PipeWire |
| CPU high | Close apps, reduce effects |
| USB issues | Try different port, check `lsusb` |
| Preemption off | Reboot after editing GRUB, run `grub-mkconfig` |
| SMT not disabled | Run `echo off \| sudo tee /sys/devices/system/cpu/smt/control` |

---

## Amplitube/Tonex Won't Start

### Error: "Cannot find Wine prefix"

**Solution**:
```bash
winecfg
# This creates/initializes the .wine prefix
```

### Error: "ASIO driver not available"

**Solutions**:
1. Run `wineasio-register` again
2. Run `wineasio-settings` to configure
3. Restart PipeWire: `systemctl --user restart pipewire`

### Error: "Application crashes on startup"

**Solutions**:
1. Run with simpler GPU: `WINE_CPU_TOPOLOGY=2:2 wine program.exe`
2. Try legacy DXVK: `winetricks dxvk=legacy`
3. Update DXVK: `winetricks dxvk --force`

---

## No Audio Input

### Symptoms
- Guitar signal not reaching Amplitube
- Input meter not moving

### Diagnostic Steps

1. **Verify interface is detecting signal**:
   ```bash
   qpwgraph
   ```
   Watch the interface input meter while plugging guitar in

2. **Check pavucontrol**:
   ```bash
   pavucontrol
   ```
   - Input Devices tab: does interface show audio level?
   - Recording tab: is anything recording?

3. **Verify Amplitube has correct input**:
   - Open Amplitube settings
   - Audio > Input Device
   - Should show your interface

### Solutions

| Issue | Solution |
|-------|----------|
| Interface not showing levels | Check USB cable, try different port |
| Interface shows levels, software doesn't | Restart software, check input device selection |
| Very low levels | Increase guitar volume or interface input gain |
| No levels at all | Interface may need driver, check specs |

---

## Amplitube Audio Distortion

### Symptoms
- Audio is clipped or harsh
- Peak meters show red constantly

### Solutions

1. **Lower input gain** (primary solution):
   - Reduce guitar input on interface
   - Reduce input gain in Amplitube settings

2. **Check Amplitube input level**:
   - Go to Settings > Input
   - Should peak around -12dB, not 0dB

3. **Verify audio interface output**:
   - Master output should not be maxed out
   - Leave 3dB headroom

4. **Try smaller buffer** if distortion is just clipping:
   - May be latency-related processing issue
   - Usually: lower input level fixes it

---

## WineASIO Configuration Lost

### Problem
WineASIO settings reset after reboot or application restart.

### Temporary Solutions
1. Reconfigure in `wineasio-settings` each session
2. Keep the app running between uses

### Permanent Solution
Create a startup script:

```bash
cat > ~/.local/bin/tonex-setup.sh << 'EOF'
#!/bin/bash
# Configure WineASIO
wineasio-settings &
sleep 2
kill %1

# Launch Tonex
chrt -f 70 wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/TONEX/TONEX.exe
EOF

chmod +x ~/.local/bin/tonex-setup.sh
```

---

## System Hangs or Freezes

### Symptoms
- System becomes unresponsive
- Mouse/keyboard frozen
- Happens during audio playback

### Likely Cause
Real-time priority causing system starvation.

### Immediate Fix
Revert real-time priority:
```bash
chrt -p 0 $$  # Reset current process to normal priority
```

### Long-term Solutions

1. **Lower real-time priority**:
   ```bash
   chrt -f 60 wine ...  # Use 60 instead of 70
   ```

2. **Increase priority threshold**:
   ```bash
   sudo sysctl -w kernel.sched_rt_runtime_us=950000
   ```

3. **Monitor system during playback**:
   ```bash
   watch -n 1 top
   ```

---

## Permission Denied Errors

### Error: "Permission denied" when running commands

**Solutions**:
1. Add yourself to audio group:
   ```bash
   sudo usermod -a -G audio $USER
   # Then log out and back in
   ```

2. For GRUB/kernel commands:
   ```bash
   sudo nano /etc/default/grub
   # Use sudo for all admin commands
   ```

### Error: "Cannot write to /sys/..."

**Solution**:
All `/sys/` modifications need `sudo`:
```bash
echo off | sudo tee /sys/devices/system/cpu/smt/control
```

---

## Performance Still Suboptimal

### Verify All Steps Completed

Run this diagnostic:

```bash
echo "=== Checking Real-Time Setup ==="
echo "CPU Governor:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo ""
echo "SMT Status:"
cat /sys/devices/system/cpu/smt/control
echo ""
echo "Swappiness:"
sysctl vm.swappiness
echo ""
echo "Audio Real-Time Priority:"
grep "@audio" /etc/security/limits.d/20-audio.conf
echo ""
echo "Kernel Preemption:"
grep preempt /proc/cmdline
echo ""
echo "RTCQS Status:"
rtcqs | head -20
```

Check each output against this guide's requirements.

---

## Yabridge / DAW Issues

### Plugins Don't Appear in Reaper

**Solutions**:
1. Verify yabridge sync completed:
   ```bash
   yabridgectl status
   ```
2. Check the plugin path in Reaper preferences (Options → Preferences → Plug-ins → VST)
3. Add `~/.vst3/yabridge` to VST paths
4. Rescan plugins in Reaper

### Plugin Window Doesn't Open

**Solutions**:
1. Check Wine is working: `wine --version`
2. Try running the standalone version first to verify it works
3. Check for Wine errors in terminal when loading plugin

### yabridge sync Fails

**Solutions**:
1. Ensure plugins are installed:
   ```bash
   ls ~/.wine/drive_c/Program\ Files/Common\ Files/VST3/
   ```
2. Reinstall plugins via IK Product Manager
3. Force re-sync:
   ```bash
   yabridgectl sync --force
   ```

### High Latency in Reaper

**Solutions**:
1. Confirm JACK audio system is selected in Reaper preferences
2. Verify block size is 128 samples
3. Disable any plugin latency compensation if not needed
4. Launch Reaper with real-time priority: `chrt -f 70 reaper`

### Audio Crackling in Reaper

**Solutions**:
1. Ensure Reaper is running with real-time priority
2. Verify buffer size matches PipeWire config (128 samples)
3. Check CPU usage - close unnecessary applications
4. Try increasing buffer to 256 if issues persist

---

## Still Having Issues?

### Gather System Information

```bash
# Create a debug report
cat > debug_report.txt << 'EOF'
=== System Info ===
$(uname -a)
$(hostnamectl)

=== Real-Time Status ===
$(rtcqs)

=== Audio Devices ===
$(pw-cli list-objects Device | grep device.nick)

=== PipeWire Config ===
$(pw-cli info 0)

=== Audio Process Priority ===
$(ps aux | grep -i tonex)

=== CPU Status ===
$(cpupower frequency-info)

=== Journal Errors ===
$(journalctl -xe | tail -50)
EOF
```

Include this when seeking help on forums or GitHub issues.

---

## Getting Help

- **CachyOS Forum**: https://forum.cachyos.org/
- **Wine FAQ**: https://wiki.winehq.org/FAQ
- **Yabridge GitHub**: https://github.com/robbert-vdh/yabridge
- **GitHub Issues**: Create an issue with your debug report
- **Reddit**: r/linux_gaming, r/CachyOS

Always include:
1. Exact error message
2. Which step you're on
3. Output of `rtcqs`
4. Your audio interface model
5. Your CPU and GPU
