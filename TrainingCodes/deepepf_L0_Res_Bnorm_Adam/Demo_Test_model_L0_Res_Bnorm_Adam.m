%%% test the model performance
function [] = Demo_Test_model_L0_Res_Bnorm_Adam(color_model)


  % clear; clc;
  format compact;

  if nargin == 0
    color_model = 'gray';
  end

  addpath(fullfile('data','utilities'));
  folderTest  = fullfile('data','Test'); %%% test dataset

  showResult  = 1;
  useGPU      = 1;
  pauseTime   = 1;
  
  %%model_shape is to use for the dir
  if strcmp(color_model, 'gray')
    model_dir_shape = 'model_L0_Gray_Res_Bnorm_Adam';
  else
    model_dir_shape = 'model_L0_Res_Bnorm_Adam';
  end
  
  modelDir  = fullfile('data',model_dir_shape);
  modelName   = model_dir_shape;
  %epoch      = 1;
  epoch       = findLastEpoch(modelDir, modelName);

  %%% load Gaussian denoising model
  load(fullfile(modelDir,[modelName,'-epoch-',num2str(epoch),'.mat']));
  net = vl_simplenn_tidy(net);
  net.layers = net.layers(1:end-1);

  %%%
  net = vl_simplenn_tidy(net);

  % for i = 1:size(net.layers,2)
  %     net.layers{i}.precious = 1;
  % end

  %%% move to gpu
  if useGPU
      net = vl_simplenn_move(net, 'gpu') ;
  end

  %%% read images
  ext         =  {'*.jpg','*.png','*.bmp'};
  filePaths   =  [];
  for i = 1 : length(ext)
      filePaths = cat(1,filePaths, dir(fullfile(folderTest,ext{i})));
  end

  %%% PSNR and SSIM
  PSNRs = zeros(1,length(filePaths));
  SSIMs = zeros(1,length(filePaths));

  for i = 1:length(filePaths)

      %%% read images
      %image = imread(fullfile(folderTest,filePaths(i).name));

      input = imread(fullfile(folderTest, filePaths(i).name));
      label = L0Smoothing(imread(fullfile(folderTest,filePaths(i).name)));

      [~,nameCur,extCur] = fileparts(filePaths(i).name);
      label = im2double(label);
      input = im2single(input);
      if strcmp(color_model, 'gray') == 1 && size(input,3) == 3
          disp('gray')
          input = rgb2gray(input);
          label = rgb2gray(label);
      end
      %%% convert to GPU
      if useGPU
          input = gpuArray(input);
      end

      res    = vl_simplenn(net,input,[],[],'conserveMemory',true,'mode','test');
      output = input - res(end).x;

      %%% convert to CPU
      if useGPU
          output = gather(output);
          input  = gather(input);
      end

      %%% calculate PSNR and SSIM
      [PSNRCur, SSIMCur] = Cal_PSNRSSIM(im2uint8(label),im2uint8(output),0,0);
      if showResult
          imshow(cat(2,im2uint8(label),im2uint8(input),im2uint8(output)));
          title([filePaths(i).name,'    ',num2str(PSNRCur,'%2.2f'),'dB','    ',num2str(SSIMCur,'%2.4f')])
          %imshow(cat(2, im2uint8(input), im2uint8(output)))
          drawnow;
          pause(pauseTime)
      end
      PSNRs(i) = PSNRCur;
      SSIMs(i) = SSIMCur;
  end

  disp([mean(PSNRs),mean(SSIMs)]);
end

%% get the max epoch net
function epoch = findLastEpoch(modelDir, modelName)
  list = dir(fullfile(modelDir,[modelName, '-epoch-*.mat']));
  tokens = regexp({list.name}, [modelName, '-epoch-([\d]+).mat'], 'tokens');
  epoch = cellfun(@(x) sscanf(x{1}{1}, '%d'), tokens);
  epoch = max([epoch 0 ]);
end
