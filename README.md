# SoundFilter

**Purpose:**  
Designs and applies a Butterworth low-pass filter to a noisy audio signal for noise removal.

---

**What it does**  
This MATLAB script guides you through a complete Butterworth low-pass filtering workflow to remove unwanted noise from an audio recording. Internally, it:

1. **Loads** your noisy WAV file.  
2. **Analyzes** its frequency content and displays a spectrum plot by using Discrete Fourier Transform (DFT).  
3. **Applies** Impulse Invariance method to design an analog filter.
4. **Designs** a Butterworth low-pass filter to meet your passband/stopband requirements.
5. **Applies** the filter and shows the before-and-after spectra.  
6. **Plays back** both the original and the cleaned audio so you can hear the difference.  
7. **Saves** the filtered result as a new WAV file.

---

**Filter Design Details**

- **Speech Frequency Range:**  
  The passband edge is set to **2000 Hz** because human speech typically occupies the 100 Hz–2 kHz band.  

- **High-Frequency Noise Removal:**  
  Significant noise tends to appear above **2.5 kHz**, so the stopband edge is chosen accordingly to attenuate these components.  

- **Design Objective:**  
  Preserve the integrity of speech frequencies up to ~2 kHz while effectively suppressing unwanted high-frequency noise, resulting in clearer, more intelligible audio.

---

**How to use it**  
1. Open **filter_design.m** in MATLAB.  
2. Set your input filename (e.g. `'noisyaudio.wav'`) and desired output filename.  
3. Adjust the passband and stopband edge frequencies in the script header if needed.  
4. Run the script:  
   ```matlab```
   ```
   >> filter_design
