%%http://www.cnblogs.com/pursuit1996/p/4912189.html
%filepath is the path of the input image
% w为双边滤波器（核）的边长/2
% sigma定义域方差σd记为SIGMA(1),值域方差σr记为SIGMA(2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function B = bfilter(filepath,w,sigma)
  if nargin == 1
    w = 5;           % 双边滤波器半宽，w越大平滑作用越强
    sigma = [3 0.2]; % 空间距离方差σd记为SIGMA(1),像素亮度方差σr记为SIGMA(2),即空间邻近度因子和亮度相似度因子的衰减程度
  im = imread(filepath);
  im = double(im) / 255; % double and normalize
  w = ceil(w);

  %选择彩色模式或灰度模式
  if size(im, 3) == 1
     out = bfltGray(im,w,sigma(1),sigma(2));
  else
     out = bfltColor(im,w,sigma(1),sigma(2));
  end

  imshow(cat(2,im2uint8(im), im2uint8(out)));
end
