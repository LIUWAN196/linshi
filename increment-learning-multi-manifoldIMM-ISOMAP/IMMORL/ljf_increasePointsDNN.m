function [sX,newAllNeighbor,newDE,newDG,newP] =ljf_increasePointsDNN(X1,XX,newDG,newDE,newP,sX,newAllNeighbor,D1,DE);
    %step 1: ���������µ�������һ�������λ����Գ�һ��������
   %�����Ƚ��µ�Ľ�����ÿһ����������һ���ֺõ�������  
    for i=size(XX,2)+1:size(XX,2)+size(X1,2)
         allold=cell2mat(sX);  
         allold=unique(allold);
         if(length(  intersect(newAllNeighbor{i},  allold) )>0)   %�µ�Ľ�����ɵ��н�������������������һ��������
                for j=1:length(sX)
                     lable=0;%��Ǹõ�������һ�������λ��Ƕ��������Ļ��ں�������
                     if(length(intersect(newAllNeighbor{i},sX{j}))>0)
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
 ii=length(cjj);
while(ii>=1)
  sX(cjj(ii))=[];
ii=ii-1;
end;
 disp('���������ĵ��Ѿ�ȫ�����������������Ϣ������sX{}�У������������򻮷ֵ������Σ������ڵĳ�Ϊ�µ������Σ��ཻ�������ν����ں�');        
%step 2: ����DE��newAllNeighbor
 oldOrder = 1:size(XX,2);    jList = size(XX,2)+size(X1,2);    
    for i=size(XX,2)+1:size(XX,2)+size(X1,2)
        dd=newAllNeighbor{i};
        ddd=setdiff(oldOrder,dd);
        for j=1:length(ddd)
            newDE(ddd(j),i) = Inf; 
            
        end;
    end;
  %{
    %step 3  �������·�Լ�·����ͻ����%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ws�µ�ȫ�����DE��Ϣ�淶��ws1�ɵĵ��DE
    Dset = min(newDE,newDE');  Ws = Dset;    Ws(find(Ws==Inf)) = 0;    Ws = sparse(Ws);    Ws = Ws';
    Dset = min(DE,DE');  Ws1 = Dset;    Ws1(find(Ws1==Inf)) = 0;    Ws1 = sparse(Ws1);    Ws1 = Ws1';
    oldDE = min(oldDE,newDE');
    %�˴��ǽ�newDG��newP�����ӵĲ��ֵľ�����£�
    %�Ƚ�AB�����Ƿ�һ����c=A-B;[x,y]=find(c~=0);x,yΪ����һ���ĵط����У�������
    [newDG,newP] = computeOneDG(size(XX,2)+1:size(XX,2)+size(X1,2),Ws,newDG,newP);
    shortEs = judgeShortCs(size(XX,2)+1:size(XX,2)+size(X1,2),Ws1,Ws,newDG,newP);
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
    %}
