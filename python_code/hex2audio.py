import numpy as np
import wave

def hex_to_pcm(hex_file_path, bits=24):
    with open(hex_file_path, 'r') as file:
        hex_lines = file.readlines()
    
    pcm_data = []
    for line in hex_lines:
        hex_value = line.strip()
        if hex_value:
            int_value = int(hex_value, 16)
            if int_value >= (1 << bits-1):
                int_value -= (1 << bits)
            pcm_data.append(int_value)
    
    return np.array(pcm_data, dtype=np.int32)

def pcm_to_wav(pcm_data, output_wav_path, sample_rate=44100):
    # Normalize PCM data to fit in 16-bit range
    max_val = np.max(np.abs(pcm_data))
    pcm_data = np.int16(pcm_data * (32767 / max_val))  # Scale to 16-bit PCM
    
    with wave.open(output_wav_path, 'w') as wav_file:
        num_channels = 1
        sampwidth = 2  # 16 bits
        nframes = len(pcm_data)
        comptype = "NONE"
        compname = "not compressed"
        
        wav_file.setparams((num_channels, sampwidth, sample_rate, nframes, comptype, compname))
        wav_file.writeframes(pcm_data.tobytes())

hex_file_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/output_hex/output.hex'
output_wav_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/output_wav/output.wav'

# Convert hex file to PCM data
pcm_data = hex_to_pcm(hex_file_path)

# Convert PCM data to WAV file
pcm_to_wav(pcm_data, output_wav_path)
