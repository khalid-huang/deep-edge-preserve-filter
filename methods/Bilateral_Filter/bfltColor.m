%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 对彩色图像进行双边滤波操作
function B = bfltColor(A,w,sigma_d,sigma_r)

  % 将sRGB转换为CIELab色彩空间
  if exist('applycform','file')
     A = applycform(A,makecform('srgb2lab'));
  else
     A = colorspace('Lab<-RGB',A);
  end

  % 计算空间距离因子权重
  [X,Y] = meshgrid(-w:w,-w:w);
  G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

  % 调整亮度因子权重
  sigma_r = 100*sigma_r;

  % 创建进度条
 % h = waitbar(0,'Applying bilateral filter...');
  %set(h,'Name','Bilateral Filter Progress');

  % 应用双边滤波
  dim = size(A);
  B = zeros(dim);
  for i = 1:dim(1)
     for j = 1:dim(2)
           % 边界限制
           iMin = max(i-w,1);
           iMax = min(i+w,dim(1));
           jMin = max(j-w,1);
           jMax = min(j+w,dim(2));
           I = A(iMin:iMax,jMin:jMax,:);

           % 计算亮度因子权重
           dL = I(:,:,1)-A(i,j,1);
           da = I(:,:,2)-A(i,j,2);
           db = I(:,:,3)-A(i,j,3);
           H = exp(-(dL.^2+da.^2+db.^2)/(2*sigma_r^2));

           % 计算双边滤波结果
           F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
           norm_F = sum(F(:));
           B(i,j,1) = sum(sum(F.*I(:,:,1)))/norm_F;
           B(i,j,2) = sum(sum(F.*I(:,:,2)))/norm_F;
           B(i,j,3) = sum(sum(F.*I(:,:,3)))/norm_F;

     end
     %waitbar(i/dim(1));
  end

  % 将图像转换为sRGB色彩空间.
  if exist('applycform','file')
     B = applycform(B,makecform('lab2srgb'));
  else
     B = colorspace('RGB<-Lab',B);
  end

  % 结束进度条
  %close(h);
end
