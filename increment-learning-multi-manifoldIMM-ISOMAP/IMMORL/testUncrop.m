clear;
load MM2.mat;
open MM2.mat;
MM=double(MM);
%�õ�M�󣬽�ÿ�������ĺ�����ͼƬ��Ϊ����newM����ԭ����M��ɾȥ��ͼƬ
%  list=[7 8 9 17 18 19 27 28 29 37 38 39 47 48 49 57 58 59];
% newM=MM(:,:,list);
%  MM(:,:,list)=[]; 
% ���µõ��µ�X
a = size(MM,1);b = size(MM,2);n = size(MM,3);X = reshape(MM, a*b, n);
% aa = size(newM,1);bb = size(newM,2);nn = size(newM,3);XX = reshape(newM, aa*bb, nn);
% X=[X XX];

d=3;
r=0.5;maxAngle = 20;
k=20;
 n = 60;t = 0;times =1;
% n = 60;t = 22;times =1;
m = n+times*t;
XX = X(:,1:n);X1 = X(:,n+1:m);
tic;
[y,y1,sX,sY,allNeighbor,DE,DG,P] = multiManifold_ISOMAP_start(XX,1:size(XX,2),XX,d,r,maxAngle);
   toc;
for ggg = 1:times
    [y,y1,sX,sY,allNeighbor,DE,DG,P] = multiManifold_ISOMAP_1(XX,d,r,maxAngle,X1,sX,sY,allNeighbor,DE,DG,P);
toc;
end;
figure('color','w');
scatter3(y(1,sX{1}),y(2,sX{1}),y(3,sX{1}),50,'r+');hold on;
scatter3(y(1,sX{2}),y(2,sX{2}),y(3,sX{2}),50,'g>');hold on;
scatter3(y(1,sX{3}),y(2,sX{3}),y(3,sX{3}),50,'b<');hold on;
scatter3(y(1,sX{4}),y(2,sX{4}),y(3,sX{4}),50,'b+');hold on;
scatter3(y(1,sX{5}),y(2,sX{5}),y(3,sX{5}),50,'m*');hold on;
scatter3(y(1,sX{6}),y(2,sX{6}),y(3,sX{6}),50,'c.');hold on;
scatter3(y(1,sX{7}),y(2,sX{7}),y(3,sX{7}),50,'y^');hold on;
scatter3(y(1,sX{8}),y(2,sX{8}),y(3,sX{8}),50,'ko');hold on;
title(' IMM-ISOMAP(�� =20/��=0.5)','fontsize',14);
 