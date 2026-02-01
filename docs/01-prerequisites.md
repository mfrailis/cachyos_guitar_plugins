# Prerequisites & Package Installation

Before you begin, ensure you have administrative access via `sudo` and a working internet connection.

## Step 1: Update System

First, ensure your CachyOS system is up to date:

```bash
sudo pacman -Syu
```

## Step 2: Install Required Packages

Install all necessary packages in one command:

```bash
sudo pacman -S pipewire-jack \
                jack-example-tools \
                qpwgraph \
                wine-cachyos \
                winetricks \
                cpupower
```

### Package Explanations

| Package | Purpose |
|---------|---------|
| `pipewire-jack` | JACK compatibility layer for PipeWire (replaces traditional JACK) |
| `jack-example-tools` | Utilities for JACK including `jack_iodelay` for latency measurement |
| `qpwgraph` | Visual graph editor for PipeWire/JACK routing |
| `wine-cachyos` | CachyOS optimized Wine build for running Windows applications |
| `winetricks` | Helper script to install Windows software/DLLs in Wine |
| `cpupower` | Tool for CPU frequency scaling and performance tuning |

### Resolving Package Conflicts

If prompted about conflicting packages:

```
:: pipewire-jack-1:1.4.10-1.1 and jack-0.126.0-6 are in conflict. Remove jack? [y/N]
```

**Answer: `y`** - We're using PipeWire's JACK compatibility, not standalone JACK.

## Step 3: Install Additional Audio Tools

Install WineASIO and real-time configuration tool:

```bash
paru -S rtcqs \
        wineasio
```

### WineASIO Selection

When prompted to choose a version:
```
 1) wineasio  2) wineasio-git
Enter a number (default=1):
```

**Choose: `1`** (stable version)

A script will display. Simply press:
1. `q` to exit the script
2. `y` to accept changes

### Verifying Installation

Check your Wine version:

```bash
wine --version
```

You should see output like:
```
wine-10.0-20260101 (CachyOS)
```

## Step 4: Create Wine Prefix

Create a symbolic link that WineASIO needs:

```bash
sudo ln -s /usr/bin/wine /usr/bin/wine64
```

## Next Steps

Proceed to [Wine & DXVK Setup](02-wine-setup.md) to configure your Wine environment.

---

## Troubleshooting

**Q: Installation fails with "package not found"**  
A: Run `sudo pacman -Syu` first to sync package databases, then try again.

**Q: Wine version doesn't show CachyOS?**  
A: You may have a different Wine installation. Reinstall with `sudo pacman -S wine-cachyos`.

**Q: `paru` command not found?**  
A: Install with `sudo pacman -S paru`, or use `yay` if you prefer.
