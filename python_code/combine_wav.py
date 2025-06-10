import numpy as np
import wave
import struct

# Path
clear_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/clear_wav/sine_8000.wav'
clear_hex = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/clear_wav/sine_8000.hex'
wav_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/wav_samples/sine_8000.wav'
hex_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/hex_samples/sine_8000.hex'

# Parameters
sample_rate = 44100  # 44.1 kHz
duration = 0.05  # seconds
frequency = 4500  # 8 kHz sine wave
ns_freq = 1000

# Generate a sine wave signal
t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)
sine_wave = 0.5 * np.sin(2 * np.pi * frequency * t)

# Generate white noise
#white_noise = np.random.normal(0, 0.5, t.shape)
white_noise = 0.5 * np.sin(2 * np.pi * ns_freq * t)

# Normalize the sine wave signal
sine_wave_normalized = np.int16(sine_wave / np.max(np.abs(sine_wave)) * 32767)

# Mix the sine wave with white noise
mixed_signal = sine_wave + white_noise

# Normalize the mixed signal
mixed_signal_normalized = np.int16(mixed_signal / np.max(np.abs(mixed_signal)) * 32767)

# Write the sine wave signal to a .wav file
wav_file = wave.open(clear_path, 'w')
wav_file.setnchannels(1)  # mono
wav_file.setsampwidth(2)  # 16 bits per sample
wav_file.setframerate(sample_rate)
wav_file.writeframes(sine_wave_normalized.tobytes())
wav_file.close()

# Write the mixed signal to a .wav file
wav_file = wave.open(wav_path, 'w')
wav_file.setnchannels(1)  # mono
wav_file.setsampwidth(2)  # 16 bits per sample
wav_file.setframerate(sample_rate)
wav_file.writeframes(mixed_signal_normalized.tobytes())
wav_file.close()

# Convert the sine wave .wav file to .hex format
with open(clear_path, 'rb') as wavfile:
    wav_data = wavfile.read()

hex_lines = []
for i in range(0, len(wav_data), 3):
    chunk = wav_data[i:i+3]
    if len(chunk) < 3:
        chunk = chunk.ljust(3, b'\0')  # Pad with zeros if less than 3 bytes
    hex_value = struct.unpack('>I', b'\0' + chunk)[0]  # Convert to 24-bit integer
    hex_lines.append(f"{hex_value:06x}")

with open(clear_hex, 'w') as hexfile:
    for line in hex_lines:
        hexfile.write(f"{line}\n")

# Convert the mixed signal .wav file to .hex format
with open(wav_path, 'rb') as wavfile:
    wav_data = wavfile.read()

hex_lines = []
for i in range(0, len(wav_data), 3):
    chunk = wav_data[i:i+3]
    if len(chunk) < 3:
        chunk = chunk.ljust(3, b'\0')  # Pad with zeros if less than 3 bytes
    hex_value = struct.unpack('>I', b'\0' + chunk)[0]  # Convert to 24-bit integer
    hex_lines.append(f"{hex_value:06x}")

with open(hex_path, 'w') as hexfile:
    for line in hex_lines:
        hexfile.write(f"{line}\n")

print("Files 'sine_wave.wav', 'sine_wave.hex', 'mixed_signal.wav', and 'mixed_signal.hex' have been generated.")
