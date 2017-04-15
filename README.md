# 目录说明
```
data                       ：训练原始数据
  | -- BSDS500             : BSDS500数据集
  | -- test_paper          : 补充数据集

methods                    ：几种边缘保持滤波的matlab代码
  | -- Bilateral_Filter    : 双边滤波
  | -- L0                  : L0平滑滤波
  | -- wls                 : 基于最小二乘的边缘保持滤波
  | -- origin              : 原始图片
  | -- result              : 几种滤波图片的效果

TrainingCodes              : 网络的训练代码
  | -- data                : 各种训练模型的存储位置和图片的存储位置
  | -- Demo_Test_model_L0_Res_Bnorm_Adam_time_get       :用于获取运行时间等信息的模型运行代码
  | -- Demo_Train_model_L0_Res_Bnorm_Adam.m             :训练模型
  | -- Demo_Test_model_L0_Res_Bnorm_Adam.m              :测试模型
  | -- DnCNN_init_model_L0_Res_Bnorm_Adam.m             :模型初始化
  | -- DnCNN_train.m                                    :模型训练的核心代码
```

# 程序运行
> 如下的操作都是在/TrainingCodes/deepepf_L0_Res_Bnorm_Adam目录下,环境都是matlab;

## 环境要求
+ matlab
+ 安装MatConvNet 参考：http://www.vlfeat.org/matconvnet/
+ 需要MatConvNet支持GPU模式
## 训练模型matlab命令
```
Demo_Train_model_L0_Res_Bnorm_Adam('color') //对color图片进行模型训练
Demo_Test_model_L0_Res_Bnorm_Adam('color') //对彩色模型进行测试
```
