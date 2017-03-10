function OUT = wlsFilter(IN, lambda, alpha, L)
%WLSFILTER Edge-preserving smoothing based on the weighted least squares(WLS) 
%   optimization framework, as described in Farbman, Fattal, Lischinski, and
%   Szeliski, "Edge-Preserving Decompositions for Multi-Scale Tone and Detail
%   Manipulation", ACM Transactions on Graphics, 27(3), August 2008.
%
%   Given an input image IN, we seek a new image OUT, which, on the one hand,
%   is as close as possible to IN, and, at the same time, is as smooth as
%   possible everywhere, except across significant gradients in L.
%
%
%   Input arguments:
%   ----------------
%     IN              Input image (2-D, double, N-by-M matrix). 
%       
%     lambda          Balances between the data term and the smoothness
%                     term. Increasing lambda will produce smoother images.
%                     Default value is 1.0
%                     最小二乘正则化参数，增加它的值可以产生更加平滑的图像
%       
%     alpha           Gives a degree of control over the affinities by non-
%                     lineary scaling the gradients. Increasing alpha will
%                     result in sharper preserved edges. Default value: 1.2
%                     增加该值会产生更为锐化的边缘      
% 
%     L               Source image for the affinity matrix. Same dimensions
%                     as the input image IN. Default: log(IN)
%                     源图像的关联矩阵，对图像的对数变换可以压缩图像像素值的动态范围
%
%   Example 
%   -------
%     RGB = imread('peppers.png'); 
%     I = double(rgb2gray(RGB));
%     I = I./max(I(:));
%     res = wlsFilter(I, 0.5);
%     figure, imshow(I), figure, imshow(res)
%     res = wlsFilter(I, 2, 2);
%     figure, imshow(res)

% 参数设置默认值
if(~exist('L', 'var')),
    L = log(IN+eps); % 构造输入图像的对数变换图像
%     figure,imshow(L./min(min(L))),title('LOG Image');
end

if(~exist('alpha', 'var')),
    alpha = 1.2; % alpha默认值
end

if(~exist('lambda', 'var')),
    lambda = 1; % lambda默认值
end

smallNum = 0.0001;  % 防止除数为0的小数

[r,c] = size(IN); % 输入图像的尺寸
k = r*c;

% Compute affinities between adjacent pixels based on gradients of L
% 基于关联图像L的梯度计算邻接像素之间的关联性
dy = diff(L, 1, 1);                         % 沿y方向的一阶前向差分
% dy = diff(IN, 1, 1);
dy = -lambda./(abs(dy).^alpha + smallNum);  % 参见公式6
dy = padarray(dy, [1 0], 'post');           % 在dy矩阵最后一行下面加一行0元素
dy = dy(:);                                 % 将r行c列矩阵变为r*c行1列向量

dx = diff(L, 1, 2);                         % 沿x方向的一阶前向差分
% dx = diff(IN, 1, 2);
dx = -lambda./(abs(dx).^alpha + smallNum);  % 参见公式6
dx = padarray(dx, [0 1], 'post');           % 在dx矩阵最后一列右边加一行0元素
dx = dx(:);                                 % 将r行c列矩阵变为r*c行1列向量

% Construct a five-point spatially inhomogeneous Laplacian matrix
% 构建五点空间不均匀的Laplacian矩阵
B(:,1) = dx;
B(:,2) = dy;
d = [-r,-1];   % r 表示输入图像的高
% spdiags函数很复杂的机制，这里的作用是将B的两列元素，
% 排在由 d 指定位置的k x k大小的稀疏矩阵对角线上
A = spdiags(B,d,k,k); 

e = dx;
w = padarray(dx, r, 'pre'); % 在dx上方增加r行0元素
w = w(1:end-r);             % 去除dx下方的0元素行
s = dy;
n = padarray(dy, 1, 'pre'); % 在dy上方增加1行0元素
n = n(1:end-1);             % 去除dy下方的1行0元素

% 这里构造对角矩阵 D 所需的对角线上的元素（除对角线上元素外，其他元素为0）
D = 1-(e+w+s+n);  

% 这里构造的A矩阵，见readme中的简单例子
A = A + A' + spdiags(D, 0, k, k);

% 求解最小二乘意义下的线性方程组
OUT = A\IN(:);
OUT = reshape(OUT, r, c);