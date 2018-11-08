function [sX,newallNeighbor,updateDE,newDG,newP,newDE,newX] =ljf_increasePointsDNN(newPoints,XX,DG,DE,P,sX,allNeighbor,ggg);
    %step 1: ���������µ�������һ�������λ����Գ�һ��������
d=2;
r=0.6;
maxAngle = 20;
    newX = [XX newPoints];
        number = size(XX,2);   
    
    addN = size(newPoints,2);
    
   newDE =ones(number+addN,number+addN)*Inf;
    
    newDE = L2_distance(newX,newX,1);
   %��DNN���������ĵ�Ľ��ڵ�
    gg={};
    for i=number+1:number+addN
       [newneighbor,newUd1,newnSame] = getDNNofOnePoint(i,newX,newDE(:,i),d,r,maxAngle);   
       newallNeighbor{i} = newneighbor;    
       newtangent{i} = newUd1;    
    end;
   %�����Ƚ��µ�Ľ�����ÿһ����������һ���ֺõ�������  
    for i=number+1:number+addN
         allold=cell2mat(sX);  
         allold=unique(allold);
         if(length(  intersect(newallNeighbor{i},  allold) )>0)   %�µ�Ľ�����ɵ��н�������������������һ��������
                for j=1:length(sX)
                     lable=0;%��Ǹõ�������һ�������λ��Ƕ��������Ļ��ں�������
                     if(length(intersect(newallNeighbor{i},sX{j}))>0)
                        sX{j}=union(sX{j},i);  %�ظ����ֵĵ�Ͳ���ӽ�ȥ

                        cj=[j];%���������һ��������,���������һ�������Σ���ô������������ںϵ�ԭ���������ε��У����Һ�������������ÿ�
                        lable=lable+1;
                        if(lable>1)
                            sX{cj}=[sX{cj} sX{j}];
                            sX(j)=[];
                        end;
                     end;          
           end;   
         else    sX{length(sX)+1}=[i];%����µ������ɵ�û��������ô��Ϊһ����������
         end;  
 
    end;    
    
    %�Ƚ���������û�н������еĻ��ں�

    cjj=[];
      for 	p=1:(length(sX)-1)
          for q=p+1:length(sX)
                if(length(intersect(sX{p},sX{q}))>0)
                    sX{p}=union(sX{p} ,sX{q});
                   cjj=union(cjj ,q);
                end;
          end;     
      end;
%��¼���ںϵ������Σ����ҽ�֮�ÿ�
%        for ii=1:length(cjj)
%              sX(cjj(ii))=[];
%           % sX{cjj(ii)}=[];
%           end;
 ii=length(cjj);
while(ii>=1)
  sX(cjj(ii))=[];
ii=ii-1;
end;
 disp('���������ĵ��Ѿ�ȫ�����������������Ϣ������sX{}�У������������򻮷ֵ������Σ������ڵĳ�Ϊ�µ������Σ��ཻ�������ν����ں�');
 
 %  XX=X(:,1:700);
%{
 %%%������õ���������ʾ��������
X1=newX(:,sX{1});X2=newX(:,sX{2}); X3=newX(:,sX{3}); X4=newX(:,sX{4}); X5=newX(:,sX{5}); X6=newX(:,sX{6}); X7=newX(:,sX{7});
figure;
hin=scatter3(X1(1,:),X1(2,:),X1(3,:),50,'filled');
set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]); hold on; hin=scatter3(X2(1,:),X2(2,:),X2(3,:),50,'filled');
set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]); hold on; hin=scatter3(X3(1,:),X3(2,:),X3(3,:),50,'filled');
set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]); hold on; hin=scatter3(X4(1,:),X4(2,:),X4(3,:),50,'filled');
set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]); hold on; hin=scatter3(X5(1,:),X5(2,:),X5(3,:),50,'filled');
set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]); hold on; hin=scatter3(X6(1,:),X6(2,:),X6(3,:),50,'filled');
set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]); hold on; hin=scatter3(X7(1,:),X7(2,:),X7(3,:),50,'filled');
set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]); hold on;
 %}
    disp('%%%%%%%%%%%%%%%');
    
    
%step 2: ����DE��newallNeighbor

    oldOrder = 1:number;    jList = number+1:number+addN;
    
