# FPGA-Based-Audio-Equalizer
This project implements a 3-band audio equalizer on an FPGA, designed using IIR and FIR filters to manipulate different frequency ranges of an audio signal in real time. The goal is to filter and adjust the gain of low (bass), mid, and high (treble) frequency bands to enhance sound quality according to user preferences.

---

## 📌 Table of Contents

- [🔍 Overview](#-overview)
- [🌟 Features](#-features)
- [🛠️ Filter Design](#-filter-design)
- [🔉 Gain Control](#-gain-control)
- [🧰 Tools & Technologies](#-tools--technologies)
- [📊 Results](#-results)
- [📄 License](#-license)

---

## 🔍 Overview

An audio equalizer is a tool used to adjust the frequency components of an audio signal to enhance its quality or suit listener preferences. This project demonstrates a simplified 3-band equalizer, dividing the signal into:

- **Bass** (20–300 Hz)
- **Mid** (300–4000 Hz)
- **Treble** (4000–20000 Hz)

Each frequency band is filtered and individually controlled for gain, then recombined to produce the final output signal.

---

## 🌟 Features

- **IIR Filter** for Bass: Low-pass, 4th order, efficient on FPGA resources.
- **FIR Filters** for Mid and Treble: Band-pass, 40-tap and 30-tap respectively, stable and accurate.
- **Real-time Gain Control** via FPGA switches:
  - `00`: Keep signal unchanged
  - `01`: Mute signal
  - `10`: Increase gain by +6 dB
  - `11`: Decrease gain by -6 dB
- **Signal Aggregation Module** to combine the processed bands.

---

## 🛠️ Filter Design
🎚️ Bass Filter (20–300 Hz)

- Type: IIR
- Order: 4
- Cutoff Frequency: 300 Hz
- Advantages: Efficient, low resource usage.

🎚️ Mid Filter (300–4000 Hz)
- Type: FIR
- Taps: 40
- Cutoff Frequencies: 300 Hz – 4 kHz
- Advantages: High accuracy and stability.

🎚️ Treble Filter (4–20 kHz)
- Type: FIR
- Taps: 30
- Cutoff Frequencies: 4 kHz – 20 kHz
- Advantages: Preserves high-frequency details.

---
    
## 🔉 Gain Control

Each band’s gain is controlled using two bits from the FPGA’s onboard switches:
- 00: Original gain
- 01: Mute (0x)
- 10: Boost by 6 dB (~×2)
- 11: Attenuate by 6 dB (~×0.5)

Implemented via arithmetic shifts for efficiency.

---

## 🧰 Tools & Technologies
- Python / MATLAB: Filter design and FFT analysis
- Quartus Prime: RTL implementation
- ModelSim: Simulation and waveform analysis
- Verilog HDL: Hardware design language

---

## 📊 Results
- Accurate separation of frequency bands using IIR/FIR filters.
- Gain control functionality verified via testbenches.
- Combined output signal closely matches theoretical expectations from MATLAB/Python simulations.

Waveform results are available in the images/ directory.

---

## 📄 License

This project is licensed under the MIT License. See LICENSE for more details.
