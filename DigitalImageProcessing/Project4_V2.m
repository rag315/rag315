clc; clear all; close all
%% Loading File
pic0 = imread('Mona_Lisa.jpeg');     % Read image
picgrey = rgb2gray(pic0);     % Coverting to grayscale
pic = double(picgrey);        % Converting from uint8 to double for processing
%% Compression Ratios
DivBy = [16 8 4 2];  % Section Square Size/Compression Ratio
M = length(pic(:,1)); N = length(pic(1,:)); %   Row by Col
SNR = zeros(length(DivBy), 2);
figure(9)
imshow(picgrey)
title('Original')
%% Compression Loop
for k = 1:length(DivBy)
% Reshaping File
% N = fix(N/DivBy(k))*DivBy(k); % How many rows/cols to keep
% % pic = double(picgrey(1:N_fix,1:N_fix));
% Initializing    
np = 64;
delta = 7;      % The Jump
L = (N*N)/(8^2); % Number of sections
l = 0;
% Matrix initializing
matrix = zeros(8,8,L); 
CompPic = zeros(8,8,L);
CompPic2 = zeros(N,N);
%% PCA Compression
for i = 1:8:(N-delta)
    for j = 1:8:(N-delta)
    l = l+1;
    matrix(:,:,l) = pic(i:i+delta,j:j+delta); 
    end
end
z = reshape(matrix, [np l]);
Avg = mean(z,2);
Z = z-Avg;
Covar = (Z*Z')/np ;
[V, D] = eig(Covar);
y = V(:,(length(V(1,:))-DivBy(k)+1):end)'*Z;
%% PCA Reconstruction
new = V(:,(length(V(1,:))-DivBy(k)+1):end)*y+Avg;
j = 0;
for j = 1:length(new(1,:))
   CompPic(:,:,j) = reshape(new(:,j), [8 8]);
end
l = 0;
for i = 1:8:(N-delta)
   for j = 1:8:(N-delta)
    l = l+1;
    CompPic2(i:i+delta,j:j+delta) = CompPic(:,:,l);
    end
end
%% PCA SNR
error = CompPic2 - pic;
fhat = 0;
f = 0;

for i = 1:length(pic(:,1))
    for j = 1:length(pic(1,:))
        fhat = fhat + CompPic2(i,j)^2;
        f = f + error(i,j)^2;
    end
end
SNR(k,1) = fhat/f;

figure(k)
imshow(uint8(CompPic2),[])
title(sprintf('Reconstructed %d:1',DivBy(k)))

%% DCT
% Compress
DCTPic = dct2(picgrey,N,N);
% Removing Negatives
DCTPic(abs(DCTPic) < 10) = 0;
% Reconstruct
DCTPic2 = idct2(DCTPic,fix(N/DivBy(k)),fix(N/DivBy(k)));
DCTPic2 = rescale(DCTPic2);
figure(k+4)
imshow(DCTPic2, [])
title(sprintf('Reconstructed DCT of %1.0f:1', DivBy(k)))
%% DCT SNR
Temp = zeros(256,256);
Temp(1:length(DCTPic2(:,1)),1:length(DCTPic2(1,:))) = DCTPic2;
error = Temp - pic;
fhat = 0;
f = 0;

for i = 1:length(pic(:,1))
    for j = 1:length(pic(1,:))
        fhat = fhat + Temp(i,j)^2;
        f = f + error(i,j)^2;
    end
end
SNR(k,2) = fhat/f;




end


