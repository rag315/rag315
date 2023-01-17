function [Azimuth,Elevation,ZenithAngle] = SunPositionAlgorithm(lat,lon,varargin)
% vargIn is either supplied as Day, Month,Year,Hours,Minutes,Seconds or it
% is pulled from local computer time if not supplied. Time arguments are an
% all or nothing sort of deal

%% Purpose: To calculate the position of the sun at a given time and location
% Converted by Rebecca Garcia, C++ Sourced from http://www.psa.es/sdg/sunpos.htm
format long
%% Constants
Pi = 3.14159265358979323846; % Higher Accuracy Pi
rad = Pi/180;                % degree to radian conversion
EarthMR = 6371.01;           % Earth's Mean Radius (km)
AU = 149597890;              % Astronomical Unit (km)
%% User Inputs
% Universal Time Coordinated Inputs: Day, Month, Year, Hours, Minutes, Seconds 
% NOTE: Time Inputs MUST be in UTC 24-hr format. For CST Time Zones,
% convert from 12 hr to 24 hr format and add 6. If under Daylight Savings,
% repeat the same steps but add 5.
% Explanation of Different Time Formats:
% http://www.astronomy.ohio-state.edu/~pogge/Ast350/timesys.html
% Location Inputs: Longitude, Latitude in Deg
% North is Positive, South Negative. East is Positive, West is Negative

%% Defaults
%UT.Day = 5; UT.Month = 1; UT.Year = 2021;
%UT.Hours = 20; UT.Minutes = 30; UT.Seconds = 0;
%Local.Longitude = -88.84600639343262; Local.Latitude = 33.43616876229168;  % Raspet Lat Long

%% Argument handling
if isempty(varargin)
    t = datetime('now');
    [UT.Year,UT.Month,UT.Day] = ymd(t);
    [UT.Hours,UT.Minutes,UT.Seconds] = hms(t);
else
    UT.Year = varargin{1};
    UT.Month = varargin{2};
    UT.Day = varargin{3};
    UT.Hours = varargin{4};
    UT.Minutes = varargin{5};
    UT.Seconds = varargin{6};
end

Local.Longitude = lon;
Local.Latitude = lat;

%% Function Call
% Returns Elapsed Julian Days & Univeral Time in Decimals
[deltaJD, Time] = UT2Julian(UT); 

%% Ecliptic Coordinate Calculations
% ecliptic longitude and obliquity of the ecliptic in radians 
% Note: the result may be greater than 2*Pi
% Numerical Constants based on some Astronomy Stuff 
Omega = 2.1429 - 0.0010394594 * deltaJD;
MLong = 4.8950630 + 0.017202791698 * deltaJD;   % Mean Longitude (Radians)
MA = 6.2400600 + 0.0172019699 * deltaJD;        % Mean Anomaly
ELong = MLong+0.03341607*sin(MA)+0.00034894*sin(2*MA)...
    -0.0001134-0.0000203*sin(Omega);            % Ecliptic Longitude
EObliquity = 0.4090928-6.2140e-9*deltaJD+0.0000396*cos(Omega); % Ecliptic Obliquity

%% Calculate celestial coordinates (right ascension and declination)
% Note: the result may be greater than 2*Pi

Sin_ELong = sin(ELong);
dY = cos(EObliquity) * Sin_ELong;
dX = cos(ELong);
RightAscension = atan2(dY, dX);
if (RightAscension < 0.0) 
    RightAscension = RightAscension + 2*Pi;
end
Declination = asin(sin(EObliquity) * Sin_ELong);

%% Calculating Sun Positions in Local Coordinates
% Greenwich Mean Sidereal Time
GreenwichMST = 6.6974243242 + 0.0657098283*deltaJD + Time;
% Local Mean Sidereal Time
LocalMST= (GreenwichMST*15 + Local.Longitude)*rad;  
HourAngle = LocalMST - RightAscension;
% Converting Latitude to Radians & decomposing along X,Y axis
Latitude_Rad = Local.Latitude*rad;
Cos_Latitude = cos(Latitude_Rad);
Sin_Latitude = sin(Latitude_Rad);
Cos_HourAngle = cos(HourAngle);
% Zenith Angle (rad)
ZenithAngle = (acos(Cos_Latitude*Cos_HourAngle*cos(Declination) + sin(Declination)*Sin_Latitude));
% Calculating Sun's Azimuth (deg)
dY = -sin(HourAngle);
dX = tan(Declination)*Cos_Latitude - Sin_Latitude*Cos_HourAngle;
Azimuth = atan2(dY, dX);
if (Azimuth < 0.0)
    Azimuth = Azimuth + 2*Pi;
end
Azimuth = Azimuth / rad;
% Parallax Correction
Parallax = (EarthMR/AU)* sin(ZenithAngle);
% Zenith Angle (deg)
ZenithAngle = (ZenithAngle + Parallax) / rad;
% Elevation (deg)
Elevation = 90 - ZenithAngle;

%% UTC to Julian Function
% This function converts from UTC format to astronomical Julian Date format
% Inputs: (Day, Month, Year, Hours, Minutes, Seconds)
% Outputs: Elapsed Julian Days = (Current JD - Jan 1, 2000 in JD)
function [ElapsedJD, Time] = UT2Julian(UT)
    Time = UT.Hours+(UT.Minutes + UT.Seconds/60)/60; % UT Time in Decimals
    A = (UT.Month-14)/12;
    B = (1461*(UT.Year+4800+A))/4+(367*(UT.Month-2-12*A)) / ...
        12-(3*((UT.Year + 4900+ A)/100))/4+UT.Day-32075;
    Julian = B-.5 + Time/24;
    ElapsedJD = Julian - 2451545.0;
end
% Example: For January 5, 2021 at 20:30:00 UTC, (2:30 pm CST) the JD is equivelent
% to 2459221.35417
end
