clear;
clc;
%    load XAll.mat;
%    open XAll.mat;
%   load newall.mat;
%    open newall.mat;
%    load matlab.mat;
%   open matlab.mat;

% ��������������XandXin; 

%#######ԭ������ȫ��ȡ����ֻȡss�ĵ���Ƿֿ������################

% XX;%swiss��ȡ1500����
% col1;%swiss��ȡ1500�����Ӧ��col
% XXX;%swiss��lȡʣ�µ�500����
%  col2;%swiss��ȡʣ�µ�500���Ӧ��col
% newcol=[col1' col2']';%
% 
% �޸���ɫ
%  col1(1:1500)=0.85;col2(1:500)=0.35;col=[col1' col2']';
%#######�Ȼ���Xԭ����������״��################
% figure;   
% hin=scatter3(X(1,:),X(2,:),X(3,:),50,col,'filled');  
% set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]);
% hold off;


swiss2000; T = X;
XAll = X(:,ss);
col = col(ss);

%###############���ö����ε��㷨�������������δ����ά��ͼ��##############
tic;
d=2;
r=0.6;
maxAngle = 20;

n = 700;t = 200;times = 3;
m = n+times*t;
XX = XAll(:,1:n);
X1 = XAll(:,n+1:m);
col1 = col(1:n);col11=col(n+1:m);

    %������ʼ��1500�������άͼ
     figure;   
    hin=scatter3(XX(1,:),XX(2,:),XX(3,:),50,col1,'filled');  
     set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]);
    hold off;

   
    [y] = multiManifold_ISOMAP(XX,col1,d,r,maxAngle,X1,col11);
    

%{
figure; 
  hold on;        
    hin=scatter(y1(1,:),y1(2,:),50, col,'filled'); 
    set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]); 
  hold off;
  
 %}
disp('');
runtime=toc;
disp('runtime='+runtime);
