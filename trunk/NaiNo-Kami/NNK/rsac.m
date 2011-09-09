%RSAC    Read SAC binary files.
%    by Michael Thorne (4/2004)   mthorne@asu.edu
%    modified by Fred Massin (2010) fred.massin@gmail.com
%
%    RSAC('sacfile',endian) reads in a SAC (seismic analysis code) binary
%    format file into a 3-column vector.
%    Column 1 contains time values.
%    Column 2 contains amplitude values.
%    Column 3 contains all SAC header information.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Added by Fred Massin (2010):
%    Byte order could be specified ('little-endian' or 'big-endian')
%    Default byte order is little-endian.  M-file can be set to default
%    big-endian byte order.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    usage:  output = rsac('sacfile','little-endian' or 'big-endian')
%
%    Examples:
%
%    KATH = rsac('KATH.R');
%    plot(KATH(:,1),KATH(:,2))
%
%    [SQRL, AAK] = rsac('SQRL.R','AAK.R');
%
%    by Michael Thorne (4/2004)   mthorne@asu.edu

function [out] = rsac(varargin);%vararg

for nrecs = 1:nargin

    sacfile = varargin{nrecs};
    
    if exist(sacfile,'file') == 2
        
        %------------------------------------------------------------------
        %    Default byte-order
        %    endian  = 'big-endian' byte order (e.g., UNIX)
        %            = 'little-endian' byte order (e.g., LINUX)
        % default = 'big-endian';
        default = 'little-endian';
        endian = varargin{nargin};
        if strcmp(char(endian),'little-endian') == 0 & strcmp(char(endian),'big-endian') == 0
            endian= default;
        end

        if strcmp(endian,'big-endian')
            fid = fopen(sacfile,'r','ieee-be');
        elseif strcmp(endian,'little-endian')
            fid = fopen(sacfile,'r','ieee-le');
        end

        % read in single precision real header variables:
        %---------------------------------------------------------------------------
        for i=1:70
            test=fread(fid,1,'single');if length(test)==1;h(i)=test;else h(i)=6;end
            %h(i)=fread(fid,1,'single')
        end

        % read in single precision integer header variables:
        %---------------------------------------------------------------------------
        for i=71:105
            test=fread(fid,1,'int32');if length(test)==1;h(i)=test;else h(i)=6;end
            %h(i) = fread(fid,1,'int32');
        end


        % Check header version = 6 and issue warning
        %---------------------------------------------------------------------------
        % If the header version is not NVHDR == 6 then the sacfile is likely of the
        % opposite byte order.  This will give h(77) some ridiculously large
        % number.  NVHDR can also be 4 or 5.  In this case it is an old SAC file
        % and rsac cannot read this file in.  To correct, read the SAC file into
        % the newest verson of SAC and w over.
        %
        if (h(77) == 4 | h(77) == 5)
            message = strcat('NVHDR = 4 or 5. File: "',sacfile,'" may be from an old version of SAC.');
            error(message)
        elseif h(77) ~= 6
            message = strcat('Current rsac byte order: "',endian,'". File: "',sacfile,'" may be of opposite byte-order.');
            error(message)
        end

        % read in logical header variables
        %---------------------------------------------------------------------------
        for i=106:110
            test=fread(fid,1,'int32');if length(test)==1;h(i)=test;else h(i)=6;end
            %h(i) = fread(fid,1,'int32');
        end

        % read in character header variables
        %---------------------------------------------------------------------------
        for i=111:302
            test=fread(fid,1,'char');if length(test)==1;h(i)=test;else h(i)=6;end
            %h(i) = (fread(fid,1,'char'))';
        end

        % read in amplitudes
        %---------------------------------------------------------------------------

        YARRAY     = fread(fid,'single');

        if h(106) == 1
            XARRAY = (linspace(h(6),h(7),h(80)))';
        else
            XARRAY = (linspace(h(6),h(7),h(80)))';
            warning('LEVEN must = 1; SAC file not evenly spaced')
        end

        % add header signature for testing files for SAC format
        %---------------------------------------------------------------------------
        h(303) = 77;
        h(304) = 73;
        h(305) = 75;
        h(306) = 69;

        % arrange output files
        %---------------------------------------------------------------------------

        OUTPUT(:,1) = XARRAY;
        if length(YARRAY)~=size(OUTPUT,1);YARRAY=zeros(size(OUTPUT,1),1);end
        OUTPUT(:,2) = YARRAY;
        OUTPUT(1:306,3) = h(1:306)';

        %pad xarray and yarray with NaN if smaller than header field
        if h(80) < 306
            OUTPUT((h(80)+1):306,1) = NaN;
            OUTPUT((h(80)+1):306,2) = NaN;
        end

        fclose(fid);
        out{nrecs} = OUTPUT;clear OUTPUT
        %varargout{nrecs} = OUTPUT;clear OUTPUT
    end
end

if length(out)==1;out=out{1};end