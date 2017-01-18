Im = imread('pflower.jpg');
S = L0Smoothing(Im,0.01);
%f = fspecial('gaussian',[9,9],10);
%img_smooth = imfilter(Im, f, 'same');
figure, imshow(S);
%figure, imshow(img_smooth);
