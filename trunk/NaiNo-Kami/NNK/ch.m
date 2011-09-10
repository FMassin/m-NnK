%CH    change SAC header
%
%
%    Change SAC header variables for 
%    SAC files read in to matlab with rsac.m
%    
%    Examples:
%
%    To change the SAC variable DELTA from station KATH to
%    the matlab variable dt:
%
%    KATH=ch(KATH,'DELTA',dt);
%
%    To change the SAC variables STLA and STLO from station KATH
%    to the matlab variables lat and lon:
%
%    KATH=ch(KATH,'STLA',lat,'STLO',lon)
%
%    To change the SAC variable KT0 from station SKS to sSKS
%    for station KATH (for example):
%
%    KATH=ch(KATH,'KT0','sSKS'); 
%
%    Note:  this program can only handle one seismogram
%    file at a time, but can change multiple header values.
%
%    by Michael Thorne (4/2004)  mthorne@asu.edu
%
%    See also:  RSAC, LH, BSAC, WSAC 
%%%%%%%%%%%%%%%%%
%%%%% general fields
% NPTS      N	 Number of points per data component.                       [required]
% NVHDR     N	 Header version number. Current value is the integer 6. 
%                Older version data (NVHDR < 6) are automatically updated 
%                when read into sac.                                        [required]
% B         F	 Beginning value of the independent variable.               [required]
% E         F	 Ending value of the independent variable.                  [required]
% IFTYPE	I	 Type of file                                               [required]:
%             = ITIME {Time series file}
%             = IRLIM {Spectral file---real and imaginary}
%             = IAMPH {Spectral file---amplitude and phase}
%             = IXY {General x versus y data}
%             = IXYZ {General XYZ (3-D) file}
% LEVEN     L	TRUE if data is evenly spaced.                              [required]
% DELTA     F	 Increment between evenly spaced samples (nominal value).   [required]
% ODELTA	F	 Observed increment if different from nominal value.
% IDEP      I	 Type of dependent variable: 
%             = IUNKN (Unknown)
%             = IDISP (Displacement in nm)
%             = IVEL (Velocity in nm/sec)
%             = IVOLTS (Velocity in volts)
%             = IACC (Acceleration in nm/sec/sec)
% SCALE     F	 Multiplying scale factor for dependent variable            [not currently used]
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
% IINST     I	 Type of recording instrument.                              [not currently used]
% RESPn     F	 Instrument response parameters, n=0,9.                     [not currently used]
% 
% %%%%%%%%%%%%%%%%%
% %%%%% Station Fields
% KNETWK	K	 Name of seismic network.
% KSTNM     K	 Station name.
% ISTREG	I	 Station geographic region.                                 [not currently used]
% STLA      F	 Station latitude (degrees, north positive)
% STLO      F	 Station longitude (degrees, east positive).
% STEL      F	 Station elevation (meters).                                [not currently used]
% STDP      F	 Station depth below surface (meters).                      [not currently used]
% CMPAZ     F	 Component azimuth (degrees clockwise from north).
% CMPINC	F	 Component incident angle (degrees from vertical).
% KCMPNM	K	 Component name.
% KSTCMP	A	 Station component. Derived from KSTNM, CMPAZ, and CMPINC.
% LPSPOL	L	 TRUE if station components have a positive polarity (left-hand rule).
% 
% %%%%%%%%%%%%%%%%%
% %%%%% Event Fields
% KEVNM     K	 Event name. KEVNM is 16 characters (4 words) long. All other K fields are 8 characters (2 words) long.
% IEVREG	I	 Event geographic region.                                   [not currently used]
% EVLA      F	 Event latitude (degrees, north positive).
% EVLO      F	 Event longitude (degrees, east positive).
% EVEL      F	 Event elevation (meters).                                  [not currently used]
% EVDP      F	 Event depth below surface (meters).                        [not currently used]
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

function [output]=ch(file,varargin);

% first test to see if the file is indeed a sacfile
%---------------------------------------------------------------------------
if (file(303,3)~=77 & file(304,3)~=73 & file(305,3)~=75 & file(306,3)~=69)
  error('Specified Variable is not in SAC format ...')
elseif nargin <= 1
  error('Not enough input arguments ...')
end

output = file;

for i=1:2:(nargin-1);
input = double(varargin{i});

