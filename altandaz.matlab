a=6378137;
b=635675.3;

Latitude = 39.948889 * (pi / 180);
Longitude = -74.900278 * (pi / 180);
LATITUDE = 47.87 * (pi / 180);
LONGITUDE = -154.53 * (pi / 180);

OBScoord = [Latitude, Longitude, 100];  	%Latitude in Degrees, Longitude in Degrees, altitude in meters
ISScoord = [LATITUDE, LONGITUDE, 413000];		%Same format as above
OBSadj = [0, 0, 0];		%Same format as above
ISSadj = [0, 0, 0];		%Same format as above, this initializes the array
CorrectedRO=sqrt((((a^2)*cos(OBScoord(1)))+((b^2)*sin(OBScoord(1))))^(2)/(((a)*cos(OBScoord(1)))+((b)*sin(OBScoord(1))))^(2));
CorrectedRI=sqrt((((a^2)*cos(ISScoord(1)))+((b^2)*sin(ISScoord(1))))^(2)/(((a)*cos(ISScoord(1)))+((b)*sin(ISScoord(1))))^(2));
ISSadj(1) = ISScoord(1);
ISSadj(2) = ISScoord(2)-OBScoord(2);		%Shift our coordinates of the ISS, OBS is now at 0,0
ISSadj(3) = 413000 + CorrectedRI;
OBSadj(1) = OBScoord(1);
OBSadj(3) = OBScoord(3) + CorrectedRO;

Xi = cos(ISSadj(1))*cos(ISSadj(2))*ISSadj(3);
Yi = cos(ISSadj(1))*sin(ISSadj(2))*ISSadj(3);
Zi = sin(ISSadj(1))*ISSadj(3);			%Convert from polar to cartesian coords for both adjusted locations
Xo = cos(OBSadj(1))*cos(OBSadj(2))*OBSadj(3)
Yo = cos(OBSadj(1))*sin(OBSadj(2))*OBSadj(3)
Zo = sin(OBSadj(1))*OBSadj(3)

Xirot = (Zi*sin(OBSadj(1)))+(Xi*cos(OBSadj(1)));
Yirot = Yi;
Zirot = (Xi*sin(-OBSadj(1)))+(Zi*(cos(-OBSadj(1))));
%Zirot = (Zi*cos(OBSadj(1)))-(Xi*sin(OBSadj(1)));
Xorot = (Xo*cos(-OBSadj(1)))-(Zo*sin(-OBSadj(1)))
%Xorot = (Zo*sin(-OBSadj(1)))+(Xo*cos(-OBSadj(1)))
OBSadj(3)
Yorot = Yo;
Zorot = (Zo*cos(OBSadj(1)))-(Xo*sin(OBSadj(1)));

ISScart = [Xirot, Yirot, Zirot]
%OBScart = [Xorot, Yorot, Zorot]
%Unitvec = [0, 0, 1];				%unit vector we are dotting with in the z direction to give us alt and az

% dotprod = (Unitvec(2)*ISScart(2))+(Unitvec(3)*ISScart(3));
% vectormag11 = 1;
% vectormag21 = sqrt((ISScart(2))^(2)+(ISScart(3))^(2));

%Azimuth = acos(Zirot/sqrt((Yirot)^(2)+(Zirot)^(2))) * (180/pi)	%needs additional info for conversion to 360
%if ISS Z coord < 0, 
Azimuth = atan2(Zirot, Yirot)*(180/pi)
Azimuth = 90-Azimuth

%dotprod2 = (Unitvec(1)*ISScart(1))+(Unitvec(3)*ISScart(3));
%vectormag12 = 1;
%vectormag22 = sqrt((ISScart(1))^(2)+(ISScart(3))^(2));

%Altitude = acos(Zirot/sqrt((Xirot)^(2)+(Zirot)^(2))) * (180/pi)
Altitude = atan2((Xirot-Xorot), sqrt((Yirot)^(2)+(Zirot)^(2))) *(180/pi)%needs additional info, between 0 and 180