% ------------------------------------------------
% Weighted Least Square Filter
% Edge-preserving decompositions for multi-scale tone and detail_SG08
% ------------------------------------------------

clc; close all;
clear all;

lambda = 0.35;
alpha = 1.8;

img = double(imread('pflower.jpg'))./255;
%img = rgb2gray(img);

%figure, imshow(img),title('Input');

[h, w, c] = size(img);

if c == 1

    outimg = wlsFilter(img, lambda, alpha);

else

    outimg = img;

    outimg(:,:,1) = wlsFilter(img(:,:,1), lambda, alpha);
    outimg(:,:,2) = wlsFilter(img(:,:,2), lambda, alpha);
    outimg(:,:,3) = wlsFilter(img(:,:,3), lambda, alpha);

end

%figure, imshow(outimg),title('Output');
% figure, imshow(outimg),colormap(Jet),title('Result Colorization');

%outname = [outputpath,filename,'_WLS.png'];
%imwrite(outimg, outname)
