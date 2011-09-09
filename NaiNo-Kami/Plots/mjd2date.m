function [matlabdate] = mjd2date(mjd)

%   Sources:  - http://tycho.usno.navy.mil/mjd.html
%             - The Calendar FAQ (http://www.faqs.org)
%             - Peter John Acklam (http://home.online.no/~pjacklam)
if exist('form','var')==0;form='';end

%jd = mjd2jd(mjd); % http://home.online.no/~pjacklam
jday = mjd + 2400000.5;

%[year, month, day] = jd2date(jd); % http://home.online.no/~pjacklam
ijday = floor(jday);                 % integer part
fjday = jday - ijday;                % fraction part
% The following algorithm is from the Calendar FAQ.
b = 0;
c = ijday + 32082;

d = floor((4 * c + 3) / 1461);
e = c - floor((1461 * d) / 4);
m = floor((5 * e + 2) / 153);

day   = e - floor((153 * m + 2) / 5) + 1;
month = m + 3 - 12 * floor(m / 10);
year  = b * 100 + d - 4800 + floor(m / 10);

fmjd = mjd - floor(mjd);
%[hour, minute, second] = days2hms(fmjd); %http://home.online.no/~pjacklam
second = 86400 * fmjd;
hour   = fix(second/3600);           % get number of hours
second = second - 3600*hour;         % remove the hours
minute = fix(second/60);             % get number of minutes
second = second - 60*minute;         % remove the minutes

matlabdate = datenum(year,month,day,hour,minute,second) ; 


