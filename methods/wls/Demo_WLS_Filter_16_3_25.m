% ------------------------------------------------
% Weighted Least Square Filter
% Edge-preserving decompositions for multi-scale tone and detail_SG08
% ------------------------------------------------

clc; close all;
clear all;

% �ļ�·��
filepath = '..\..\Input\';

% ���·��
outputpath = '..\..\Output\WLS-res\';

% �ļ�����
filename = '03_16';
fmt = '.jpg';

% WLS�˲�����
lambda = 0.35;	% ��С�������򻯲�������������ֵ���Բ�������ƽ����ͼ��
alpha = 1.8;	% ���Ӹ�ֵ�������Ϊ�񻯵ı�Ե

% ��ȡͼ��
img = double(imread([filepath, filename, fmt]))./255;
img = rgb2gray(img);
% ��ʾ����ͼ��
figure, imshow(img),title('Input');

% wΪͼ���ȣ�hΪͼ��߶ȣ�cΪ��ɫͨ��
[h, w, c] = size(img);

%% ͼ����
% �ж��ǲ�ɫͼ���ǻҶ�ͼ��
if c == 1 % �Ҷ�ͼ��
  
    % ��Ȩ��С���˴���
    outimg = wlsFilter(img, lambda, alpha); 

else  % ��ɫͼ��
    
    % ���ͼ��ռ�
    outimg = img;
    
    % ʹ�ü�Ȩ��С�����˲����д���
    outimg(:,:,1) = wlsFilter(img(:,:,1), lambda, alpha);
    outimg(:,:,2) = wlsFilter(img(:,:,2), lambda, alpha);
    outimg(:,:,3) = wlsFilter(img(:,:,3), lambda, alpha);
    
end

figure, imshow(outimg),title('Output');
% figure, imshow(outimg),colormap(Jet),title('Result Colorization');

outname = [outputpath,filename,'_WLS.png'];
%imwrite(outimg, outname); % ���洦����


% ����1D���� 
sign1D = 155; 
left = 130; right = 300;w1 = right-left+1;
if c == 1 % ֻ������ͼ��Ϊ�Ҷ�ͼʱ���Ž��л���һά�ź�

    % ���������������
    x_ax = linspace(1, w1, w1);
    
    % ����ԭͼ�ͺ��������ӵ�һά�Ա�����
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
