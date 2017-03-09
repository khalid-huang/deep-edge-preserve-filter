function output = wls_run(input_path)
  input = imread(input_path);
  %input = double(rgb2gray(input));
  input = input./max(input(:));
  output = wlsFilter(input, 0.5);
  imshow(output);
end
