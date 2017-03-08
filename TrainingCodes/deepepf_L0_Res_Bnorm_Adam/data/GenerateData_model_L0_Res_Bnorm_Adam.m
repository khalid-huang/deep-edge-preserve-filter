function [] = GenerateData_model_L0_Res_Bnorm_Adam(color_model, batchSize)
%%% Generate the training data.

%clear;close all;

addpath(genpath('./.'));
%addpath utilities;

%batchSize      = 128;        %%% batch size
batchSize
max_numPatches = batchSize*2000;

%%model_shape is to use for the dir
if strcmp(color_model, 'gray')
  model_dir_shape = 'model_L0_Gray_Res_Bnorm_Adam';
else
  model_dir_shape = 'model_L0_Res_Bnorm_Adam';
end

modelDir    =  fullfile('data', model_dir_shape);

%%% training and testing
folder_train  = 'data/Train';  %%% training
folder_test   = 'data/Test';%%% testing
size_input    = 40;          %%% training
size_label    = 40;          %%% testing
%size_input    = 60;
%size_label    = 60;

stride_train  = 60;          %%% training
stride_test   = 80;          %%% testing
val_train     = 0;           %%% training % default
val_test      = 1;           %%% testing  % default

%%% training patches
[inputs, labels, set]  = patches_generation(color_model, size_input,size_label,stride_train,folder_train,val_train,max_numPatches,batchSize);
%%% testing  patches
[inputs2,labels2,set2] = patches_generation(color_model,size_input,size_label,stride_test,folder_test,val_test,max_numPatches,batchSize);

inputs   = cat(4,inputs,inputs2);      clear inputs2;
labels   = cat(4,labels,labels2);      clear labels2;
set      = cat(2,set,set2);            clear set2;

if ~exist(modelDir,'file')
    mkdir(modelDir);
end

%%% save data
disp('----------------deal data done---------')
disp('------------saving data----------')
save(fullfile(modelDir,'imdb'), 'inputs','labels','set','-v7.3')
disp('------------save data done------------')
