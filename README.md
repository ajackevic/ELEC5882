# The design of a pulse compression filter on an FPGA
This repository contains the MATLAB and FPGA design and implementation of the pulse
compression filter.
&nbsp;

## What is a pulse compression filter and why do we need it?
Whilst oversimplified, a pulse compression filter is used to drastically increase the
range resolution and more importantly the SNR of a radar system. This is achieved by
modulating the transmitted pulse and then cross correlating the transmitted signal with
the received signal. More information on the pulse compression filter is explained in
the following link:

https://en.wikipedia.org/wiki/Pulse_compression


## How does the pulse compression filter work?
The first set of the pulse compression filter is modulating the transmitted pulse. This
then increases the bandwidth of the transmitted signal thus increasing the range resolution.
The modulations is either frequency and or phase. In this project, the linear frequency
modulation (LFM or sometimes also known as chirp) is used to modulate the transmitted pulse.

The pulse compression filter mainly operates on the matched filter (this project focuses on
a time domain implementation of a matched filter). The matched filter performs the convolution
between the echoed back signal of the radar system and the matched filter's impulse response.
Where the impulse response is the complex conjugate time reversal of the transmitted pulse.

To avoid aliasing, both the echoed back signal and the matched filters impulse response are
passed through a Hilbert transform, this removes the negative frequencies. The Hilbert
transform outputs a complex value, thus the matched filter performs a complex convolution,
which is achieved through the use of a complex FIR filter. A detailed explanation on how a
FIR and a complex FIR filter operate is explained in the folder 'The workings of an FIR filter'.
The absolute value of the matched filter is calculated to obtain the envelope of the signal, and
thus the output of the pulse compression filter.

More information on the matched filter, LFM, and Hilbert transform can be found in the following links:
https://en.wikipedia.org/wiki/Matched_filter

https://en.wikipedia.org/wiki/Chirp

https://en.wikipedia.org/wiki/Hilbert_transform

## How does the FPGA implementation work?
The echoed back input signal (synthetic data created in FPGAPulseCompressionFilter.m and loaded
to the FPGA design) is passed through a Hilbert transform module making it analytic.
The Hilbert transform is the convolution between the input signal and its coefficients. Thus,
an FIR filter is used to convolute the input signal with the coefficients that are obtained in
MATLAB (FPGAPulseCompressionFilter.m). This signal is then applied to the complex FIR filter, which
convolute the signal with its coefficients (matched filter impulse response). Since there are 800
coefficients, they are calculated in MATLAB (FPGAPulseCompressionFilter.m), stored in a MIF file and
loaded to the design. After absolute value of the complex FIR filter is then calculated to give the
final output of the filter.

Whilst calculating the absolute value in MATLAB is easily achieved, the same can't be said
for the FPGA implementation. In this project, the alpha max plus beta min algorithm and the
non-restoring square root algorithm were designed to calculate the absolute value. A comparison
was then made, in regards to the accuracy (ABScomparison.m) and the resources it required. Whilst
non-restoring square root algorithm required roughly 9 times more resources, it was significantly
more accurate, thus was the chosen method.

The bit width of the input data and the width of the complex FIR filter coefficients, were chosen as
12 bit. This value was as that is the most common output width of ADC's. The output is then reduced
to a 32 bit width to make it more compatible for a larger range of applications.

To enable the analysing of results, the FPGA implementation is also designed in the MATLAB
(FPGAPulseCompressionFilter.m). This is a near identical implementation (except FIR and complex FIR
filter design, conv() was used instead), and helps to visualise the results of the implemented
FPGA design. Furthermore, this also allows the user to apply and see the results of quick changes
before the change is then applied to the FPGA design.

## Brief description of each script
The following table below outlines all the MATLAB + MIF scripts/files used in this project and what they do.
| File | Description |
| ---  | --- |
| `idealPulseCompressionFilter.m` | This script shows the output of the pulse compression filter, using the ideal functions available in MATLAB (hilbert() and abs()).|
| `FPGAPulseCompressionFilter.m` | This script is a near identical implementation of the FPGA design. It also creates the files MFImpulseCoeff.mif, MFInputData.mif, and MFOutputData.mif files which are then used in the FPGA design.|
| `ABScomparison.m` | This script compares the accuracy results of alpha max plus beta min algorithm and the non-restoring square root algorithm.|
| `sqaureRootCal.m` | This script calculates the square root value using non-restoring square root algorithm.|
| `MFImpulseCoeff.mif` | This file is stores the complex FIR filters coefficients.|
| `MFInputData.mif` | This file is stores the synthetic data that is then applied to the FPGA filter.|
| `MFOutputData.mif` | This file is stores the expected output of the MATLAB design. It is later used in a test bench to confirm the output of the FPGA design is identical to the MATLAB design.|

&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;

The following table below outlines the functionality of each Verilog script used in this project.
| File | Description |
| ---  | --- |
| `n_tap_fir.v` | This module create a n tap FIR filter.|
| `setup_FIR_coeff.v` | This module supplies the coefficients for the module n_tap_fir.|
| `n_tap_complex_fir.v` | This module create a complex n tap FIR filter.|
| `setup_complex_FIR_coeff.v` | This module supplies the coefficients for the module n_tap_complex_fir.|
| `absolute_value.v` | This module implements the alpha max plus beta min algorithm.|
| `sqaure_root_cal.v` | This module implements the non-restoring square root algorithm.|
| `hilbert_transform.v` | This module creates the Hilbert transform.|
| `setup_HT_coeff.v` | This module supplies the coefficients for the module hilbert_transform.|
| `read_MIF_file.v` | This module read the provided MIF files.|
| `pulse_compression_filter.v` | This module is the top module which calls and controls all the other modules.|
| `n_tap_fir_tb.v` | This is a test bench for the module n_tap_fir.|
| `setup_FIR_coeff_tb.v` | This is a test bench for the module setup_FIR_coeff.|
| `n_tap_complex_fir_tb.v` | This is a test bench for the module n_tap_complex_fir.|
| `setup_complex_FIR_coeff_tb.v` | This is a test bench for the module setup_complex_FIR_coeff.|
| `absolute_value_tb.v` | This is a test bench for the module absolute_value.|
| `sqaure_root_cal_tb.v` | This is a test bench for the module sqaure_root_cal.|
| `hilbert_transform_tb.v` | This is a test bench for the module hilbert_transform.|
| `setup_HT_coeff_tb.v` | This is a test bench for the module setup_HT_coeff.|
| `read_MIF_file_tb.v` | This is a test bench for the module read_MIF_file.|
| `pulse_compression_filter_tb.v` | This is a test bench for the module pulse_compression_filter.|
