import numpy as np
import wave

def wav_to_pcm(wav_file_path):
    with wave.open(wav_file_path, 'r') as wav_file:
        num_channels = wav_file.getnchannels()
        sampwidth = wav_file.getsampwidth()
        sample_rate = wav_file.getframerate()
        nframes = wav_file.getnframes()
        
        # Read PCM data from WAV file
        pcm_data = wav_file.readframes(nframes)
        pcm_data = np.frombuffer(pcm_data, dtype=np.int32)  # Assuming 32-bit PCM data
        return pcm_data, sample_rate

def pcm_to_hex(pcm_data, hex_file_path, bits=24):
    with open(hex_file_path, 'w') as hex_file:
        for sample in pcm_data:
            sample = int(sample)
            # Convert to bits-bit signed integer (extend 16-bit PCM)
            if sample < 0:
                sample += (1 << 32)
            sample = sample >> (32-bits)
            hex_file.write(f'{sample:06x}\n')

# Example usage
wav_file_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/output_wav/audio.wav'
hex_file_path = 'D:/Code/pycode/dsp_fpga/lab3_aud_eql/output_hex/audio.hex'

# Convert WAV file back to PCM data
pcm_data, sample_rate = wav_to_pcm(wav_file_path)
# Convert PCM data to hex file
pcm_to_hex(pcm_data, hex_file_path)
