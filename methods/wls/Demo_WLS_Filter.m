% ------------------------------------------------
% Weighted Least Square Filter
% Edge-preserving decompositions for multi-scale tone and detail_SG08
% ------------------------------------------------

clc; close all;
clear all;

% WLS�˲�����
lambda = 0.35;	% ��С�������򻯲����������ֵ���Բ�����ƽ����ͼ��
alpha = 1.8;	% ���Ӹ�ֵ������Ϊ�񻯵ı�Ե

% ��ȡͼ��
img = double(imread('pflower.jpg'))./255;
%img = rgb2gray(img);
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

%outname = [outputpath,filename,'_WLS.png'];
%imwrite(outimg, outname); % ���洦����

