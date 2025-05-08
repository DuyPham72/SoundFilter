# SoundFilter

**Purpose:**  
Designs and applies a Butterworth low-pass filter to a noisy audio signal for noise removal.

---

### Workflow & Key Equations

1. **Audio Frequency Analysis**  
   - **Read audio:**  
     ```matlab
     [x[n], F_s] = audioread('noisyaudio.wav');
     ```  
   - **Compute DFT via FFT:**  
     \[
       X[k] = \sum_{n=0}^{N-1} x[n]\;e^{-j\,2\pi k n / N}
     \]  
     plotted with  
     ```matlab
     fft(x);
     plot(f, abs(X));
     ```

2. **Filter Specifications**  
   - **Passband & Stopband Edges (Hz):**  
     \(f_p = 2000,\;f_s = 2500\)  
   - **Digital frequencies:**  
     \[
       \omega_p = 2\pi\,\frac{f_p}{F_s},\quad
       \omega_s = 2\pi\,\frac{f_s}{F_s}
     \]  
   - **Measured magnitudes at edges:**  
     \[
       M_p = \text{avg }\{\,|X[k]|\text{ around }\omega_p\},\quad
       M_s = \text{avg }\{\,|X[k]|\text{ around }\omega_s\}
     \]  
   - **Required stopband attenuation (dB):**  
     \[
       A_s = -20\,\log_{10}\bigl(M_s / M_p\bigr)
     \]

3. **Analog Prototype Pre-Warping**  
   - **Sampling period:** \(T = 1/F_s\)  
   - **Analog edges (rad/s):**  
     \[
       \Omega_p = \omega_p / T,\quad
       \Omega_s = \omega_s / T
     \]

4. **Butterworth Order & Cutoff**  
   - **Ripple factors:**  
     \[
       k_p = 10^{0.1 A_p} - 1,\quad
       k_s = 10^{0.1 A_s} - 1
     \]  
     with \(A_p = 1\) dB.  
   - **Filter order:**  
     \[
       N = \left\lceil
         \frac{\ln(k_s / k_p)}{2\,\ln(\Omega_s / \Omega_p)}
       \right\rceil
     \]  
   - **Analog cutoff:**  
     \[
       \Omega_c = \frac{\Omega_s}{\,k_s^{1/(2N)}\,},\quad
       \omega_c = \Omega_c \, T
     \]

5. **Digital Filter Design & Application**  
   - **Design:**  
     ```matlab
     [b,a] = butter(N, ω_c/π, 'low');
     ```  
   - **Filter signal:**  
     ```matlab
     y[n] = filter(b, a, x[n]);
     ```

6. **Results & Output**  
   - Plot and compare DFTs of **original** vs. **filtered** signals.  
   - Play back with `sound(…)`.  
   - Save filtered audio:  
     ```matlab
     audiowrite('filteredaudio.wav', y, F_s);
     ```