if size(varargin{i} < 8)
  insize = length(varargin{i});
  for kk=(insize+1):8;
   input(kk) = 32; 
  end
end


if input == double('DELTA   '); output(1,3) = varargin{i+1}; end
if input == double('DEPMIN  '); output(2,3) = varargin{i+1}; end
if input == double('DEPMAX  '); output(3,3) = varargin{i+1}; end
if input == double('SCALE   '); output(4,3) = varargin{i+1}; end
if input == double('ODELTA  '); output(5,3) = varargin{i+1}; end
if input == double('B       '); output(6,3) = varargin{i+1}; end
if input == double('E       '); output(7,3) = varargin{i+1}; end
if input == double('O       '); output(8,3) = varargin{i+1}; end
if input == double('A       '); output(9,3) = varargin{i+1}; end
if input == double('T0      '); output(11,3) = varargin{i+1}; end
if input == double('T1      '); output(12,3) = varargin{i+1}; end
if input == double('T2      '); output(13,3) = varargin{i+1}; end
if input == double('T3      '); output(14,3) = varargin{i+1}; end
if input == double('T4      '); output(15,3) = varargin{i+1}; end
if input == double('T5      '); output(16,3) = varargin{i+1}; end
if input == double('T6      '); output(17,3) = varargin{i+1}; end
if input == double('T7      '); output(18,3) = varargin{i+1}; end
if input == double('T8      '); output(19,3) = varargin{i+1}; end
if input == double('T9      '); output(20,3) = varargin{i+1}; end
if input == double('F       '); output(21,3) = varargin{i+1}; end
if input == double('RESP0   '); output(22,3) = varargin{i+1}; end
if input == double('RESP1   '); output(23,3) = varargin{i+1}; end
if input == double('RESP2   '); output(24,3) = varargin{i+1}; end
if input == double('RESP3   '); output(25,3) = varargin{i+1}; end
if input == double('RESP4   '); output(26,3) = varargin{i+1}; end
if input == double('RESP5   '); output(27,3) = varargin{i+1}; end
if input == double('RESP6   '); output(28,3) = varargin{i+1}; end
if input == double('RESP7   '); output(29,3) = varargin{i+1}; end
if input == double('RESP8   '); output(30,3) = varargin{i+1}; end
if input == double('RESP9   '); output(31,3) = varargin{i+1}; end
if input == double('STLA    '); output(32,3) = varargin{i+1}; end
if input == double('STLO    '); output(33,3) = varargin{i+1}; end
if input == double('STEL    '); output(34,3) = varargin{i+1}; end
if input == double('STDP    '); output(35,3) = varargin{i+1}; end
if input == double('EVLA    '); output(36,3) = varargin{i+1}; end
if input == double('EVLO    '); output(37,3) = varargin{i+1}; end
if input == double('EVEL    '); output(38,3) = varargin{i+1}; end
if input == double('EVDP    '); output(39,3) = varargin{i+1}; end
if input == double('MAG     '); output(40,3) = varargin{i+1}; end
if input == double('USER0   '); output(41,3) = varargin{i+1}; end
if input == double('USER1   '); output(42,3) = varargin{i+1}; end
if input == double('USER2   '); output(43,3) = varargin{i+1}; end
if input == double('USER3   '); output(44,3) = varargin{i+1}; end
if input == double('USER4   '); output(45,3) = varargin{i+1}; end
if input == double('USER5   '); output(46,3) = varargin{i+1}; end
if input == double('USER6   '); output(47,3) = varargin{i+1}; end
if input == double('USER7   '); output(48,3) = varargin{i+1}; end
if input == double('USER8   '); output(49,3) = varargin{i+1}; end
if input == double('USER9   '); output(50,3) = varargin{i+1}; end
if input == double('DIST    '); output(51,3) = varargin{i+1}; end
if input == double('AZ      '); output(52,3) = varargin{i+1}; end
if input == double('BAZ     '); output(53,3) = varargin{i+1}; end
if input == double('GCARC   '); output(54,3) = varargin{i+1}; end
if input == double('DEPMEN  '); output(57,3) = varargin{i+1}; end
if input == double('CMPAZ   '); output(58,3) = varargin{i+1}; end
if input == double('CMPINC  '); output(59,3) = varargin{i+1}; end
if input == double('XMINIMUM'); output(60,3) = varargin{i+1}; end
if input == double('XMAXIMUM'); output(61,3) = varargin{i+1}; end
if input == double('YMINIMUM'); output(62,3) = varargin{i+1}; end
if input == double('YMAXIMUM'); output(63,3) = varargin{i+1}; end

