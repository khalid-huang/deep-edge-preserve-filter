function [] = Demo_Train_model_L0_Res_Bnorm_Adam(color_model)

%path addpath
addpath('./data','./data/utilities');

%%color_model: 'color' or 'gray'
if nargin == 0
  color_model = 'gray';
end

%%model_shape is to use for the dir
if strcmp(color_model, 'gray')
  model_dir_shape = 'model_L0_Gray_Res_Bnorm_Adam';
else
  model_dir_shape = 'model_L0_Res_Bnorm_Adam';
end
%% generate data to train and val

modelDir = strcat('./data/', model_dir_shape);
if exist(fullfile(modelDir, 'imdb.mat'), 'file') == 0
  GenerateData_model_L0_Res_Bnorm_Adam(color_model)
end
%%% training data first.

%%%-------------------------------------------------------------------------
%%% configuration
%%%-------------------------------------------------------------------------
opts.modelName        = model_dir_shape; %%% model name
%opts.learningRate    = [logspace(-3,-3,30) logspace(-4,-4,20)];%%% you can change the learning rate
opts.learningRate     = [logspace(-3,-3,20) logspace(0,-3,10)];
%opts.learningRate = [logspace(-3,-3,2)];
opts.batchSize        = 128; %%% default
opts.gpus             = [1]; %%% this code can only support one GPU!

%%% solver
opts.solver           = 'Adam';
%%opts.solver           = 'SGD';

opts.gradientClipping = false; %%% Set 'true' to prevent exploding gradients in the beginning.
opts.expDir      = fullfile('data', opts.modelName);
opts.imdbPath    = fullfile(opts.expDir, 'imdb.mat');

%%%-------------------------------------------------------------------------
%%%   Initialize model and load data
%%%-------------------------------------------------------------------------
%%%  model
disp('init net');
opts.init_net_name = 'model_L0_Res_Bnorm_Adam';
net  = feval(['DnCNN_init_',opts.init_net_name], color_model);
disp('init net done');

%%%  load data
disp('loading data');
imdb = load(opts.imdbPath) ;
disp('loading data done');
%%%-------------------------------------------------------------------------
%%%   Train
%%%-------------------------------------------------------------------------

[net, info] = DnCNN_train(net, imdb, ...
    'expDir', opts.expDir, ...
    'learningRate',opts.learningRate, ...
    'solver',opts.solver, ...
    'gradientClipping',opts.gradientClipping, ...
    'batchSize', opts.batchSize, ...
    'modelname', opts.modelName, ...
    'gpus',opts.gpus) ;
