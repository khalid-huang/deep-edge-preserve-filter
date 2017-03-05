%%% gauss filter
function [] = gaussFileter(filepath, sigma)
  if nargin == 1
    sigma = 1;
  end

  I = imread(filepath);
  output = I.*0;
  window = double(uint8(3*sigma)*2+1); %the window size
  H = fspecial('gaussian', window, sigma);

  for c = 1:size(I, 3)
    output(:,:,c) = imfilter(I(:,:,c), H, 'replicate');
  end

  %%showResult
  imshow(cat(2, im2uint8(I),im2uint8(output)));
  drawnow;
end
