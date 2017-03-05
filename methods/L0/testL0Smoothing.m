Im = imread('pflower.jpg');
S = L0Smoothing(Im,0.02);
%f = fspecial('gaussian',[9,9],10);
%img_smooth = imfilter(Im, f, 'same');
figure, imshow(cat(2, Im, im2uint8(S)));
%figure, imshow(img_smooth);
