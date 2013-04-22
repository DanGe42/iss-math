
% ThERE IS A PROBLEM WITHE THE SIGN OF THE AZIMUTH

LATITUDE = 47.87;
LONGITUDE = -154.53;
ALTITUDE = 415.38;
AZIMUTH = 306.6;
ELEVATION = -24.2;

Latitude = 39.948889;
Longitude = -74.900278;

% LATITUDE = 5.76;
% LONGITUDE = -22.65;
% ALTITUDE = 402.84;
% AZIMUTH = 111.6;
% ELEVATION = -25.8;
% 
% Latitude = 39.948889;
% Longitude = -74.900278;

% 
% LATITUDE = 18.45;
% LONGITUDE =  -8.69;
% ALTITUDE = 402.93;
% 
% AZIMUTH = 89.9;
% ELEVATION = -27.2;
% 
% Latitude = 39.95234;
% Longitude = -75.16379;

% rEarth = 6371;
rEarthEq = 6378;
rEarthPole = 6357;
rEarth = sqrt( ((rEarthEq^2*cosd(Latitude))^2 + ...
    (rEarthPole^2*sind(Latitude))^2) / ((rEarthEq*cosd(Latitude))^2 + ...
    (rEarthPole*sind(Latitude))^2) )

A = (0 : 99) / 100 * (2 * pi);
E = (-49 : 49) / 50 * (2 * pi);
[As, Es] = meshgrid(A,E);

n = rEarth * [sin(As(:)) .* cos(Es(:)), sin(As(:)) .* sin(Es(:)), cos(As(:))]; 
xu = rEarth * [ cosd(Latitude) * cosd(Longitude); 
                cosd(Latitude) * sind(Longitude);
                sind(Latitude)];
            
xISS = (rEarth + ALTITUDE) * [ cosd(LATITUDE) * cosd(LONGITUDE); 
                cosd(LATITUDE) * sind(LONGITUDE);
                sind(LATITUDE)];
            
d = xISS - xu;

EL = 90 - acosd( xu' * d / (norm(xu) * norm(d)));

P = null(xu');
x = -2000: 100 : 2000;
% [X,Y] = meshgrid(x);
for ii = 1 : length(x)
    
    for jj = 1 : length(x)
        
        pt(:, (ii - 1) * length(x) + jj) = x(ii) * P(:,1) + ...
            x(jj) * P(:,2) + xu;
        
    end
    
end

xn = [0; 0; rEarth];
dn = xn - xu;
pn = P' * dn;
ps = P' * d;

vn = [pn(1)*P(:,1) + pn(2)*P(:,2) + xu xu];
vs = [ps(1)*P(:,1) + ps(2)*P(:,2) + xu xu];


% acosd( ps' * pn / (norm(ps) * norm(pn)))
figure, plot3(0,0,0, 'ko', n(:,1), n(:,2), n(:,3), 'r.', pt(1,:), ...
    pt(2,:), pt(3,:), 'g.', xu(1), xu(2), xu(3), 'kd', xISS(1), xISS(2),...
    xISS(3), 'bo', vn(1,:), vn(2,:), vn(3,:), 'k', vs(1,:), vs(2,:), ...
    vs(3,:), 'b')
axis([-7000 7000 -7000 7000 -7000 7000])

tn = dn - (xu' / norm(xu) * dn) * xu / norm(xu);
ts = d - (xu' / norm(xu) * d) * xu / norm(xu);

AZ = acosd(tn' * ts / (norm(tn) * norm(ts)));

disp('True Azimuth')
AZIMUTH
disp('Estimatedf Azimuth')
AZ

disp('True Elevation')
ELEVATION
disp('Estimated Elevation')
EL
