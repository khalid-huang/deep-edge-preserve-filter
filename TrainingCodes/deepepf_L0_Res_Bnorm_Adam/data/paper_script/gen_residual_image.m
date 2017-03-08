input = imread('test_99.jpg');
%imshow(input);
label = L0Smoothing(input);
input = im2single(input);
label = im2single(label);
res = input - label;

imshow(cat(2, im2uint8(input), im2uint8(res)));
drawnow;
