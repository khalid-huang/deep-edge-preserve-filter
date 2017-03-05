


%%% test the model performance


% clear; clc;
format compact;

addpath(fullfile('data','utilities'));
folderTest  = fullfile('data','Test'); %%% test dataset

showResult  = 1;
useGPU      = 1;
pauseTime   = 3;

modelName   = 'model_L0_Res_Bnorm_Adam';
%epoch       = 1;
epoch        = 3;

%%% load Gaussian denoising model
load(fullfile('data',modelName,[modelName,'-epoch-',num2str(epoch),'.mat']));
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
    %if size(image,3) == 3
    %    input = rgb2gray(input);
    %    label = rgb2gray(label);
    %end
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




