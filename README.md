# CachyOS Real-Time Guitar Setup

A comprehensive guide to configuring CachyOS for low-latency real-time guitar processing using IK Multimedia's Amplitube and Tonex through Wine.

## Overview

This guide walks you through setting up a professional-grade real-time guitar processing environment on CachyOS using:
- **Amplitube** - Real-time guitar amplifier and effects modeling
- **Tonex** - Tone capture and modeling technology
- **Wine** - Windows application compatibility layer
- **PipeWire/JACK** - Professional audio routing

The configuration targets latencies around **7ms roundtrip**, making it suitable for real-time guitar playing without noticeable delay.

## Quick Start

1. [Prerequisites & Installation](docs/01-prerequisites.md)
2. [Wine & DXVK Setup](docs/02-wine-setup.md)
3. [System Optimization](docs/03-system-optimization.md)
4. [Audio Interface Configuration](docs/04-audio-interface.md)
5. [Latency Testing](docs/05-latency-testing.md)
6. [IK Multimedia Installation](docs/06-ik-multimedia.md)

## System Requirements

- **OS**: CachyOS (any recent version)
- **Audio Interface**: USB audio interface with JACK support (tested with AXE I/O Solo)
- **RAM**: 8GB minimum (16GB recommended)
- **CPU**: Modern multi-core processor with frequency scaling support
- **GPU**: Dedicated GPU recommended (tested with AMD)

## What You'll Learn

- Installing and configuring Wine for audio plugin compatibility
- Setting kernel parameters for real-time performance
- Configuring PipeWire/WirePlumber for low-latency audio
- Measuring and optimizing system latency
- Installing and running Windows audio software on Linux

## Expected Results

- **Roundtrip Latency**: ~7ms (human imperceptible for guitar playing)
- **Buffer Size**: 128 samples at 48kHz
- **Stability**: Stable real-time performance without dropouts

## Troubleshooting & Support

Each guide section includes clarifications and common issues. If you encounter problems:
- Check the specific section's troubleshooting notes
- Run `rtcqs` to verify system real-time capabilities
- Verify your audio interface is recognized with `pw-cli list-objects Device`

## Hardware Setup

1. Connect USB audio interface to computer
2. Connect guitar to interface input
3. Connect interface output to speakers/headphones or loop-back cable for latency testing

## Video Demo

See [Jack_delay_test.mp4](./Jack_delay_test.mp4) for a demonstration of the latency testing procedure.

---

**Last Updated**: February 2026  
**Status**: Tested and Working ✓  
**Tested Hardware**: AXE I/O Solo, AMD GPU, CachyOS
