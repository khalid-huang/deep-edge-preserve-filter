% ------------------------------------------------
% Weighted Least Square Filter
% Edge-preserving decompositions for multi-scale tone and detail_SG08
% ------------------------------------------------

clc; close all;
clear all;

% 文件路径
filepath = '..\..\Input\';

% 输出路径
outputpath = '..\..\Output\WLS-res\';

% 文件名称
filename = '03_16';
fmt = '.jpg';

% WLS滤波参数
lambda = 0.35;	% 最小二乘正则化参数，增加它的值可以产生更加平滑的图像
alpha = 1.8;	% 增加该值会产生更为锐化的边缘

% 读取图像
img = double(imread([filepath, filename, fmt]))./255;
img = rgb2gray(img);
% 显示输入图像
figure, imshow(img),title('Input');

% w为图像宽度，h为图像高度，c为颜色通道
[h, w, c] = size(img);

%% 图像处理
% 判断是彩色图像还是灰度图像
if c == 1 % 灰度图像
  
    % 加权最小二乘处理
    outimg = wlsFilter(img, lambda, alpha); 

else  % 彩色图像
    
    % 输出图像空间
    outimg = img;
    
    % 使用加权最小二乘滤波进行处理
    outimg(:,:,1) = wlsFilter(img(:,:,1), lambda, alpha);
    outimg(:,:,2) = wlsFilter(img(:,:,2), lambda, alpha);
    outimg(:,:,3) = wlsFilter(img(:,:,3), lambda, alpha);
    
end

figure, imshow(outimg),title('Output');
% figure, imshow(outimg),colormap(Jet),title('Result Colorization');

outname = [outputpath,filename,'_WLS.png'];
%imwrite(outimg, outname); % 保存处理结果

