%% ECE 8473 Digital Image Processing: Project 3, Part 1
% By Rebecca Garcia
% Dated: October 20th, 2022
clc; clear all; close all
%% Loading File
pic0 = imread('cat.jpg'); % Read image
picgrey = rgb2gray(pic0); % Coverting to grayscale
pic = double(picgrey);    % Converting from uint8 to double for processing
pic = pic/255;            % Normalize Image
%% Method 1
R = 255*abs(sin(5*pic+30));
G = 255*abs(sin(3*pic+0));
B = 255*abs(sin(2*pic+60));
rgb = cat(3, R, G, B);
rgb = uint8(rgb);

figure(1);
subplot(1,3,1)
imshow(pic0)
title('Original')
subplot(1,3,2)
imshow(uint8(picgrey))
title('grayscale')
subplot(1,3,3)
imshow(rgb)
title('Recovered')
% Waveforms
x=0:0.1:10;
red = abs(sin(5*x+30));
green = abs(sin(3*x+0));
blue = abs(sin(2*x+60));

figure(2)
subplot(3,1,1)
plot(x,red,'r')
xlim([0 10]);
subplot(3,1,2)
plot(x,green,'g')
subplot(3,1,3)
plot(x,blue,'b')


%% Method 2
a = 1:10;
theta = 0:10:90;
i = 1; j = 1;
pic0 = double(pic0);
r_min = 10000000; g_min = r_min; b_min = g_min;
mean1 = mean(mean(pic0(:,:,1)));
mean2 = mean(mean(pic0(:,:,2)));
mean3 = mean(mean(pic0(:,:,3)));

for i = 1:length(a)
    for j = 1:length(theta)
        r = 255*abs(sin(a(i)*pic+theta(j)));
        r_mean = mean(mean(r(:,:)));
        r_diff = abs(r_mean-mean1);
        
        g = 255*abs(sin(a(i)*pic+theta(j)));
        g_mean = mean(mean(g(:,:)));
        g_diff = abs(g_mean-mean2);
        
        b = 255*abs(sin(a(i)*pic+theta(j)));
        b_mean = mean(mean(b(:,:)));
        b_diff = abs(b_mean-mean3);
        
        if r_diff < r_min
            r_min = r_diff;
            R = r;
            R_index = [i j];
        end
        if g_diff < g_min
            g_min = g_diff;
            G = g;
            G_index = [i j];
        end
        if b_diff < b_min
            b_min = b_diff;
            B = b;
            B_index = [i j];
        end
    end
end
% Waveforms
x = 0:0.1:10;
red = abs(sin(a(R_index(1))*x+theta(R_index(2))));
green = abs(sin(a(G_index(1))*x+theta(G_index(2))));
blue = abs(sin(a(B_index(1))*x+theta(B_index(2))));

rgb = cat(3, R, G, B);
rgb = uint8(rgb);

figure(3);
subplot(1,3,1)
imshow(uint8(pic0))
title('Original')
subplot(1,3,2)
imshow(uint8(picgrey))
title('grayscale')
subplot(1,3,3)
imshow(rgb)
title('Recovered')        

figure(4)
subplot(3,1,1)
plot(x,red,'r')
xlim([0 10]);
subplot(3,1,2)
plot(x,green,'g')
subplot(3,1,3)
plot(x,blue,'b')
        