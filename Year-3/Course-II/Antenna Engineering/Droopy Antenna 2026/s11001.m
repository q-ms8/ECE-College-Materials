%% clearation
close all;
clear all; 
clc;

%% import data
% Import data (assuming it's in a text file named 'antenna_data.txt')
data = xlsread('droopingS11real.xlsx'); % Adjust format if needed

%% masured data
% Extract data columns
freq = data(:, 1); % Frequency in Hz
real_part = data(:, 2);
imag_part = data(:, 3);
% Convert frequency to GHz for plotting
freq_GHz = freq/1e9;
% Calculate magnitude and dB
s11_magnitude = sqrt(real_part.^2 + imag_part.^2);
s11_db = 20*log10(s11_magnitude);
% Calculate VSWR for additional insight
vswr = (1 + s11_magnitude)./(1 - s11_magnitude);

%% CST-S11. data
data1  = xlsread('s11.xlsx');
freq1 = data1(:, 1);
real_part1 = data1(:, 2);
imag_part1 = data1(:, 3);
% Calculate magnitude of S11 data
s11_magnitude1 = sqrt(real_part1.^2 + imag_part1.^2);
% Convert magnitude to dB 
s11_db1 = 20*log10(s11_magnitude1);

%% Plot S11 - Figure 3
figure(3)
plot(freq_GHz, s11_db, 'LineWidth', 1.5); 
grid on; hold on;
% Add labels and title to make it clear
xlabel('Frequency (GHz)', 'FontWeight', 'bold');
ylabel('S_{11} (dB)', 'FontWeight', 'bold');
title('Measured S_{11} vs. Frequency');

% Set y-axis limits to -35 minimum
ylim([-35 0]); 

% Add -10 dB line (common match threshold)
yline(-10, '--r', '-10 dB');

% --- FIND AND PLOT ALL INTERSECTIONS ---
threshold = -10;
shifted_s11 = s11_db - threshold; 
% Find all indices where the signal crosses the threshold
crossings = find(shifted_s11(1:end-1) .* shifted_s11(2:end) <= 0);

% Loop through EVERY crossing found
for i = 1:length(crossings) 
    idx = crossings(i);
    
    % Get coordinates for interpolation
    x1 = freq_GHz(idx);     x2 = freq_GHz(idx+1);
    y1 = shifted_s11(idx);  y2 = shifted_s11(idx+1);
    
    % Linear interpolation to find the exact frequency
    f_intersect = x1 - y1 * (x2 - x1) / (y2 - y1);
    
    % Draw the vertical dashed line manually down to -35
    plot([f_intersect f_intersect], [-35, 0], '--b');
    
    % Mark the exact intersection point with a star
    plot(f_intersect, threshold, 'b*', 'MarkerSize', 8);
    
    % Add rotated text at the bottom to prevent overlapping
    % Adjusted starting position to match the new -35 limit
    y_pos = -34.5 + mod(i, 2) * 2; 
    text(f_intersect, y_pos, sprintf(' %.3f GHz ', f_intersect), ...
        'Color', 'b', 'Rotation', 90, 'HorizontalAlignment', 'right', 'FontWeight', 'bold');
end
hold off;

%% Plot S11 - Figure 2
figure(2);
plot(freq_GHz, s11_db, 'LineWidth', 2);
grid on; hold on;
xlabel('Frequency (GHz)');
ylabel('S_{11} (dB)');
title('Measured and simulated S_{11} of Drooping Antenna');

% Set y-axis limits to -35 minimum here as well
ylim([-35 0]); 

% Add -10 dB line (common match threshold)
yline(-10, '--r', '-10 dB');

% Plot simulated data (adjusted to LineWidth for a cleaner look)
plot(freq1', s11_db1, 'k', 'LineWidth', 1.5)

% Legend updated to match the 3 current plots
legend('Measured s11', '-10dB', 'Simulated s11', 'Location', 'best')
hold off;