if input == double('NZYEAR  '); output(71,3) = varargin{i+1}; end
if input == double('NZJDAY  '); output(72,3) = varargin{i+1}; end
if input == double('NZHOUR  '); output(73,3) = varargin{i+1}; end
if input == double('NZMIN   '); output(74,3) = varargin{i+1}; end
if input == double('NZSEC   '); output(75,3) = varargin{i+1}; end
if input == double('NZMSEC  '); output(76,3) = varargin{i+1}; end
if input == double('NVHDR   '); output(77,3) = varargin{i+1}; end
if input == double('NORID   '); output(78,3) = varargin{i+1}; end
if input == double('NEVID   '); output(79,3) = varargin{i+1}; end
if input == double('NPTS    '); output(80,3) = varargin{i+1}; end
if input == double('NWFID   '); output(82,3) = varargin{i+1}; end
if input == double('NXSIZE  '); output(83,3) = varargin{i+1}; end
if input == double('NYSIZE  '); output(84,3) = varargin{i+1}; end
if input == double('IFTYPE  '); output(86,3) = varargin{i+1}; end
if input == double('IDEP    '); output(87,3) = varargin{i+1}; end
if input == double('IZTYPE  '); output(88,3) = varargin{i+1}; end
if input == double('IINST   '); output(90,3) = varargin{i+1}; end
if input == double('ISTREG  '); output(91,3) = varargin{i+1}; end
if input == double('IEVREG  '); output(92,3) = varargin{i+1}; end
if input == double('IEVTYP  '); output(93,3) = varargin{i+1}; end
if input == double('IQUAL   '); output(94,3) = varargin{i+1}; end
if input == double('ISYNTH  '); output(95,3) = varargin{i+1}; end
if input == double('IMAGTYP '); output(96,3) = varargin{i+1}; end
if input == double('IMAGSRC '); output(97,3) = varargin{i+1}; end

if input == double('LEVEN   '); output(106,3) = varargin{i+1}; end
if input == double('LPSPOL  '); output(107,3) = varargin{i+1}; end
if input == double('LOVROK  '); output(108,3) = varargin{i+1}; end
if input == double('LCALDA  '); output(109,3) = varargin{i+1}; end

if input == double('KSTNM   ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(111:118,3) = newname(1:8)';
end
if input == double('KEVNM   ');
 newname = double(varargin{i+1});
  if size(newname) < 16; newname((length(varargin{i+1})+1):16) = 32; end
 output(119:134,3) = newname(1:16)';
end
if input == double('KHOLE   ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(135:142,3) = newname(1:8)';
end
if input == double('KO      ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(143:150,3) = newname(1:8)';
end
if input == double('KA      ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(151:158,3) = newname(1:8)';
end
if input == double('KT0     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(159:166,3) = newname(1:8)';
end
if input == double('KT1     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(167:174,3) = newname(1:8)';
end
if input == double('KT2     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(175:182,3) = newname(1:8)';
end
if input == double('KT3     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(183:190,3) = newname(1:8)';
end
if input == double('KT4     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(191:198,3) = newname(1:8)';
end
if input == double('KT5     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(199:206,3) = newname(1:8)';
end
if input == double('KT6     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(207:214,3) = newname(1:8)';
end
if input == double('KT7     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(215:222,3) = newname(1:8)';
end
if input == double('KT8     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(223:230,3) = newname(1:8)';
end
if input == double('KT9     ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(231:238,3) = newname(1:8)';
end
if input == double('KF      ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(239:246,3) = newname(1:8)';
end
if input == double('KUSER0  ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(247:254,3) = newname(1:8)';
end
if input == double('KUSER1  ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(255:262,3) = newname(1:8)';
end
if input == double('KUSER2  ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(263:270,3) = newname(1:8)';
end
if input == double('KCMPNM  ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(271:278,3) = newname(1:8)';
end
if input == double('KNETWK  ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(279:286,3) = newname(1:8)';
end
if input == double('KDATRD  ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(287:294,3) = newname(1:8)';
end
if input == double('KINST   ');
 newname = double(varargin{i+1});
  if size(newname) < 8; newname((length(varargin{i+1})+1):8) = 32; end
 output(295:302,3) = newname(1:8)';
end

end