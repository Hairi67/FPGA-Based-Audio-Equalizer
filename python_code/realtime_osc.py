import pyaudio
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Audio settings
CHUNK = 131072
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100

# Initialize PyAudio
p = pyaudio.PyAudio()
stream = p.open(format=FORMAT, channels=CHANNELS, rate=RATE, input=True, frames_per_buffer=CHUNK)

# Initialize plot
fig, ax = plt.subplots()
x = np.arange(0, CHUNK)
line, = ax.plot(x, np.zeros(CHUNK))
ax.set_ylim(-32768, 32767)

# Update function for animation
def update(frame):
    data = np.frombuffer(stream.read(CHUNK), dtype=np.int16)
    line.set_ydata(data)
    return line,

# Start the animation
ani = animation.FuncAnimation(fig, update, interval=30)
plt.show()
