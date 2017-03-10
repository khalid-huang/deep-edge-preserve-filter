% ------------------------------------------------
% Weighted Least Square Filter
% Edge-preserving decompositions for multi-scale tone and detail_SG08
% ------------------------------------------------

% �ļ�·��
filepath = 'D:\MyFile\��һ\˶ʿ��ҵ&amp%3����\��ҵ����ģ��2014-Latex\Latex-Original\fig_library\ͼ4a-JPEGȥ��\';

% ���·��
outputpath = 'D:\MyFile\��һ\˶ʿ��ҵ&amp%3����\��ҵ����ģ��2014-Latex\Latex-Original\fig_library\ͼ4a-JPEGȥ��\';


% �ļ�����
filename = 'images_monkey_11per';
fmt = '.jpg';


% WLS�˲�����
% lambda = 0.35;	% ��С�������򻯲�������������ֵ���Բ�������ƽ����ͼ��
lambda = 0.5;
% alpha = 1.8;	% ���Ӹ�ֵ�������Ϊ�񻯵ı�Ե
alpha = 1.8;

% ��ȡͼ��
img = double(imread([filepath, filename, fmt]))./255;
% img = rgb2gray(img);
% ��ʾ����ͼ��
figure, imshow(img),title('Input');

% wΪͼ���ȣ�hΪͼ��߶ȣ�cΪ��ɫͨ��
[h, w, c] = size(img);

%% ͼ����
% �ж��ǲ�ɫͼ���ǻҶ�ͼ��
if c == 1 % �Ҷ�ͼ��
  
    % ��Ȩ��С���˴���
    outimg = wlsFilter(img, lambda, alpha); 

else  % ��ɫͼ��
    
    % ���ͼ��ռ�
    outimg = img;
    
    % ʹ�ü�Ȩ��С�����˲����д���
    outimg(:,:,1) = wlsFilter(img(:,:,1), lambda, alpha);
    outimg(:,:,2) = wlsFilter(img(:,:,2), lambda, alpha);
    outimg(:,:,3) = wlsFilter(img(:,:,3), lambda, alpha);
    
end

% figure, imshow(outimg),title('Output');
% figure, imshow(outimg),colormap(Jet),title('Result Colorization');
figure,imshow(outimg,'Border','tight');title('input')
% %%%%%%%%%������%%%%%%%%%%%%%%%%%%%%%%
% hold on
% x1 = 180; y1 = 330; w1= 100; h1 = 100;
% x2 = 265; y2 = 130;  w2= 100; h2 = 100;
% x3 = 230; y3 = 450; w3= 100; h3 = 100;
% rectangle('position',[x1 y1 w1 h1],'EdgeColor','r','lineWidth',3);
% rectangle('position',[x2 y2 w2 h2],'EdgeColor','b','lineWidth',3);
% rectangle('position',[x3 y3 w3 h3],'EdgeColor','g','lineWidth',3);
% hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% O1 = outimg(y1:y1+h1-1,x1:x1+w1-1,:); imwrite(O1,[outputpath,filename,'c_WLS1.png']); figure,imshow(O1)
% O2 = outimg(y2:y2+h2-1,x2:x2+w2-1,:); imwrite(O2,[outputpath,filename,'c_WLS2.png']); figure,imshow(O2)
% O3 = outimg(y3:y3+h3-1,x3:x3+w3-1,:); imwrite(O3,[outputpath,filename,'c_WLS3.png']); figure,imshow(O3)

outname = [outputpath,filename,'_WLS.png'];
imwrite(outimg, outname); % ���洦����
% I1 = outimg(407:507,204:344,:);
% I2 = outimg(103:203,403:543,:);
% imwrite(I1, 'I1.png');
% imwrite(I2, 'I2.png');
% imwrite(outimg,'output.png')


