## Changelog

### Version 1.1 - DAW Integration (February 2026)

**New Features:**
- Added DAW and VST plugin guide ([07-daw-vst-plugins.md](docs/07-daw-vst-plugins.md))
- Reaper installation and configuration
- Yabridge setup for Windows VST3 plugin bridging
- Amplitube and TONEX as VST3 plugins in Linux DAW

**Documentation Updates:**
- Updated README with DAW section reference
- Updated INDEX with new section and adjusted time estimates
- Added yabridge commands to QUICK_REFERENCE
- Added yabridge/DAW troubleshooting to TROUBLESHOOTING guide

---

### Version 1.0 - Initial Release (February 2026)

**Features:**
- Complete setup guide for CachyOS real-time guitar processing
- Step-by-step configuration for Wine + Amplitube + Tonex
- System optimization for low-latency real-time audio
- PipeWire/WirePlumber audio routing configuration
- Latency testing and measurement procedures
- Comprehensive troubleshooting guide
- Quick reference commands

**Hardware Tested:**
- CachyOS (latest)
- AXE I/O Solo audio interface
- AMD GPU
- Intel/AMD multi-core CPU

**Known Working:**
- ✓ Round-trip latency: 6-7ms
- ✓ Amplitube real-time performance
- ✓ Tonex tone capture and modeling
- ✓ Stable operation under 12-hour sessions
- ✓ Multiple effects without dropout

**Notes:**
- Guide assumes some Linux command-line familiarity
- Tested on CachyOS - may work on other Arch-based distributions
- Performance depends on audio interface quality and USB implementation

---

### Feedback & Contributions

If you:
- Found this guide helpful
- Tested on different hardware
- Have improvements or clarifications
- Fixed additional issues

Please open a GitHub issue or pull request!

### Future Improvements

- [x] DAW integration guide (Reaper, etc.)
- [x] VST plugin usage in Linux DAWs
- [ ] Additional DAW guides (Ardour, Bitwig)
- [ ] Native Linux plugin alternatives
