# System Optimization for Real-Time Audio

This section configures CachyOS for optimal real-time performance. These settings reduce latency and prevent system interruptions that could cause audio glitches.

## Step 1: CPU Performance Scaling

Enable maximum CPU performance mode:

```bash
sudo powerprofilesctl set performance
```

**What this does:**
- Sets CPU to always run at maximum frequency
- Prevents frequency scaling from introducing latency spikes
- Essential for consistent real-time performance

### Disable SMT (Simultaneous Multi-Threading)

```bash
echo off | sudo tee /sys/devices/system/cpu/smt/control
```

**Why disable SMT?**
- SMT allows multiple threads per core, which can introduce timing unpredictability
- Real-time audio requires predictable latency
- Disabling improves determinism, reducing glitches
- Modern CPUs have enough performance even without SMT

### Adjust Swap Behavior

```bash
sudo sysctl -w vm.swappiness=10
```

**What this does:**
- Reduces system swapping (paging memory to disk)
- Swapping introduces unpredictable delays that destroy real-time performance
- Value of 10 = very conservative swapping (good for audio)

### USB Auto-Suspend Control

```bash
echo -1 | sudo tee /sys/module/usbcore/parameters/autosuspend
```

**Why important?**
- Disables USB autosuspend (-1 means disabled)
- USB suspend/resume creates unpredictable latency
- Audio interfaces are USB devices that need consistent power delivery
- This prevents the OS from suspending your audio interface

### Make settings persist after a reboot

The settings above will be lost after a reboot. To make them persistent, use the `studio-mode.service` systemd service provided in the `scripts` folder of this project. This service automatically applies all of the above settings at boot.

To install it:

```bash
sudo cp scripts/studio-mode.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable studio-mode.service
sudo systemctl start studio-mode.service
```


## Step 2: Kernel Parameters for Preemption

Full kernel preemption is critical for real-time performance.

### Edit GRUB Configuration

```bash
sudo nano /etc/default/grub
```

Find the line starting with `GRUB_CMDLINE_LINUX_DEFAULT`. It will look something like:

```
GRUB_CMDLINE_LINUX_DEFAULT='nowatchdog quiet splash ..other parameters...'
```

Add `preempt=full` to the end (before the closing quote):

```
GRUB_CMDLINE_LINUX_DEFAULT='nowatchdog quiet splash ...other parameters... preempt=full'
```

### Apply Kernel Parameters

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Alternative Bootloaders

If you're using **Limine** or another bootloader instead of GRUB, see the [CachyOS Boot Manager Documentation](https://wiki.cachyos.org/configuration/boot_manager_configuration/#limine).

### Reboot Required

```bash
sudo reboot
```

After reboot, these kernel parameters will be active.

## Step 3: Real-Time Audio Permissions

Allow audio group users to have real-time priority.

### Edit Audio Limits

```bash
sudo nano /etc/security/limits.d/20-audio.conf
```

Add these lines:

```
@audio - rtprio 99
@audio - memlock unlimited
```

**What these mean:**
- `@audio` = all users in the "audio" group
- `rtprio 99` = allow real-time priority up to level 99 (highest)
- `memlock unlimited` = prevent audio memory from being paged to disk

### Make User an Audio Group Member

```bash
sudo usermod -a -G audio $USER
```

**Important**: Log out and log back in for this to take effect.

## Step 4: Verify Real-Time Configuration

Run the real-time checker:

```bash
rtcqs
```

### Expected Output

You should see:

```
=== Real-Time Configuration Query System ===
[  OK  ] Not running as root
[  OK  ] sufficient rtprio and memlock limits  
[  OK  ] Scaling governor set to performance
[  OK  ] Simultaneous Multithreading disabled
...

Spectre/Meltdown Mitigations
============================
[ WARNING ] Kernel with Spectre/Meltdown mitigations found
```

### Understanding the Results

- ✓ **OK items**: Your system is properly configured
- ⚠ **WARNING about Spectre/Meltdown**: This is expected and acceptable. Modern kernels have these mitigations enabled for security. The performance impact is minimal for audio work.

## Summary of Changes

| Change | Effect | Revert With |
|--------|--------|-------------|
| CPU performance mode | Lower latency | `sudo powerprofilesctl set performance` |
| SMT disabled | More predictable | `echo on \| sudo tee /sys/devices/system/cpu/smt/control` |
| Low swappiness | Prevents disk I/O delays | `sudo sysctl -w vm.swappiness=60` |
| USB suspend off | Consistent USB power | `echo 2 \| sudo tee /sys/module/usbcore/parameters/autosuspend` |
| Full preemption | Responsive kernel | Remove `preempt=full` from GRUB and rerun `grub-mkconfig` |

## Next Steps

Proceed to [Audio Interface Configuration](04-audio-interface.md) to set up your audio hardware.

## Alternative Solutions

There are alternative methods to persist these settings (CPU scaling performance, SMT, swappiness, and USB autosuspend). The systemd service approach above is provided for simplicity and portability. In the scripts folder, I also provide an `apply-audio-tuning.sh` script that can be run on demand with sudo:

```bash
chmod +x scripts/apply-audio-tuning.sh
sudo scripts/apply-audio-tuning.sh
```

---

## Troubleshooting

**Q: `rtcqs` shows FAIL for preemption**  
A: Make sure you rebooted after running `grub-mkconfig`. Changes don't take effect until next boot.

**Q: Audio group membership not recognized**  
A: You must log out completely and log back in. Session restart alone won't work. Try opening a new terminal to confirm: `groups $USER` should show "audio".

**Q: GRUB configuration won't update**  
A: Make sure you're editing the correct file and using `sudo`. Check: `grep preempt /proc/cmdline` to verify current kernel parameters.
