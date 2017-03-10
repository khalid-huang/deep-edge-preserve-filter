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


% 绘制1D曲线 
sign1D = 155; 
left = 130; right = 300;w1 = right-left+1;
if c == 1 % 只有输入图像为灰度图时，才进行绘制一维信号

    % 建立采样点横坐标
    x_ax = linspace(1, w1, w1);
    
    % 绘制原图和核描述算子的一维对比曲线
    fig1 = figure;
    PlotImg1 = img(sign1D,left:right);
    plot(x_ax, PlotImg1,'-','Color',[0.4,0.4,0.4],'LineWidth',2),xlim([0,w1]);
       
    hold on;
    PlotStruct = outimg(sign1D,left:right);
    plot(x_ax, PlotStruct,'-','color','c','LineWidth',2),xlim([0,w1]);
    hold off;
    Fig1Name = [outputpath 'KerFilter'];

    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'position',[0 0 1 1]);
end
figure, close;
