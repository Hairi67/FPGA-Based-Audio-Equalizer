import numpy as np
import scipy.signal as signal
import scipy.io.wavfile as wavfile
import matplotlib.pyplot as plt

input_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/samples/audio.wav'

# Read the input .wav file
# Using samples
sample_rate, data = wavfile.read(input_path)
# Create own samples
#sample_rate = 44100
#freq_cl = 150
#freq_ns = 16789
#t = np.linspace(0, 1.0, 22050)
#data = 10*np.sin(2*freq_cl*np.pi*t) + 5*np.cos(2*freq_ns*np.pi*t)

#data_scaled = np.round(data * (2**15)).astype(int)
#max_data = np.max(data)
#min_data = np.min(data)
#print(f'data = {data}')
#print(f'max = {max_data}')
#print(f'max = {min_data}')
print(f'sample rate = {sample_rate}')

# Design a IIR bandpass filter using the Hamming window
numtaps = 4  # Number of filter taps (adjust as needed)
#low_cutoff = 20  # Low cutoff frequency in Hz
high_cutoff = 500  # High cutoff frequency in Hz
nyquist_rate = sample_rate / 2.0
cutoff = [high_cutoff / nyquist_rate] #[low_cutoff / nyquist_rate, high_cutoff / nyquist_rate]
#sos = []
b, a = signal.iirfilter(numtaps, cutoff, btype= 'lowpass', analog=False, ftype='butter')
#sos[0][0] = 1
#sos[0][1] = 2
#sos[0][2] = 1
#sos_scaled = np.round(sos * (2**15)).astype(int)
#print(sos)

#for i in range(0, 2):
    #for j in range (0, 3):
        #print(f'{sos_scaled[i][j]}, ')
#print()

#for i in range(0, 2):
    #for j in range (4, 6):
        #print(f'{sos_scaled[i][j]}, ')

#print()

#for i in range(0, 2):
    #g = np.round(((sos[i][3] + sos[i][4] + sos[i][5])/4)*(2**15)).astype(int)
    #print(f'{g}, ')    
    

#for i in range (0, numtaps):
    #print(f'Coeffi[{i}] = {fir_coeff[i]}')
    #txt_coeff.append(fir_coeff[i])

#b, a = signal.zpk2tf(z, p, k)

print(f'Writing file successfully')

filtered_data = signal.lfilter(b, a, data)
#a = np.round(a * (2**25)).astype(int)
#b = np.round(b * (2**25)).astype(int)
print(f'a = {a}')
print(f'b = {b}')

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