%newDE�Ѿ�����
   
    oldDE = newDE;    oldDE(oldOrder,oldOrder) = DE;
   disp(' ���¸���DE')
    for i=number+1:number+addN
        dd=newallNeighbor{i};
        ddd=setdiff(oldOrder,dd);
        for j=1:length(ddd)
            oldDE(ddd(j),i) = Inf; 
        end;
    end;
    updateDE=oldDE;%�õ����յ�DE���Ժ��ؾ���dijistra�Ǹ�������������
    %����allneighbor,��ԭ���Ľ��ڹ�ϵallneighbor��ӵ��µ�newallNeighbor��
    for i=1:number
        if(ggg==1)
             newallNeighbor{i}=allNeighbor{i,1};
        else newallNeighbor{i}=allNeighbor{i};
        end;
       
    end;
    
    
    
    %step 3  �������·�Լ�·����ͻ����%%%%%%%%%%%%%%%%%%%%%%%%%%%
     newDG =ones(number+addN,number+addN)*Inf;    newDG(oldOrder,oldOrder) = DG;
    newP =zeros(number+addN,number+addN);    newP(oldOrder,oldOrder) = P;
    
    %ws�µ�ȫ�����DE��Ϣ�淶��ws1�ɵĵ��DE
    Dset = min(newDE,newDE');  Ws = Dset;    Ws(find(Ws==Inf)) = 0;    Ws = sparse(Ws);    Ws = Ws';
    Dset = min(DE,DE');  Ws1 = Dset;    Ws1(find(Ws1==Inf)) = 0;    Ws1 = sparse(Ws1);    Ws1 = Ws1';
    oldDE = min(oldDE,newDE');
    %�˴��ǽ�newDG��newP�����ӵĲ��ֵľ�����£�
    %�Ƚ�AB�����Ƿ�һ����c=A-B;[x,y]=find(c~=0);x,yΪ����һ���ĵط����У�������
    [newDG,newP] = computeOneDG(number+1:number+addN,Ws,newDG,newP);
    shortEs = judgeShortCs(number+1:number+addN,Ws1,Ws,newDG,newP);
    if(size(shortEs,1)>0)%û�л�·����
        tempS = shortEs; shortEs = [];
        while size(tempS,1)>0
            c1 = tempS(1,1); c2 = tempS(1,2);
            aa = find((tempS(:,1)==c2 & tempS(:,2)==c1) | (tempS(:,1)==c1 & tempS(:,2)==c2));
            if(~isempty(aa))   shortEs = [shortEs;tempS(aa(1),:)]; tempS(aa,:) = [];   end;
        end;
    end;
    
    allEdges = [];
    for i = 1:size(shortEs,1)
        oldDE(shortEs(i,2),shortEs(i,1))=Inf;   oldDE(shortEs(i,1),shortEs(i,2))=Inf; 
    end;
    
    Dset = min(oldDE,oldDE');  Ws2 = Dset;    Ws2(find(Ws2==Inf)) = 0;    Ws2 = sparse(Ws2);    Ws2 = Ws2';
    [newDG,newP] = computeOneDG(number+1:number+addN,Ws2,newDG,newP);
   %Ϊ����߾��ȣ���ʱ�Ȳ����ǣ�ע�͵�
 %   [newDG,newP] = updateNewOne(jList,Ws2,newDG,newP);
    
    for i = 1:size(shortEs,1)
        edges = findShortEdges(shortEs(i,1),shortEs(i,2),Ws,DG,P);   allEdges = [allEdges edges];
    end;  
    if(~isempty(allEdges))
       currJ = (allEdges(1,:)-1)*(number+addN)+allEdges(2,:);
       currJ1 = (allEdges(2,:)-1)*(number+addN)+allEdges(1,:);
       currJ = gunion(currJ,currJ1,1:(number+addN)^2);
       newP(currJ) = 0;   newDG(currJ) = Inf;
    end;
 
     
    tempDG = tril(newDG);
    [aaa,bbb] = find(tempDG(oldOrder,oldOrder)==Inf);
    aaa = gunique(aaa,oldOrder);  bbb = gunique(bbb,oldOrder);
    if(length(aaa)>length(bbb))       aaa = bbb;    end; 
    for a = 1:length(aaa)
       jFather = oldOrder(newDG(oldOrder,aaa(a))==Inf);        
       if(length(jFather) > 0)   [newDG,newP] = computePairDG(aaa(a),jFather,Ws2,newDG,newP);       end;
    end;
    
