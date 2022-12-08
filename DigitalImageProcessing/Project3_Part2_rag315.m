%% ECE 8473 Digital Image Processing: Project 3, Part 2
% By Rebecca Garcia
% Dated: October 20th, 2022
clc; clear all; close all
%% Part 2
load('moffett.mat');
L = length(z3(1,1,:));
N = length(z3(:,1,1))*length(z3(1,:,1));
z = reshape(z3, [N L])';
Avg = mean(z,2);
Z = z-Avg;
Covar = (Z*Z')/N ;

[V, D] = eig(Covar);
[D] = maxk(D,1);
[D3, I] = maxk(D,3);

v = V(:,I);
y1 = v(:,1)'*Z;
y2 = v(:,2)'*Z;
y3 = v(:,3)'*Z;

pca1 = reshape(y1, [256 256]);
pca2 = reshape(y2, [256 256]);
pca3 = reshape(y3, [256 256]);

PCA = cat(3, pca1, pca2, pca3);
PCA = uint8(PCA);

figure(2)
imshow(PCA)

figure(3)
subplot(1,3,1)
imshow((pca1),[])
title('PCA 1')
subplot(1,3,2)
imshow((pca2),[])
title('PCA 2')
subplot(1,3,3)
imshow((pca3),[])
title('PCA 3')