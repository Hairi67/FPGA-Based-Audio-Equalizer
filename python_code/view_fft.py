import numpy as np
import matplotlib.pyplot as plt

# Assuming `audio.hex` contains hex values of audio samples
# Read the hex file and convert it to a numpy array

#source_path = 'C:/Users/Asus/Documents/GitHub/EE3041_DSPonFPGA/Lab1/samples/ecg.hex'
hex_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/samples/audio.hex'

# Read the hex file
with open(hex_path, 'r') as file:
    hex_data = file.read().splitlines()

# Convert hex data to integers
data = [int(x, 16) for x in hex_data]

# Ensure the data is a numpy array
data = np.array(data)

# Compute the FFT
sample_rate = 44100  # Given sample rate
n = len(data)
fft_data = np.fft.fft(data)
fft_data = np.abs(fft_data)[:n//2]  # Take the positive half of the FFT

# Create the frequency axis
frequencies = np.fft.fftfreq(n, d=1/sample_rate)[:n//2]

# Plot the FFT
plt.figure()
plt.plot(frequencies, fft_data)
plt.title('Frequency Spectrum of Hex File')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.grid()
plt.show()
