function helpinsacheader 


%%%%%%%%%%%%%%%%%
%%%%% general fields
% NPTS      N	 Number of points per data component. [required]
% NVHDR     N	 Header version number. Current value is the integer 6. Older version data (NVHDR < 6) are automatically updated when read into sac. [required]
% B         F	 Beginning value of the independent variable. [required]
% E         F	 Ending value of the independent variable. [required]
% IFTYPE	I	 Type of file [required]:
%             = ITIME {Time series file}
%             = IRLIM {Spectral file---real and imaginary}
%             = IAMPH {Spectral file---amplitude and phase}
%             = IXY {General x versus y data}
%             = IXYZ {General XYZ (3-D) file}
% LEVEN     L	TRUE if data is evenly spaced. [required]
% DELTA     F	 Increment between evenly spaced samples (nominal value). [required]
% ODELTA	F	 Observed increment if different from nominal value.
% IDEP      I	 Type of dependent variable: 
%             = IUNKN (Unknown)
%             = IDISP (Displacement in nm)
%             = IVEL (Velocity in nm/sec)
%             = IVOLTS (Velocity in volts)
%             = IACC (Acceleration in nm/sec/sec)
% SCALE     F	 Multiplying scale factor for dependent variable [not currently used]
% DEPMIN	F	 Minimum value of dependent variable.
% DEPMAX	F	 Maximum value of dependent variable.
% DEPMEN	F	 Mean value of dependent variable.
% NZYEAR	N	GMT year corresponding to reference (zero) time in file.
% NZJDAY	N	GMT julian day.
% NZHOUR	N	GMT hour.
% NZMIN     N	GMT minute.
% NZSEC     N	GMT second.
% NZMSEC	N	GMT millisecond.
% NZDTTM	N	GMT date-time array. Six element array equivalenced to NZYEAR, NZJDAY, NZHOUR, NZMIN, NZSEC, and NZMSEC.
% KZDATE	A	 Alphanumeric form of GMT reference date. Derived from NZYEAR and NZJDAY.
% KZTIME	A	 Alphanumeric form of GMT reference time. Derived from NZHOUR, NZMIN, NZSEC, and NZMSEC.
% IZTYPE	I	Reference time equivalence:
%             = IUNKN (Unknown)
%             = IB (Begin time)
%             = IDAY (Midnight of refernece GMT day)
%             = IO (Event origin time)
%             = IA (First arrival time)
%             = ITn (User defined time pick n, n=0,9)
% O         F	 Event origin time (seconds relative to reference time.)
% KO        A	 Event origin time identification.
% 
% %%%%%%%%%%%%%%%%%
% %%%%% Phase Picks
% A         F	 First arrival time (seconds relative to reference time.)
% KA        K	 First arrival time identification.
% F         F	 Fini or end of event time (seconds relative to reference time.)
% KF        A	 Fini identification.
% Tn        F	 User defined time picks or markers, {\ai n}=0,9 (seconds relative to reference time).
% KT{\ai n}	K	 A User defined time pick identifications, {\ai n}=0,9.
% 
% %%%%%%%%%%%%%%%%%
% %%%%% Instrument Fields
% KINST     K	 Generic name of recording instrument.
% IINST     I	 Type of recording instrument. [not currently used]
% RESPn     F	 Instrument response parameters, n=0,9. [not currently used]
% 
% %%%%%%%%%%%%%%%%%
% %%%%% Station Fields
% KNETWK	K	 Name of seismic network.
% KSTNM     K	 Station name.
% ISTREG	I	 Station geographic region. [not currently used]
% STLA      F	 Station latitude (degrees, north positive)
% STLO      F	 Station longitude (degrees, east positive).
% STEL      F	 Station elevation (meters). [not currently used]
% STDP      F	 Station depth below surface (meters). [not currently used]
% CMPAZ     F	 Component azimuth (degrees clockwise from north).
% CMPINC	F	 Component incident angle (degrees from vertical).
% KCMPNM	K	 Component name.
% KSTCMP	A	 Station component. Derived from KSTNM, CMPAZ, and CMPINC.
% LPSPOL	L	TRUE if station components have a positive polarity (left-hand rule).
% 
% %%%%%%%%%%%%%%%%%
% %%%%% Event Fields
% KEVNM     K	 Event name.
% IEVREG	I	 Event geographic region. [not currently used]
% EVLA      F	 Event latitude (degrees, north positive).
% EVLO      F	 Event longitude (degrees, east positive).
% EVEL      F	 Event elevation (meters). [not currently used]
% EVDP      F	 Event depth below surface (meters). [not currently used]
% MAG       F	 Event magnitude.
% IMAGTYP	I	 Magnitude type:
%             = IMB (Bodywave Magnitude)
%             = IMS (Surfacewave Magnitude)
%             = IML (Local Magnitude)
%             = IMW (Moment Magnitude)
%             = IMD (Duration Magnitude)
%             = IMX (User Defined Magnitude)
% IMAGSRC	I	Source of magnitude information:
%             = INEIC	(National Earthquake Information Center)
%             = IPDE	 (Preliminary Determination of Epicenter)
%             = IISC	 (Internation Seismological Centre)
%             = IREB	 (Reviewed Event Bulletin)
%             = IUSGS	(US Geological Survey)
%             = IBRK	 (UC Berkeley)
%             = ICALTECH	(California Institute of Technology)
%             = ILLNL	(Lawrence Livermore National Laboratory)
%             = IEVLOC	(Event Location (computer program) )
%             = IJSOP	(Joint Seismic Observation Program)
%             = IUSER	(The individual using SAC2000)
%             = IUNKNOWN	(unknown)
% IEVTYP	I	 Type of event: 
%             = IUNKN (Unknown)
%             = INUCL (Nuclear event)
%             = IPREN (Nuclear pre-shot event)
%             = IPOSTN (Nuclear post-shot event)
%             = IQUAKE (Earthquake)
%             = IPREQ (Foreshock)
%             = IPOSTQ (Aftershock)
%             = ICHEM (Chemical explosion)
%             = IQB (Quarry or mine blast confirmed by quarry)
%             = IQB1 (Quarry/mine blast with designed shot info-ripple fired)
%             = IQB2 (Quarry/mine blast with observed shot info-ripple fired)
%             = IQBX (Quarry or mine blast - single shot)
%             = IQMT (Quarry/mining-induced events: tremors and rockbursts)
%             = IEQ (Earthquake)
%             = IEQ1 (Earthquakes in a swarm or aftershock sequence)
%             = IEQ2 (Felt earthquake)
%             = IME (Marine explosion)
%             = IEX (Other explosion)
%             = INU (Nuclear explosion)
%             = INC (Nuclear cavity collapse)
%             = IO_ (Other source of known origin)
%             = IL (Local event of unknown origin)
%             = IR (Regional event of unknown origin)
%             = IT (Teleseismic event of unknown origin)
%             = IU (Undetermined or conflicting information)
%             = IOTHER (Other)
% NEVID     N	Event ID (CSS 3.0)
% NORID     N	Origin ID (CSS 3.0)
% NWFID     N	Waveform ID (CSS 3.0)
% KHOLE     k	 Hole identification if nuclear event.
% DIST      F	 Station to event distance (km).
% AZ        F	 Event to station azimuth (degrees).
% BAZ       F	 Station to event azimuth (degrees).
% GCARC     F	 Station to event great circle arc length (degrees).
% 
% %%%%%%%%%%%%%%%%%
% %%%%% Miscellaneous Fields
% LCALDA	L	TRUE if DIST, AZ, BAZ, and GCARC are to be calculated from station and event coordinates.
% IQUAL     I	 Quality of data [not currently used]: 
%             = IGOOD (Good data)
%             = IGLCH (Glitches)
%             = IDROP (Dropouts)
%             = ILOWSN (Low signal to noise ratio)
%             = IOTHER (Other)
% ISYNTH	I	 Synthetic data flag [not currently used]:
%             = IRLDTA (Real data)
%             = ????? (Flags for various synthetic seismogram codes)
% KDATRD	K	 Date data was read onto computer.
% USER{\ai n}     F	 User defined variable storage area, {\ai n}=0,9.
% KUSER{\ai n}	K	 User defined variable storage area, {\ai n}=0,2.
% LOVROK	L	TRUE if it is okay to overwrite this file on disk.
% NXSIZE	N	 Spectral Length (Spectral files only)
% NYSIZE	N	Spectral Width (Spectral files only)
% XMINIMUM	F	Minimum value of X (Spectral files only)
% XMAXIMUM	F	Maximum value of X (Spectral files only)
% YMINIMUM	F	Minimum value of Y (Spectral files only)
% YMAXIMUM	F	Maximum value of Y (Spectral files only)