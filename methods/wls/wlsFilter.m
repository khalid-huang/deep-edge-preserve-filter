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
%                     ��С�������򻯲�������������ֵ���Բ�������ƽ����ͼ��
%       
%     alpha           Gives a degree of control over the affinities by non-
%                     lineary scaling the gradients. Increasing alpha will
%                     result in sharper preserved edges. Default value: 1.2
%                     ���Ӹ�ֵ�������Ϊ�񻯵ı�Ե      
% 
%     L               Source image for the affinity matrix. Same dimensions
%                     as the input image IN. Default: log(IN)
%                     Դͼ��Ĺ������󣬶�ͼ��Ķ����任����ѹ��ͼ������ֵ�Ķ�̬��Χ
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

% ��������Ĭ��ֵ
if(~exist('L', 'var')),
    L = log(IN+eps); % ��������ͼ��Ķ����任ͼ��
%     figure,imshow(L./min(min(L))),title('LOG Image');
end

if(~exist('alpha', 'var')),
    alpha = 1.2; % alphaĬ��ֵ
end

if(~exist('lambda', 'var')),
    lambda = 1; % lambdaĬ��ֵ
end

smallNum = 0.0001;  % ��ֹ����Ϊ0��С��

[r,c] = size(IN); % ����ͼ��ĳߴ�
k = r*c;

% Compute affinities between adjacent pixels based on gradients of L
% ���ڹ���ͼ��L���ݶȼ����ڽ�����֮��Ĺ�����
dy = diff(L, 1, 1);                         % ��y�����һ��ǰ����
% dy = diff(IN, 1, 1);
dy = -lambda./(abs(dy).^alpha + smallNum);  % �μ���ʽ6
dy = padarray(dy, [1 0], 'post');           % ��dy�������һ�������һ��0Ԫ��
dy = dy(:);                                 % ��r��c�о����Ϊr*c��1������

dx = diff(L, 1, 2);                         % ��x�����һ��ǰ����
% dx = diff(IN, 1, 2);
dx = -lambda./(abs(dx).^alpha + smallNum);  % �μ���ʽ6
dx = padarray(dx, [0 1], 'post');           % ��dx�������һ���ұ߼�һ��0Ԫ��
dx = dx(:);                                 % ��r��c�о����Ϊr*c��1������

% Construct a five-point spatially inhomogeneous Laplacian matrix
% �������ռ䲻���ȵ�Laplacian����
B(:,1) = dx;
B(:,2) = dy;
d = [-r,-1];   % r ��ʾ����ͼ��ĸ�
% spdiags�����ܸ��ӵĻ��ƣ�����������ǽ�B������Ԫ�أ�
% ������ d ָ��λ�õ�k x k��С��ϡ�����Խ�����
A = spdiags(B,d,k,k); 

e = dx;
w = padarray(dx, r, 'pre'); % ��dx�Ϸ�����r��0Ԫ��
w = w(1:end-r);             % ȥ��dx�·���0Ԫ����
s = dy;
n = padarray(dy, 1, 'pre'); % ��dy�Ϸ�����1��0Ԫ��
n = n(1:end-1);             % ȥ��dy�·���1��0Ԫ��

% ���ﹹ��ԽǾ��� D ����ĶԽ����ϵ�Ԫ�أ����Խ�����Ԫ���⣬����Ԫ��Ϊ0��
D = 1-(e+w+s+n);  

% ���ﹹ���A���󣬼�readme�еļ�����
A = A + A' + spdiags(D, 0, k, k);

% �����С���������µ����Է�����
OUT = A\IN(:);
OUT = reshape(OUT, r, c);