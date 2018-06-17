% Template for ASRU-2017 paper; to be used with:
%          spconf.sty  - ICASSP/ICIP LaTeX style file, and
%          IEEEbib.bst - IEEE bibliography style file.
% --------------------------------------------------------------------------
\documentclass{article}
\usepackage{spconf,amsmath,graphicx}
\usepackage{amssymb,amsmath,bm}
\usepackage{textcomp}
\usepackage{algorithm}
\usepackage{algpseudocode}
\usepackage{float}
\usepackage{multirow}
%\usepackage{subcaption}
\usepackage[justification=centering]{caption}
\usepackage[caption = false]{subfig}

% Custom settings
\usepackage{tikz,placeins}
\tikzstyle{every picture}+=[font=\rmfamily\it\bfseries\large]

\graphicspath{{../figures/}}


\newcommand{\specialcell}[2][c]{%
     \begin{tabular}[#1]{@{}c@{}}#2\end{tabular}}



\newcommand{\chanwcom}{{C. Kim}}
\renewcommand{\topfraction}{1.0}
\renewcommand{\bottomfraction}{1.0}
\renewcommand{\textfraction}{0.01}
\renewcommand{\floatpagefraction}{1.0}
\renewcommand{\dbltopfraction}{1.0}
\renewcommand{\floatpagefraction}{1.0}  % require fuller float pages
\renewcommand{\dblfloatpagefraction}{1.0} % require fuller float pages

\ninept


% Example definitions.
% --------------------
\def\x{{\mathbf x}}
\def\L{{\cal L}}

% Title.
% ------
\title{Spectral distortion model for training phase-sensitive deep-neural networks for far-field speech recognition}
%
% Single address.
% ---------------
\name{{Chanwoo Kim$^1$, Tara Sainath$^1$, Arun Narayanan$^1$  Ananya Misra$^1$,
Rajeev Nongpiur$^2$, and Michiel Bacchiani$^1$}}

\address{$^1$Google Speech, $^2$Nest \\
  {\small \tt \{chanwcom, tsainath, arunnt, amisra, rnongpiur, michiel\}@google.com }}
%
% For example:
% ------------
%\address{School\\
%	Department\\
%	Address}
%
% Two addresses (uncomment and modify for two-address case).
% ----------------------------------------------------------
%\twoauthors
%  {A. Author-one, B. Author-two\sthanks{Thanks to XYZ agency for funding.}}
%	{School A-B\\
%	Department A-B\\
%	Address A-B}
%  {C. Author-three, D. Author-four\sthanks{The fourth author performed the work
%	while at ...}}
%	{School C-D\\
%	Department C-D\\
%	Address C-D}
%
\begin{document}
%
\maketitle
%
\begin{abstract}
In this paper, we present an algorithm which introduces phase-perturbation
to the training database when training phase-sensitive deep neural-network
models. Traditional features such as log-mel or cepstral features do not have
have any phase-relevant information. However features such as
raw-waveform or complex spectra features contain phase-relevant information.
Phase-sensitive features have the advantage of being able to detect differences
in time of arrival across different microphone channels or
frequency bands. However, compared to magnitude-based features, phase
information is more sensitive to various kinds of distortions such as
variations in microphone characteristics, reverberation, and so on.
For traditional magnitude-based features, it is widely known that
adding noise or reverberation, often called Multistyle-TRaining (MTR)
, improves robustness. In a similar spirit, we propose an algorithm
  which introduces spectral distortion to make the deep-learning models
  more robust to phase-distortion.
We call this approach Spectral-Distortion TRaining (SDTR)
  and Phase-Distortion TRaining (PDTR).
In our experiments using a training set consisting of 22-million
  utterances with MTR, this approach reduces Word Error Rates (WERs) relatively by 3.2 \%
  on test sets recorded on Google Home.
\end{abstract}
%
\begin{keywords}
Far-field Speech Recognition, Deep-Neural Network Model, Phase-Sensitive Model
Spectral Distortion Model, Spectral Distortion Training, Phase Distortion Training
\end{keywords}
%
%
\section{Introduction}
After the breakthrough of deep learning technology
\cite{Seltzer2013DNNAurora4, Yu2013FeatureLearningDNN, V_Vanhoucke_Deep_Learning_NIPS_Workshop_2011,
G_Hinton_IEEE_Signal_Process_Mag_2012,
T_Sainath_IEEETran_2017_1, T_Sainath_Book_Chapter_2017_1}, speech recognition accuracy has
improved dramatically. Recently, speech recognition systems
have begun to be employed not only in smart phones and Personal Computers
(PCs) but also in standalone devices in far-field environments.
Examples include voice assistant systems such as Amazon Alexa
and Google Home \cite{C_Kim_INTERSPEECH_2017_1, B_Li_INTERSPEECH_2017_1}.
In far-field speech recognition, the impact of noise and reverberation
is much larger than near-field cases. Traditional approaches to far-field
speech recognition include noise robust feature extraction algorithms
\cite{C_Kim_IEEETran_2016_1, U_H_Yapanel_SpeechComm_2008},
on-set enhancement algorithms
\cite{C_Kim_INTERSPEECH_2010_2, C_Kim_INTERSPEECH_2014_2}, and
multi-microphone approaches
\cite{T_Nekatani_ICASSP_2017_1, T_Higuchi_ICASSP_2016_1,
H_Erdogan_INTERSPEECH_2016_1,
C_Kim_INTERSPEECH_2010_1, R_M_Stern_HSCMA_2008}.
A recent promising approach to this problem is using multi-channel features
which contain temporal information between two microphones \cite{T_Sainath_ICASSP_2016_1}.
It has been known that the Inter-microphone Time Delay (ITD) or
Phase Difference (PD) between two microphones may be used to identify
the Angle of Arrival (AoA) \cite{C_Kim_INTERSPEECH_2009_1, C_Kim_ICASSP_2011_2}.
The Inter-microphone Intensity Difference (IID) may also
serve as a cue for determining the AoA \cite{ColburnKulkarni05, N_Roman_JASA_2003_1}.


However, it is difficult to collect enough utterances
to train deep-neural networks for a specific
 multi-channel device compared to single-channel device,
 because multi-channel utterances have device-dependent characteristics
such as the number of microphones and the distance between microphones.
We need to re-collect multi-channel utterances for each device model.
To tackle this problem, we developed the ``room simulator"
\cite{C_Kim_INTERSPEECH_2017_1} to generate simulated multi-microphone
utterances for training multi-channel deep-neural network model.
Multi-style Training (MTR) driven by this room simulator was employed
in training the acoutic model for Google Home
\cite{C_Kim_INTERSPEECH_2017_1, B_Li_INTERSPEECH_2017_1}.

However, the room simulator in \cite{C_Kim_INTERSPEECH_2017_1}
still has its limitations.
It assumes that all the microphones are ideal, which means that they all
have zero-phase all-pass responses. Even though this assumption is very
convenient, it is not true with actual microphones due to microphone
spectrum distortion. In addition, there may be reasons for distortion such as
electrical noise in the circuit, acoustic auralization effect from
the hardware surface, and various vibrations.
In conventional MTR, we usually only add additive noise and
reverberation to the training set; we do not
model the spectral or phase distortion across different
filter bank or microphone channels.  In this paper, we propose
an algorithm that makes phase-sensitive deep learning model more
robust by adding phase distortion to the training set.
%
%
%\section{Spectral distortion in real hardware recording}
%\label{sec:spectral_distortion}
%%
%%
%%
%\begin{figure}[tbp]
%  \begin{center}
%    \includegraphics[width=50mm]{recording_room_final}
%      \caption { A microphone array with two microphones in an anechoic chamber.
%      The azimuth angle with respect to the $x$-axis is $\theta$. }
%          \label{fig:recording_room_final}
%  %\vspace{-7mm}
%  \end{center}
%\end{figure}
%%
%%
%Before discussing the Phase-Distortion TRaining (PDTR)/
%Spectral-Distortion TRaining (SDTR) model in detail
%in the next section, we briefly examine how the magnitude-phase distortion
%occurs with real recording. Let us consider
%a configuration for recording in an ``anechoic" chamber as shown in Fig.
%\ref{fig:recording_room_final}. The target sound source is a high-quality
%loud speaker in this anechoic chamber without other noisy sound sources.
%In this setup, the distance between two microphones was 5.1 $cm$.
%The distance from the target sound source to the microphone array is two
%meters. Let us denote the azimuth angle by $\theta$, which is the angle
%between the perpendicular bisector to the line connecting two microphones
%and the line connecting the center of the array to the loud speaker.
%Fig. \ref{fig:microphone_responses} show a two-channel microphone
%response obtained in this configuration with $\theta=0^{o}$.
%Impulse responses were obtained using the method proposed by A. Farina
%\cite{A_Frina_AES_2000}.
%%
%%
%\begin{figure}[tbp]
%  \begin{center}
%    \subfloat[\label{fig:time_domain_response_2_91_90_rir_anechoic_16k}
%    ] {
%    \includegraphics[width=80mm]{time_domain_response_2_91_90_rir_anechoic_16k}} \\
%  \subfloat[\label{fig:magnitude_response_2_91_90_rir_anechoic_16k}
%    ] {
%    \includegraphics[width=80mm]{magnitude_response_2_91_90_rir_anechoic_16k}} \\
%  \subfloat[\label{fig:phase_response_2_91_90_rir_anechoic_16k}
%    ] {
%    \includegraphics[width=80mm]{phase_response_2_91_90_rir_anechoic_16k}}
%\caption {\label{fig:microphone_responses} \emph{
%  (a) A microphone response recorded in an anechoic chamber.
%  (b) Magnitudes of two microphone transfer functions from a single microphone array,
%  and (c) Phases of two microphone transfer functions from a single microphone array.}}
%  \end{center}
%  %\vspace{-5mm}
%\end{figure}
%%
%%
%%
%As shown in Fig. \ref{fig:magnitude_response_2_91_90_rir_anechoic_16k}
%and Fig. \ref{fig:phase_response_2_91_90_rir_anechoic_16k}, the magnitude and the phase
%responses are different from the ideal responses, which is the all-pass
%zero-phase response. Since the azimuth angle $\theta$  is zero in this case,
%the phase components from two microphones are expected to be the same.
%However, as shown in Fig. \ref{fig:phase_response_2_91_90_rir_anechoic_16k},
%the phases from two microphones turned out to be somewhat different
%especially in high frequencies.
%%
%The relationship between the phase difference and Angle of Arrival (AoA) $\theta$
%at discrete frequency $k$ is given by the following equation
%\cite{C_Kim_INTERSPEECH_2015, C_Kim_ICASSP_2012_2}:
%\begin{align}
%  \theta(\omega_k) = \arcsin \left( \frac{\Delta \phi (\omega_k) c_0}{\omega_k d_m f_s}  \right)
%\end{align}
%where $\omega_k$ is the discrete frequency, $\Delta \phi (\omega_k)$ is the
%phase difference at this frequency $\omega_k$. $f_s$, $d_m$ and $c_0$ are
%sampling rates in \textit{Hz}, the distance between two microphones, and
%the speed of sound, respectively. Using this equation, the estimated
%Angle of Arrivals(AoAs) are obtained in Fig. \ref{fig:estimated_aoa}
%for three different locations with
%the true azimuth angle $\theta$ of $45^{o}$, $0^{0}$, and $-45^{o}$ respectively.
%From this figure, the phase distortion of real hardware may be easily observed.
%%
%\begin{figure}[tbp]
%  \begin{center}
%  \subfloat[\label{fig:room_snr_db_distribution}] {
%       \includegraphics[width=80mm]{estimated_angle_2_45_90_rir_anechoic_16k}} \\
%  \subfloat[\label{fig:estimated_angle_2_91_90_rir_anechoic_16k}] {
%    \includegraphics[width=80mm]{estimated_angle_2_91_90_rir_anechoic_16k}} \\
%  \subfloat[\label{fig:target_to_mic_distribution}] {
%    \includegraphics[width=80mm]{estimated_angle_2_135_90_rir_anechoic_16k}}
%  \caption {\label{fig:estimated_aoa}\emph{ The estimated Angle of Arrival when the true azimuth 
%    angle $\theta$ is (a) $45^{o}$ (b) $0^{o}$, and (c) $-45^{o}$. }}
%  \end{center}
%  %\vspace{-5mm}
%\end{figure}
%
%
%
\section{Spectral-Distortion TRaining (SDTR) for Phase-Sensitive Deep Neural Networks}
\label{sec:sdtr_training}
%
In this section, we explain the entire structure of
Spectral-Distortion TRaining (SDTR), and its subsets
Phase-Distortion TRaining (PDTR) and Magnitude Distortion TRaining (MDTR).
PDTR is a subset of SDTR where distortion is only
applied to the phase component without modifying the magnitude component
of complex features. MDTR is a subset of SDTR where distortion is applied
only to the magnitude component of such features.
PDTR is devised for enhancing the robustness of phase-sensitive
multi-microphone neural network models such as those presented in
\cite{B_Li_INTERSPEECH_2017_1, T_Sainath_INTERSPEECH_2015_1}.
%
\subsection{Acoustic model training}
Fig. \ref{fig:entire_diagram} shows the structure of the acoustic model
pipeline used for training multi-channel deep neural networks. The pipeline
is based on our work described in
\cite{B_Li_INTERSPEECH_2017_1, C_Kim_INTERSPEECH_2017_1}.
The pipeline consists of five layers of Long Short-Term Memory (LSTM)
\cite{S_Hochreiter_neural_computation_1997_00}.
Each fully connected Deep Neural Network (DNN) layer is placed before
and after this stack of LSTM layers. We use
the Complex Fast Fourier Transform (CFFT) feature whose window
size is 32 \textit{ms}, and the interval between successive frame is 10
\textit{ms}. We use the FFT size of $N = 512$. Since FFT of real signals have
Hermitian symmetry, we use the lower half spectrum whose size given by $N / 2 + 1 = 257$.
Since it has been shown that long-duration features represented by overlapping
features are helpful \cite{H_Sak_INTERSPEECH_2015_1}, four frames are stacked together.
Thus we use a context dependent feature consisting of 2056 complex numbers
given by 257 (the size of the lower half spectrum) x 2 (number of channels)
x 4 (number of stacked frames).
We apply the Complex Linear Projection (CLP) described in
\cite{E_Variani_INTERSPEECH_2017_1} on this two-channel complex FFT feature.
The output state label is delayed by five frames, since it was observed that
information about future frames improves the prediction of the current frame
\cite{T_Sainath_ICASSP_2015_1}.
%
\subsection{Spectral Distortion Model (SDM)}
To make the phase-sensitive multi-channel feature more robust, we add
the Spectral Distortion Model (SDM) to each channel. Mathematically,
SDM is described in \eqref{eq:spectrum_distortion}.
The first stage of the pipeline in Fig \ref{fig:entire_diagram}
is the room simulator to  generate millions of different utterances
in millions different virtual rooms \cite{C_Kim_INTERSPEECH_2017_1}.
%
\begin{figure}[!tbp]
  \begin{center}
    \resizebox{45mm}{!}{\input{../figures/entire_diagram.tex}}
      \caption {  A pipeline containing the Spectrum Distortion
      Model (SDM) for training deep-neural networks for acoustic modeling.
     This acoustic model pipeline is modified based on
     \cite{T_Sainath_ICASSP_2016_1}. }
          \label{fig:entire_diagram}
  \end{center}
\vspace{-7mm}
\end{figure}
%
%
%
\begin{figure}[!tbp]
    \begin{center}
    \resizebox{45mm}{!}
      {\input{../figures/spectrum_distortion_block_diagram.tex}}
    \caption {
       A diagram showing the structure of applying magnitude-phase
      distortion to each microphone channel. Note that $i$ in this diagram denotes
      the microphone channel index.
      \label{fig:spectrum_distortion_block_diagram}
    }
    \end{center}
  %\vspace{-7mm}
\end{figure}
%
%
%
The spectrum distortion procedure is summarized by the following pseudo-code:
\vspace{7mm}
\begin{algorithmic}
\For {each utterance in the training set}
  \For {each microphone channel of the utterance}
     \State Create the random transfer function  using \eqref{eq:spectrum_distortion}.
     \State Perform Short-Time Fourier Transform (STFT).
     \State Apply this transfer function to the spectrum.
     \State Re-synthesize the output microphone-channel using OverLap Addition (OLA).
  \EndFor
\EndFor
\end{algorithmic}
\vspace{7mm}
For each microphone channel of each utterance, we create a transfer function
to distort the spectrum. Unlike the case of adding random noise to speech signals,
only a single transfer function is generated for an utterance. The spectral
distortion model is described by the following equation:
%
\begin{align}
  D_l(e^{j\omega_k}) = e^{m_l(k) + jp_l(k)}, \qquad
          & 0 \le k \le \frac{K}{2}, \nonumber \\
          & 0 \le l \le L - 1.
  \label{eq:spectrum_distortion}
\end{align}
%
where $l$ is the microphone channel index and $L$ is the number of
microphone channels. In the case of Google Home, since we use two microphones,
$L = 2$.
$\omega_k$ is the discrete frequency index, which is defined by
$\omega_k = \frac{2 \pi k}{K}$ where $K$ is the Discrete Fourier Transform(DFT) size.
$m_l(k)$ and $p_l(k)$ are Gaussian random samples pulled from the following
Gaussian distributions  $\mathbf{m}$ and $\mathbf{p}$ respectively:
%
\begin{subequations}
  \begin{align}
    \mathbf{m} \sim  \mathcal{N}(0, \sigma_m^2)\\
    \mathbf{p} \sim  \mathcal{N}(0, \sigma_p^2)
  \end{align}
  \label{eq:random_variables}
\end{subequations}
%
The scaling coefficient $a$ in \eqref{eq:spectrum_distortion} is defined
by the following equation:
%
\begin{align}
  a = \ln(10.0) / 20.0
  \label{eq:scaling_coeff_a}
\end{align}
%

This scaling coefficient $a$ is introduced to make $\sigma_m$
the standard deviation of the magnitude in decibels, which makes it easier to control the amount of distortion.
From \eqref{eq:spectrum_distortion}, it should be evident that $m_l(k)$ and
$p_l(k)$ are related to the magnitude and phase distortion, respectively.
The magnitude distortion is accomplished by the $e^{m_l(k)}$ term. Since
Using the change of base property of $e^{m_l(k)} = 20.0 ^ {m_l(k) \log_{20}(e)}$,
we see that the standard deviation of magnitude in decibel is
given by $\log_{20}(e) \sigma_n$.
For the phase term, since
the complex exponential has a period of $2 \pi$, the distribution
actually becomes the wrapped Gaussian distribution \cite{E_Breitenberger_Biometrika_1963}.

% which is shown
%in \label{fig:wrapped_gaussian_pdf}
%
%
%\begin{figure}[!tbp]
%  \centering
%  \includegraphics[width=80mm]{wrapped_gaussian_pdf}
%  \caption{\label{fig:wrapped_gaussian_pdf}
%    The probability density functions(PDFs) of the wrapped Gaussian
%    distribution with different values of $\sigma_p$.}
%    %\vspace{-5mm}
%\end{figure}
%
%
%
After creating the spectrum distortion transfer function
$D_l\left(e^{j\omega_k}\right)$
in \eqref{eq:spectrum_distortion}, we process each channel using the
structure shown in Fig. \ref{fig:spectrum_distortion_block_diagram}.
We apply the Hanning window instead of the more frequently-used Hamming window
to each frame. We use the Hanning window to better satisfy the OverLap-Add (OLA)
constraint. After multiplying the complex spectrum of each frame with the
spectrum distortion transfer function $D_l\left(e^{j\omega_k}\right)$
in the frequency domain, the time-domain signal is re-synthesized
using OverLap-Add (OLA) synthesis. This processing is shown in detail
in Fig. \ref{fig:spectrum_distortion_block_diagram}. The reason for
going back to the time domain is because we use Complex Fast Fourier
Transform (CFFT) as feature whose frame size is 32 {\it ms} in Fig.
\ref{fig:entire_diagram}, which does not match the processing window 
size of SDM.
We segment each microphone channels into successive frames with the
frame length of 10 {\it ms}. The period between successive frames is 5 {\it ms}.
These frame length is chosen based on the experimental results in Sec.
\ref{subsec:word_error_rate_dependence}. The spectrum distortion effects
from $D_l(e^{j\omega_k})$ in Fig. \ref{fig:spectrum_distortion_block_diagram}
is not removed by either the conventional Causal Mean Subtraction (CMS)
\cite{B_King_INTERSPEECH_2017_1}, nor Cepstral Mean Normalization
(CMN), since we use complex features and SDM includes complex exponential, and
CMS and/or CMN operates on the magnitude.
%
%
%
\subsection{Word Error Rate(WER) dependence on $\sigma_m$,  $\sigma_p$ and frame length}
\label{subsec:word_error_rate_dependence}
Table \ref{tbl:pdtr_result} shows speech recognition results in terms
of Word Error Rate (WER) using PDTR with different values
of $\sigma_p$ and frame lengths. % The PDF functions of wrapped
%Gaussian distributions corresponding to these $\sigma_p$ values are depicted
%in Fig. \ref{fig:wrapped_gaussian_pdf}.
The configurations for speech recognition training and evaluation will be
described in detail in Sec. \ref{sec:experimental_results}. The evaluation
set used in Table \ref{tbl:pdtr_result} through Table \ref{tbl:mdtr_mtr_result}
is the combinations of five rerecording sets described in Sec.
\ref{sec:experimental_results}, which are three rerecording sets
using different Google Home devices, and two rerecording sets in
presence of Youtube noise and interfering speakers.
The best result in Table \ref{tbl:pdtr_result} (49.77 \% WER) is obtained when
$\sigma_p = \infty$ with the window length of 32 {\it ms}. Table \ref{tbl:mdtr_result}
shows Word Error Rates (WERs) using MDTR on the same test set
using the same configuration as in Table \ref{tbl:pdtr_result} with different
$\sigma_m$  values. In these experiments,
we observe significant improvement over the baseline system which shows WER of
62.0 \% on the same test set.

When training acoustic models for Google Home,
we have been using data generated by the room simulator
\cite{C_Kim_INTERSPEECH_2017_1}.
Table \ref{tbl:pdtr_mtr_result} and Table \ref{tbl:mdtr_mtr_result} show
the WERs when the PDTR or MDTR is applied with the Multi-style TRaining (MTR) driven by this ``room simulator".
Even though relative improvement over the MTR baseline in Table \ref{tbl:pdtr_mtr_result} and
Table \ref{tbl:mdtr_mtr_result} is less than the relative improvement in Table \ref{tbl:pdtr_result} and
Table \ref{tbl:mdtr_result}, we still obtain substantial improvement over the baseline.

From the results from Table \ref{tbl:pdtr_result} to 
Table \ref{tbl:mdtr_mtr_result}, PDTR is more effective than MDTR.
We also tried combinations of PDTR and MDTR, but we could not obtain results
better than only using PDTR. Thus, in the final system, we adopt PDTR with  $\sigma_p = 0.4$ as
the default Spectral Distortion Model (SDM).
%
%
%
%
\section{Experimental Results}
\label{sec:experimental_results}
\begin{table}[!tbp]
   \centering
      \caption{\label{tbl:pdtr_result}
      Word Error Rates (WERs) using \\ the PDTR training}
      %\vspace{-3mm}
      \centerline{
        \begin{tabular}{| c |  c |  c  c  c |}
          \hline
                         \specialcell{ }
                        & \specialcell{\textbf{baseline}}
                        & \specialcell{$\sigma_p = 0.1$   }
                        & \specialcell{$\sigma_p = 0.4$   }
                        & \specialcell{$\sigma_p = \infty$} \\
          \hline \hline
          \specialcell{\textbf{frame} \\  \textbf{length}}  & & & &   \\
          10 \textit{ms}       &  \multirow{2}{*}{62.00\%}   &  57.16 \% &  56.74 \% & 54.03 \%  \\
          %          \cline{3-5}
          32 \textit{ms}      &          &    59.03 \% &  57.14 \% & \textbf{49.77} \%  \\
          \hline
        \end{tabular}
      }
      \vspace{4mm}
      \caption{\label{tbl:mdtr_result}
      Word Error Rates (WERs) using \\ the MDTR training}
      %\vspace{-3mm}
      \centerline{
        \begin{tabular}{| c | c | c  c  c  | }
          \hline
                          \specialcell{ }
                        & \specialcell{\textbf{baseline}}
                        & \specialcell{$\sigma_m = 0.5$ }
                        & \specialcell{$\sigma_m = 1.0$ }
                        & \specialcell{$\sigma_m = 2.0$ } \\
          \hline \hline
          \specialcell{\textbf{frame} \\  \textbf{length}}  & & & &    \\
          10 \textit{ms}       &  \multirow{2}{*}{62.00\%}    &  60.39 \% &        &                    \\
          \cline{3-5}
          32 \textit{ms}       &         &  \textbf{52.21}  \% & 53.03 \% &  55.37 \%       \\
          \hline
        \end{tabular}
      }
      \vspace{4mm}
      \caption{\label{tbl:pdtr_mtr_result}
      Word Error Rates (WERs) using \\ the PDTR and MTR training}
      %\vspace{-3mm}
      \centerline{
        \begin{tabular}{| c | c |  c  c  c   | }
          \hline
                         \specialcell{ }
                        & \specialcell{\textbf{MTR} \\ \textbf{baseline}}
                        & \specialcell{$\sigma_p = 0.1$ }
                        & \specialcell{$\sigma_p = 0.4$ }
                        & \specialcell{$\sigma_p = \infty$}    \\
          \hline \hline
          \specialcell{\textbf{frame} \\  \textbf{length}}  & & & &   \\
          10 \textit{ms}   &  \multirow{3}{*}{29.34\%}  & 28.63 \% & \textbf{28.40} \% & 29.78 \%  \\
          \cline{1-1} \cline{3-5}
          32 \textit{ms}       &    &            & 29.28 \% & 30.34 \%  \\
          \cline{1-1} \cline{3-5}
          160  {\it ms}     &    &   28.69 \% & 31.36 \% & 37.82 \%  \\
          \hline
        \end{tabular}
      }
      \vspace{4mm}
      \caption{\label{tbl:mdtr_mtr_result}
      Word Error Rates (WERs) using \\ the MDTR and MTR training}
      %\vspace{-3mm}
      \centerline{
        \begin{tabular}{| c | c |  c  c  c   | }
          \hline
                         \specialcell{ }
                        & \specialcell{\textbf{MTR} \\ \textbf{baseline}}
                        & \specialcell{$\sigma_m = 0.5$ }
                        & \specialcell{$\sigma_m = 1.0$ }
                        & \specialcell{$\sigma_m = 2.0$ } \\
                        %& \specialcell{$\sigma_m = 4.0$ }  \\
          \hline \hline
          \specialcell{\textbf{frame} \\  \textbf{length}}  & & & &    \\
          10 {\it ms}      &  \multirow{3}{*}{29.34\%}         &  31.13 \% &   &      \\
          \cline{1-1} \cline{3-5}
          32 {\it ms}      &            &  \textbf{28.46} \% & 28.78 \% &  28.70 \%           \\
          \cline{1-1} \cline{3-5}
          160 {\it ms}     &            &                    & 29.01 \% &  29.55 \% \\ %& 29.45 \%  \\
          \hline
        \end{tabular}
      }
\end{table}
%
\begin{table*}[!htbp]
  \renewcommand{\arraystretch}{1.3}
  \centering
      \caption{\label{tbl:final_sdtr_result} Word Error Rates (WERs) obtained with
                the PDTR ($\sigma_m = 0.0,\,\sigma_p = 0.4$) training}
        %\vspace{-3mm}
        \begin{tabular}{| c | c | c | c |}
          \hline
                                 & \specialcell{Baseline }
                                 & \specialcell{PDTR }
                                 & \specialcell{Relative \\ improvement (\%)} \\
          \hline \hline
          Original Test Set         &  12.02 \% &  12.32 \%  &  -2.53 \%  \\
          \hline \hline
          Simulated Noise Set 1     &  20.34 \% &  20.72 \%  &  -1.86 \%   \\
          \hline
          Simulated Noise Set 2     &  47.88 \% &  46.69 \%  &   2.50 \%  \\
          \hline  \hline
          \specialcell{Rerecording using "Device 1"}  &  50.14 \% & 42.87  \%  &  14.51 \%  \\
          \hline
          \specialcell{Rerecording using "Device 2"}  &  48.65 \% & 43.32 \%   &  10.95 \%   \\
          \hline
          \specialcell{Rerecording using "Device 3"}
            &  56.27 \% & 51.30 \%   &   8.83 \%   \\
          \hline
          \specialcell{Rerecording with youtube background noise}
            &  76.01 \% & 71.42 \%     &  6.04 \% \\
          \hline
          \specialcell{Rerecording with multiple interfering speaker noise}
            &  78.95  \% & 74.80   \%     & 5.26 \%  \\
          \hline \hline
          \specialcell{\textbf{Average from rerecording sets}}  &  \textbf{62.00} \% & \textbf{56.74} \%     & \textbf{8.48} \%  \\
          \hline
       \end{tabular}
       \vspace{4mm}
        \caption{\label{tbl:final_sdtr_mtr_result} Word Error Rates (WERs) obtained with
                  \\the PDTR ($\sigma_m = 0.0,\, \sigma_p = 0.4$) training combined
                  with room-simulator based MTR in \cite{C_Kim_INTERSPEECH_2017_1}}
        %\vspace{-3mm}
        \begin{tabular}{| c | c | c | c |}
          \hline
                                 & \specialcell{MTR}
                                 & \specialcell{PDTR + MTR}
                                 & \specialcell{Relative \\ improvement (\%)} \\
          \hline \hline
          Original Test Set         &  11.97  \% & 11.99 \%   &  -0.17 \%  \\
          \hline
          Simulated Noise Set 1     &  14.73  \% &  15.03 \%  &  -2.04 \%   \\
          \hline
          Simulated Noise Set 2     &  19.55  \% &  20.29 \%  &  -3.79 \%  \\
          \hline \hline
          \specialcell{Rerecording using "Device 1"}  &  21.89 \% & 20.86  \%  &  4.71 \%  \\
          \hline
          \specialcell{Rerecording using "Device 2"}  &  22.23 \% & 21.29 \%   &  4.22 \%   \\
          \hline
          \specialcell{Rerecording using "Device 3"}  &  22.05 \% & 21.65 \%   &   1.81 \%   \\
          \hline
          \specialcell{Rerecording with youtube background Noise }  &  34.83 \% & 34.21 \%     & 1.78 \%  \\
          \hline
          \specialcell{Rerecording with multiple interfering speaker noise }  &  44.79 \%   &  44.00   \%      &  1.76 \% \\
          \hline \hline
          \specialcell{\textbf{Average from rerecording sets}}  &  \textbf{29.34} \% & \textbf{28.40} \%     & \textbf{3.20} \%  \\
          \hline
       \end{tabular}
\end{table*}
%
%
%%
In this section, we shows experimental results obtained with
the SDTR training. For training, we used an anonymized
22-million English utterances (18,000-hr), which are
hand-transcribed.  For training the acoustic model, instead of
directly using these utterances, we use the
room simulator described in \cite{C_Kim_INTERSPEECH_2017_1} to generate
simulated utterances for our hardware.
In the simulator, we use 7.1 cm distance between two microphones.
For each utterance, one room configuration was selected out of
three million room configurations with varying room dimension, and
varying the target speaker and noise source locations. In each
room, number of noise sources may be up to three. This configuration
changes for each training utterance.
After every epoch, we apply a different room configuration to the
utterance so that each utterance may be regenerated in somewhat
different ways.  For additive noise, we used Youtube videos,
recordings of daily activities, and recordings at various locations
inside cafes. We picked up the SNR value from a distribution
ranging from 0 dB to 30 dB, with an average of 11 dB. We used
reverberation time varying from 0 $ms$ up to 900.0 $ms$ with
an average of 500 $ms$. To model reverberation, we employed
the image method \cite{J_Allen_JASA_1979}. We constructed
$17^3 - 1 = 4912$ virtual sources for each real sound source.
The acoustic model was trained using the Cross-Entropy (CE) minimization
as the objective function after aligning each utterance. The Word
Error Rates (WERs) are obtained after 120 million steps of acoustic
model training.




For evaluation, we used around 15-hour of utterances (13,795 utterances)
obtained from anonymized voice search data. Since our objective is
evaluating speech recognition performance when our system is deployed on
the actual hardware, we re-recorded these utterances using our actual devices in a real room
at five different locations. The utterances were
played out using a mouth simulator.  We used three different devices
(named "Device 1", "Device 2", and "Device 3") as shown in
Table \ref{tbl:final_sdtr_result} and \ref{tbl:final_sdtr_mtr_result}. These three devices are prototype Google
Home devices. Each device is placed at five different positions and
orientations in a real room with mild reverberation (around 200 \textit{ms} reverberation time). The entire
15-hour test utterances are rerecorded using each device.
We also prepared two additional rerecorded sets
in presence of Youtube noise and interfering speaker noise played through
real loud speakers. The noise level varies, but it is usually between 0 and 15 dB SNR.
Each of these noisy rerecording sets also contains the same 15-hour long
utterances with subsets being recorded at five different locations.
In total, there are
five rerecording test sets in Table \ref{tbl:final_sdtr_result} and
Table \ref{tbl:final_sdtr_mtr_result}. In addition to the real rerecorded
sets, we evaluated performance on two simulated noise sets created
using the same utterances
using the ``room simulator" in \cite{C_Kim_INTERSPEECH_2017_1}.
Note that in these two simulated noise sets, we assume that all microphones are identical without
any magnitude or phase distortion. We are mainly interested in performance on the rerecorded sets,
but we also included these simulated noise sets for the purpose of comparison.
 

In Table \ref{tbl:final_sdtr_result}, we compare the performance of
the baseline system with the PDTR system. 
The baseline Word Error Rates (WERs) are high on rerecorded test sets because the
baseline system was not processed by MTR using the room simulator in
\cite{C_Kim_INTERSPEECH_2017_1}.
Based on our analaysis in Sec. 
\ref{sec:sdtr_training}, we use the PDTR of $\sigma_m = 0.0, \sigma_p = 0.4$ 
in \eqref{eq:random_variables}
as our Spectral Distortion Model (SDM). As shown in these two tables,
PDTR shows significantly better results than the baseline for rerecorded sets
while doing on par or slightly worse on two simulated noisy sets, which is expected.

As shown in Tables  \ref{tbl:final_sdtr_result} and \ref{tbl:final_sdtr_mtr_result},
the final system shows relatively 8.48 \% WER reduction for the
non-MTR training case and relatively 3.2 \% WER reduction for
the MTR training case using the room simulator described in \cite{C_Kim_INTERSPEECH_2017_1}.
%
%
\section{Conclusions}
In this paper, we described the PDTR algorithm to add phase distortion
to the training set to make  the trained phase-sensitive neural net
model robust against various distortions in signals. Our experimental
results show that the phase-sensitive neural-net trained with PDTR is
much more robust against real-world distortions. The final system
shows relatively 3.2 \% WER reduction over the MTR training set
for Google Home.
%\clearpage
%\newpage
\bibliographystyle{IEEEtran}
\bibliography{../../common_bib_file/common_bib_file}


\end{document}
