# SoundFilter

**Purpose:**  
Designs and applies a Butterworth low-pass filter to a noisy audio signal for noise removal.

---

# filter_design.m

**What it does**  
This MATLAB script guides you through a complete Butterworth low-pass filtering workflow to remove unwanted noise from an audio recording. Internally, it:

1. **Loads** your noisy WAV file.  
2. **Analyzes** its frequency content and displays a spectrum plot.  
3. **Designs** a Butterworth low-pass filter to meet your passband/stopband requirements.  
4. **Applies** the filter and shows the before-and-after spectra.  
5. **Plays back** both the original and the cleaned audio so you can hear the difference.  
6. **Saves** the filtered result as a new WAV file.

---

**How to use it**  
1. Open **filter_design.m** in MATLAB.  
2. Set your input filename (e.g. `'noisyaudio.wav'`) and desired output filename.  
3. Adjust the passband and stopband edge frequencies in the script header if needed.  
4. Run the script:  
   ```matlab
   >> filter_design

