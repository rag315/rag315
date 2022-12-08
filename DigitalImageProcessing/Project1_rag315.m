%% ECE 8473 Digital Image Processing: Project 1
% By Rebecca Garcia
% Dated: 
%% Loading File
pic0 = imread('cat.jpg');     % Read image
picgrey = rgb2gray(pic0);        % Coverting to grayscale
pic = double(picgrey);           % Converting from uint8 to double for processing
% % Displaying Image
% figure(1)
% 
% subplot(1,3,1)
% imshow(pic0)
% title('Original Picture')
% 
% subplot(1,3,2)
% imshow(picgrey);
% title('Grayscale')
% 
% subplot(1,3,3)
% imhist(picgrey);
% title('Grayscale Histogram')



%% Part 1: Implement histogram equalization
% Initializing Variables
L = max(max(pic));  % Maximum Grayscale Value
n = numel(pic);     % Number of Pixels

[C, ~, ic] = unique(pic);           % Find # of unique elements
counts = accumarray(ic,1);          % # of times each element appears 
chart = [C, counts];                % Returns [intensity element_count]
chart(:,3) = chart(:,2)/n;          % p = intensity lvl count/total pixels

% Summation Loop Start
chart(1,4) = chart(1,3);            
for i = 2:length(chart)
    chart(i,4) = chart(i-1,4) + chart(i,3);
end
chart(:,5) = round(chart(:,4)*L);   % Round(Sum(p)*L)

% Replacing ea. pixel level with new intensity level
piceq = zeros(length(pic(:,1)),length(pic(1,:)));
for i = 1:n
    for j = 1:length(chart)
        if pic(i) == chart(j,1)
            piceq(i) = chart(j,5); 
        end
    end
end

piceq = uint8(piceq);             % Convert double to image format

% figure(2)
% subplot(1,2,1)
% imshow(piceq)
% title('Equalized Image')
% subplot(1,2,2)
% imhist(piceq)
% title('Equalized Histogram')

%% Clearing Vars
clearvars C Error counts i ic j l n L

%% Clearing Variables
clear vars m n i j X Y Dummy 

%% ----------------------- Error Checking -------------------------------
%% Part 1 error checking
% MATLAB's default Histogram Equalization. Preserved for error Checking
% A = histeq(picgrey,255); 
% figure(4);
% subplot(1,2,1)
% imshow(A)
% title("MATLAB's Equalization Function")
% subplot(1,2,2)
% imhist(A,255)
% title("MATLAB's Equalization Histogram")
%% Calculating Error
% A = double(A);
% piceq = double(piceq);
% Error = ((A-piceq)./piceq)*100;
% AvgError = norm(mean(mean(Error,'omitnan')));
% fprintf("Average Error between Calculated Equalization and Matlab's Default Function: ")
% fprintf('%5.4f%%\n',AvgError);

