%avrage filter
function [] = avgFilter(filepath,n)
  if nargin == 1
    n = 5;
  end

  im = imread(filepath);
  w = ones(n, n);  %window
  [height, width, channel] = size(im);
  in = double(im);
  out = zeros(height, width, channel);
  for c = 1:channel
    for i = 1:height-n+1
        for j = 1:width-n+1
            tmp = in(i:i+(n-1),j:j+(n-1),c).*w ; %get the window and then to mul to the window
            average = sum(sum(tmp)) / (n*n);           %get the window's average;
            out(i+(n-1)/2,j+(n-1)/2, c) = average; %set the value
        end
    end
  end
 
  out=uint8(out);
  imshow(cat(2,im2uint8(im),im2uint8(out)));
  drawnow;
end
