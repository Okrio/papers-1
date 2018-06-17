This package includes the SSF processing program.

	Apr. 2010

     Chanwoo Kim and Richard M. Stern
	
		Program Author:	Chanwoo Kim



1. 	Command line argument.

Input and output file needs to be in 'MS-WAV format'
The following shows the function parameters.

SSF_INTERSPEECH2010(szOutFileName, szInFileName, iSSFType, dFrameLen, dLambda)

% szOutFileName : Output file in wave file format
% szInFileName  : Input file in wave file format
% iSSFType      : Either 1 (SSF Type-I) or 2 (SSF Type-II)
% dFrameLen     : Default (0.05 (sec))
% dLambda       : Forgetting factor Default 0.4


2.	Some sample run

% SSF-Type I

SSF_INTERSPEECH2010('sb01_Clean.typeI.wav',        'sb01_Clean.in.wav',        1, 0.075, 0.4);
SSF_INTERSPEECH2010('sb01_White05dB.typeI.wav',    'sb01_White05dB.in.wav',    1, 0.075, 0.4);
SSF_INTERSPEECH2010('sb01_Music05dB.typeI.wav',    'sb01_Music05dB.in.wav',    1, 0.075, 0.4);
SSF_INTERSPEECH2010('sb01_Reverb0P5sec.typeI.wav', 'sb01_Reverb0P5sec.in.wav', 1, 0.075, 0.4);

% SSF-Type II

SSF_INTERSPEECH2010('sb01_Clean.typeII.wav',        'sb01_Clean.in.wav',        2, 0.075, 0.4);
SSF_INTERSPEECH2010('sb01_White05dB.typeII.wav',    'sb01_White05dB.in.wav',    2, 0.075, 0.4);
SSF_INTERSPEECH2010('sb01_Music05dB.typeII.wav',    'sb01_Music05dB.in.wav',    2, 0.075, 0.4);
SSF_INTERSPEECH2010('sb01_Reverb0P5sec.typeII.wav', 'sb01_Reverb0P5sec.in.wav', 2, 0.075, 0.4);

