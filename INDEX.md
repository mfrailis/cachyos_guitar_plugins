# Documentation Structure

## 📚 Complete Guide to CachyOS Real-Time Guitar Setup

This repository contains comprehensive documentation for setting up Amplitube and Tonex on CachyOS through Wine with professional low-latency real-time audio performance.

---

## 📖 Table of Contents

### Getting Started
- **[README.md](README.md)** - Overview and quick start guide
- **[QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md)** - Handy command reference

### Step-by-Step Guides

1. **[Prerequisites & Installation](docs/01-prerequisites.md)**
   - System requirements
   - Package installation
   - Dependency verification

2. **[Wine & DXVK Setup](docs/02-wine-setup.md)**
   - Creating Windows environment
   - Installing DXVK (GPU acceleration)
   - Registering WineASIO

3. **[System Optimization](docs/03-system-optimization.md)**
   - CPU performance tuning
   - Kernel parameter configuration
   - Real-time priority setup

4. **[Audio Interface Configuration](docs/04-audio-interface.md)**
   - PipeWire/WirePlumber setup
   - Audio routing configuration
   - Profile optimization

5. **[Latency Testing](docs/05-latency-testing.md)**
   - Measuring system latency
   - Loopback cable setup
   - Performance verification

6. **[IK Multimedia Installation](docs/06-ik-multimedia.md)**
   - Downloading IK Product Manager
   - Installing Amplitube & Tonex
   - Initial configuration
   - Launching applications

7. **[DAW & VST Plugins](docs/07-daw-vst-plugins.md)**
   - Installing Reaper DAW
   - Configuring Yabridge for Windows VST plugins
   - Loading Amplitube/TONEX as VST3 in Reaper

### Support & Reference

- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Problem solving guide
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and updates
- **[LICENSE.md](LICENSE.md)** - MIT License

### Media Assets

- **[docs/resources/](docs/resources/)** - Screenshots and video demonstrations
  - `jack_delay_test.mp4` - Latency testing short video demonstration
  - \*.png - various configuration screenshots


---

## 🎯 What You'll Achieve

After following this guide:

✓ Low-latency real-time audio processing (6-8ms roundtrip)  
✓ Amplitube and Tonex running on CachyOS  
✓ Professional-grade guitar effects and modeling  
✓ Stable, dropout-free operation  
✓ Optimized system for real-time audio workloads  
✓ Windows VST plugins working in Linux DAW (Reaper)  

---

## 🔍 Quick Navigation

**Choose your starting point:**

- **New to Linux audio?** Start with [README.md](README.md)
- **Just want commands?** Go to [QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md)
- **Troubleshooting?** Check [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- **Step-by-step?** Follow [docs/01-prerequisites.md](docs/01-prerequisites.md)
- **DAW setup?** Jump to [docs/07-daw-vst-plugins.md](docs/07-daw-vst-plugins.md)
- **Already setup, need clarification?** Specific section numbers above

---

## 📱 System Requirements

- **OS**: CachyOS (Arch-based Linux)
- **CPU**: Modern multi-core (Intel/AMD)
- **RAM**: 8GB+ (16GB recommended)
- **GPU**: integrated or discrete GPU desired
- **Audio Interface**: USB interface with low latency and compatible with Linux
- **Storage**: at leats 80GB of free space

---

## 🎸 Tested Hardware

| Component | Model | Status |
|-----------|-------|--------|
| **Audio Interface** | AXE I/O Solo | ✓ Working |
| **GPU** | AMD Radeon | ✓ Working |
| **CPU** | Multi-core (Ryzen/Intel) | ✓ Working |
| **Distro** | CachyOS | ✓ Working |

*Have different hardware? Test and report!*

---

## 🚀 Quick Start (Experienced Users)

```bash
# Copy the commands from QUICK_REFERENCE.md installation section
# See TROUBLESHOOTING.md if anything breaks
```
---

## 📜 License

MIT License - See [LICENSE.md](LICENSE.md) for details

---

## 🎵 Let's Make Some Music!

You're now ready to use professional guitar effects on Linux. Happy playing! 🎸

---

**Last Updated**: February 2026  
**Version**: 1.0  
**Status**: Complete and tested
