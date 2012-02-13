This directory contains an example and test data sets that can be used to 
learn how to run the NaiNo-Kami package in Matlab (NNK).

The example include the following directories:

example:    252 events, with waveform records in SAC format, pick files in 
            UUSS and hypo71 format.

NNK:        scripts directory.

NNK_takeparams_example.m : the settings file associated with the example.
aliases.txt:	 sac files's station code aliasing file.
NNK_clust.m :   clustering script.
NNK_dtb.m :     cluster processing script.



See matlab help of the function NNK_clust on how to run the example.

The program performances should depend on the array dimensions allowed in 
your matlab distribution.

The program will run if the settings file is correct. 
NNK_takeparams_example.m is commented on how to build correct settings file.

Future updates: 
- perl extension utilities for hypo71 and NLLoc location, hypoDD and tomoDD 
relocation and FPFIT composite determination (available on request).
- interactive plotting scripts suite for the NNK clusters database.
- detection scripts suite to feed the NNK clustering suite. 

Fred Massin, UofU, 2011
