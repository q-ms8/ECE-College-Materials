clear all;
close all;
clc;

%% data of(elevation).

MData1  = xlsread('droopingE.xlsx');
Mtheta1 = MData1(:,1);
NMP1    = MData1(:, 2);



% Ploting Normalized-CST Radiation Pattern in dB Scale (theta).
CSTData2  = xlsread('theta90.xlsx');
% CSTtheta2 = (-90:1:270).*(pi/180);
CSTP2 = CSTData2(:,6);
NCSTP2 = CSTP2 - max(CSTP2);



%% ploting H-plan
figure(1)
% % subplot(2, 1, 1)
polarplot(Mtheta1);
title('H-Plan RP')
rlim([-40 0])                          % Set radial (dB) range
rticks([-40 -30 -20 -10 0])            % Define dB ticks
thetalim([0 360])   


% --- NEW CODE TO ROTATE THE PLOT ---
ax = gca;                            % Get current axes
ax.ThetaZeroLocation = 'top';        % Moves 0 degrees to the top
ax.ThetaDir = 'counterclockwise';    % Puts 90 on the left, 270 on the right (like your image)













% data of(azmuth).

MData2  = xlsread('droopingH.xlsx');
Mtheta2 = MData2(:,1);
NMP2    = MData2 + 2.4;



% ploting E-plan
figure(2)
polarplot(Mtheta2);
title('E-Plan RP phi=0')
rlim([-40 0])                          % Set radial (dB) range
rticks([-40 -30 -20 -10 0])            % Define dB ticks
thetalim([0 360])   
ax = gca;                            % Get current axes
ax.ThetaZeroLocation = 'top';        % Moves 0 degrees to the top
ax.ThetaDir = 'counterclockwise';    % Puts 90 on the left, 270 on the right (like your image)


