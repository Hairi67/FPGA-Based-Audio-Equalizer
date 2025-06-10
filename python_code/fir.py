import numpy as np
import scipy.signal as signal
import scipy.io.wavfile as wavfile
import matplotlib.pyplot as plt

input_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/samples/audio.wav'

# Read the input .wav file
sample_rate, data = wavfile.read(input_path)

# Create own sample
#sample_rate = 44100
#freq_cl = 1000
#freq_ns = 150
#t = np.linspace(0, 1.0, sample_rate)
#data = 10*np.sin(2*freq_cl*np.pi*t) + 5*np.cos(2*freq_ns*np.pi*t)

# Design a FIR bandpass filter using the Hamming window
numtaps = 30  # Number of filter taps (adjust as needed)
low_cutoff = 4000  # Low cutoff frequency in Hz
high_cutoff = 20000  # High cutoff frequency in Hz
nyquist_rate = sample_rate / 2.0
cutoff = [low_cutoff / nyquist_rate, high_cutoff / nyquist_rate]
fir_coeff = signal.firwin(numtaps, cutoff, window='hamming', pass_zero='bandpass')
#txt_coeff = []
for i in range (0, numtaps):
    #print(f'Coeffi[{i}] = {fir_coeff[i]}')
    print(fir_coeff[i])
    #txt_coeff.append(fir_coeff[i])


print(f'Writing file successfully')

# Apply the filter to the data
filtered_data = signal.lfilter(fir_coeff, 1.0, data)

output_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/output_wav/audio.wav'

# Write the filtered data to a new .wav file
wavfile.write(output_path, sample_rate, filtered_data.astype(np.int16))

# Plot the original and filtered signals
plt.figure(figsize=(12, 6))
plt.subplot(2, 1, 1)
plt.plot(data, label='Original Signal')
plt.legend()
plt.subplot(2, 1, 2)
plt.plot(filtered_data, label='Filtered Signal', color='orange')
plt.legend()
plt.show()
