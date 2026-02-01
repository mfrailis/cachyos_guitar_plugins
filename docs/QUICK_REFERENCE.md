# Quick Reference Commands

Handy command reference for common operations.

## Installation Commands

```bash
# Full installation (copy & paste)
sudo pacman -Syu
sudo pacman -S pipewire-jack jack-example-tools qpwgraph wine-cachyos winetricks cpupower
paru -S rtcqs wineasio

# Initial setup
sudo ln -s /usr/bin/wine /usr/bin/wine64
winecfg
winetricks dxvk
wineasio-register
```

## Real-Time Optimization

```bash
# Performance mode
sudo cpupower frequency-set -g performance

# Disable SMT
echo off | sudo tee /sys/devices/system/cpu/smt/control

# Reduce swappiness
sudo sysctl -w vm.swappiness=10

# Disable USB suspend
echo -1 | sudo tee /sys/module/usbcore/parameters/autosuspend

# Edit GRUB (add preempt=full)
sudo nano /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot

# Set audio permissions
echo "@audio - rtprio 99" | sudo tee -a /etc/security/limits.d/20-audio.conf
echo "@audio - memlock unlimited" | sudo tee -a /etc/security/limits.d/20-audio.conf
sudo usermod -a -G audio $USER
# Log out and back in
```

## Audio Configuration

```bash
# List audio devices
pw-cli list-objects Device | grep device.nick

# Create config directories
mkdir -p ~/.config/wireplumber/wireplumber.conf.d
mkdir -p ~/.config/pipewire/pipewire.conf.d
mkdir -p ~/.config/pipewire/jack.conf.d

# Restart audio services
systemctl --user restart wireplumber pipewire pipewire-pulse

# Configure audio profiles
pavucontrol

# Check audio configuration
pw-cli info 0

# Visual routing
qpwgraph
```

## Latency Testing

```bash
# Measure latency
jack_iodelay

# Visual routing tool (in parallel)
qpwgraph
```

## IK Multimedia

```bash
# Install IK Product Manager
wine ~/Downloads/ik_product_manager_*.zip

# Launch IK Product Manager
wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/IK\ Product\ Manager/IK\ Product\ Manager.exe

# Configure WineASIO
wineasio-settings

# Run Tonex (with real-time priority)
chrt -f 70 wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/TONEX/TONEX.exe

# Run Amplitube
chrt -f 70 wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/Amplitube/Amplitube.exe
```

## Diagnostic Commands

```bash
# Check real-time configuration
rtcqs

# Monitor CPU usage
top

# Check kernel parameters
grep preempt /proc/cmdline
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Check audio devices
lsusb | grep -i audio

# View system logs
journalctl -xe

# CPU frequency info
cpupower frequency-info

# Check JACK/PipeWire status
systemctl --user status pipewire
systemctl --user status wireplumber
```

## Configuration File Paths

| File | Purpose |
|------|---------|
| `~/.config/wireplumber/wireplumber.conf.d/90-my_audio_interface.conf` | Audio interface configuration |
| `~/.config/pipewire/pipewire.conf.d/99-rt.conf` | PipeWire real-time settings |
| `~/.config/pipewire/jack.conf.d/custom.conf` | JACK compatibility settings |
| `/etc/default/grub` | Kernel parameters (needs sudo) |
| `/etc/security/limits.d/20-audio.conf` | Real-time priority limits |
| `~/.wine/drive_c/` | Windows environment files |

## Debugging

```bash
# Full system check
echo "=== CPU Governor ==="
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo ""
echo "=== SMT Status ==="
cat /sys/devices/system/cpu/smt/control
echo ""
echo "=== Swappiness ==="
sysctl vm.swappiness
echo ""
echo "=== JACK Latency ==="
pw-cli info 0 | grep node.latency
echo ""
echo "=== Real-Time Status ==="
rtcqs | head -10

# Find audio interface latency
jack_iodelay

# Check running audio processes
ps aux | grep -E "tonex|amplitube|wine|pipewire" | grep -v grep

# Monitor real-time
watch -n 0.5 "ps aux | grep -E 'tonex|wine|jack' | grep -v grep"
```

## Troubleshooting

```bash
# Restart PipeWire
systemctl --user restart wireplumber pipewire pipewire-pulse

# Reset CPU scaling
sudo cpupower frequency-set -g schedutil

# Re-enable SMT
echo on | sudo tee /sys/devices/system/cpu/smt/control

# Reload USB audio
sudo modprobe -r snd_usb_audio
sudo modprobe snd_usb_audio

# Clear Wine prefix (nuclear option)
rm -rf ~/.wine
winecfg  # Recreates fresh prefix
```

## Create Launcher Scripts

```bash
# Tonex launcher
cat > ~/launch_tonex.sh << 'EOF'
#!/bin/bash
chrt -f 70 wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/TONEX/TONEX.exe
EOF
chmod +x ~/launch_tonex.sh

# Amplitube launcher
cat > ~/launch_amplitube.sh << 'EOF'
#!/bin/bash
chrt -f 70 wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/Amplitube/Amplitube.exe
EOF
chmod +x ~/launch_amplitube.sh

# Run them
~/launch_tonex.sh
~/launch_amplitube.sh
```

## Performance Optimization (Advanced)

```bash
# Check and limit CPU frequency to max performance
sudo cpupower frequency-info
sudo cpupower frequency-set -f 3.9GHz  # Set to specific frequency

# Isolate CPU cores for audio (advanced)
# Edit /etc/default/grub: isolcpus=2,3
# Then: sudo grub-mkconfig -o /boot/grub/grub.cfg

# Monitor thermal throttling
watch -n 1 "cat /proc/cpuinfo | grep MHz"

# Check DMA usage
cat /proc/interrupts | head -20
```

## Safety Checks Before Use

```bash
# Always verify after configuration
rtcqs                    # Should show mostly PASS
jack_iodelay             # Should show 5-8ms
pw-cli list-objects Device | grep device.nick  # Should show interface
ps aux | grep pipewire   # Should show running
ps aux | grep wireplumber # Should show running
```

---

**Pro Tip**: Save frequently-used commands in `.bashrc` or create aliases:

```bash
# Add to ~/.bashrc
alias rtcheck="rtcqs && echo '' && pw-cli list-objects Device | grep device.nick"
alias testlatency="jack_iodelay"
alias ik-manager="wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/IK\ Product\ Manager/IK\ Product\ Manager.exe"
alias tonex="chrt -f 70 wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/TONEX/TONEX.exe"
alias amplitube="chrt -f 70 wine ~/.wine/drive_c/Program\ Files/IK\ Multimedia/Amplitube/Amplitube.exe"

# Then use:
# rtcheck
# testlatency
# tonex
# amplitube
```
