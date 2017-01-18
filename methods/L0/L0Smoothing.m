%   Distribution code Version 1.0 -- 09/23/2011 by Jiaya Jia Copyright 2011, The Chinese University of Hong Kong.
%
%   The Code is created based on the method described in the following paper 
%   [1] "Image Smoothing via L0 Gradient Minimization", Li Xu, Cewu Lu, Yi Xu, Jiaya Jia, ACM Transactions on Graphics, 
%   (SIGGRAPH Asia 2011), 2011. 
%  
%   The code and the algorithm are for non-comercial use only.


function S = L0Smoothing(Im, lambda, kappa)
%L0Smooth - Image Smoothing via L0 Gradient Minimization
%   S = L0Smooth(Im, lambda, kappa) performs L0 graidient smoothing of input
%   image Im, with smoothness weight lambda and rate kappa.
%
%   Paras: 
%   @Im    : Input UINT8 image, both grayscale and color images are acceptable.
%   @lambda: Smoothing parameter controlling the degree of smooth. (See [1]) 
%            Typically it is within the range [1e-3, 1e-1], 2e-2 by default.
%   @kappa : Parameter that controls the rate. (See [1])
%            Small kappa results in more iteratioins and with sharper edges.   
%            We select kappa in (1, 2].    
%            kappa = 2 is suggested for natural images.  
%
%   Example
%   ==========
%   Im  = imread('pflower.jpg');
%   S  = L0Smooth(Im); % Default Parameters (lambda = 2e-2, kappa = 2)
%   figure, imshow(Im), figure, imshow(S);


if ~exist('kappa','var')
    kappa = 2.0;
end
if ~exist('lambda','var')
    lambda = 2e-2;
end
S = im2double(Im);
betamax = 1e5;
fx = [1, -1];
fy = [1; -1];
[N,M,D] = size(Im);
size(Im)
sizeI2D = [N,M];
otfFx = psf2otf(fx,sizeI2D); %计算偏导函数的fft2
otfFy = psf2otf(fy,sizeI2D);
Normin1 = fft2(S);
Denormin2 = abs(otfFx).^2 + abs(otfFy ).^2;
if D>1
    Denormin2 = repmat(Denormin2,[1,1,D]);
end
beta = 2*lambda;
while beta < betamax
    Denormin   = 1 + beta*Denormin2;
    % h-v subproblem
    h = [diff(S,1,2), S(:,1,:) - S(:,end,:)]; %diff(S,1,2)表示S对x（列）求一阶导数；S(:,1,:)表示对S取所有行(:),第一列，所有深度(:)；这一步S(:,1,:) - S(:,end,:)的操作是将最后一列的值 设置为第一行减去最后一行。
    v = [diff(S,1,1); S(1,:,:) - S(end,:,:)];
    if D==1
        t = (h.^2+v.^2)<lambda/beta;
    else
        t = sum((h.^2+v.^2),3)<lambda/beta;
        t = repmat(t,[1,1,D]);
    end
    h(t)=0; v(t)=0; %matlab的下标索引方式；这一步的操作是将符合条件的t的所有hp和vp的值都重新设置为0,而不满足的就是一开始的偏导值了。
    %经过上面的操作，已经将各个位置p的h和v都求出来了
    % S subproblem
    Normin2 = [h(:,end,:) - h(:, 1,:), -diff(h,1,2)]; %根据公式，先进行偏导，再进行fft2，也是可以的。对h进行x求导
    Normin2 = Normin2 + [v(end,:,:) - v(1, :,:); -diff(v,1,1)];%对v进行y求导，也就是行。
    FS = (Normin1 + beta*fft2(Normin2))./Denormin; %Normin1是对原图像的fft2; 
    S = real(ifft2(FS));
    beta = beta*kappa;
    fprintf('.');
end
fprintf('\n');
end
