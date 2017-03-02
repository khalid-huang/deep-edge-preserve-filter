inputs  = zeros(size_input, size_input, 1, 1,'single');
labels  = zeros(size_label, size_label, 1, 1,'single');
stride = 40;

image = imread('test.jpg');

if size(image, 3) == 3
  image = rgb2gray(image); %uint8
end

for j = 1:8
    image_aug = data_augmentation(image, j);  % augment data
    im_label  = im2single(image_aug); % single
    [hei,wid] = size(im_label);
    im_input  = im_label; % single
    for x = 1 : stride : (hei-size_input+1)
        for y = 1 :stride : (wid-size_input+1)
            subim_input = im_input(x : x+size_input-1, y : y+size_input-1);
            subim_label = im_label(x+padding : x+padding+size_label-1, y+padding : y+padding+size_label-1);
            count       = count+1;
            inputs(:, :, 1, count)   = subim_input + single(sigma/255*randn(size(subim_input)));
            labels(:, :, 1, count) = subim_label;
        end
    end
end
