%gen_rsl('wls', 'wls_run');
%gen_rsl('L0', 'L0Smoothing');
%gen_rsl('Bilateral_Filter', 'bfilter');
function [] = gen_rsl(filepath, filename)
  addpath(filepath);

  ori_ims_path = 'origin';
  rsl_ims_path = fullfile('result', filename);
  if isdir(rsl_ims_path) == 0
    mkdir(rsl_ims_path);
  end

  ext = {'*.jpg', '*.png', '*.bmp'};
  filePaths = [];
  for i = 1:length(ext)
    filePaths = cat(1, filePaths, dir(fullfile(ori_ims_path, ext{i})));
  end
  for i = 1:length(filePaths)
    disp(i);
    input_path = fullfile(ori_ims_path, filePaths(i).name);
    output = feval(fullfile(filename), input_path);
    imwrite(im2uint8(output), fullfile(rsl_ims_path,filePaths(i).name));
  end
end
