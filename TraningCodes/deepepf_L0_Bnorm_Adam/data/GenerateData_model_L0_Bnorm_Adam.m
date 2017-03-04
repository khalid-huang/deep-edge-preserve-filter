function [] = GenerateData_model_L0_Res_Bnorm_Adam(color_model)
%%% Generate the training data.

%clear;close all;

%addpath(genpath('./.'));
%addpath utilities;

batchSize      = 128;        %%% batch size
max_numPatches = batchSize*2000;
modelName      = 'model_L0_Res_Bnorm_Adam';

%%% training and testing
folder_train  = 'Train';  %%% training
folder_test   = 'Test';%%% testing
size_input    = 40;          %%% training
size_label    = 40;          %%% testing
stride_train  = 40;          %%% training
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

if ~exist(modelName,'file')
    mkdir(modelName);
end

%%% save data
disp('----------------deal data done---------')
disp('------------saving data----------')
save(fullfile(modelName,'imdb'), 'inputs','labels','set','-v7.3')
disp('------------save data daon------------')
