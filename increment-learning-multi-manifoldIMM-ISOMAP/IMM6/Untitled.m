 cjj=[];
      for 	p=1:(length(sX))
          for q=1:length(sX)
              if(p~=q)
                if(length(intersect(sX{p},sX{q}))>0)
                    sX{p}=union(sX{p} ,sX{q});
                   cjj=union(cjj ,q);
                end;
              end;
          end;     
      end;
      
      
    if(ggg==3)
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
   end;
   
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Ϊ�˵õ�Y1Y2Y6����άͼ����createData�ļ��У�������ݼ�Y1Y2Y6Y7Y4
    clear
Y1=bcY1(:,1:400);col1=bcol1(1:400);
 Y2=bcY2(:,1:400);col2=bcol2(1:400); Y6=Y6(:,1:200);col6=bcol6(1:200);
YY=[Y1 Y2 Y6];
col=[col1' col2']';
col=[col' col6']';
 figure;
 hin=scatter3(YY(1,:),YY(2,:),YY(3,:),50,col,'filled');  
 set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]);
   hold on;     
    %Ϊ�˵õ�Y1Y2Y7����άͼ
  Y7=Y7(:,1:200);col7=bcol7(1:200);
YY=[Y1 Y2 Y7];
col=[col1' col2']';
col=[col' col7']';
 figure;
 hin=scatter3(YY(1,:),YY(2,:),YY(3,:),50,col,'filled');  
 set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]);
   hold on;     
     %Ϊ�˵õ�Y1Y2Y4����άͼ
    Y4=Y4(:,1:200);col4=bcol4(1:200);
    YY=[Y1 Y2 Y4];
col=[col1' col2']';
col=[col' col4']';
 figure;
 hin=scatter3(YY(1,:),YY(2,:),YY(3,:),50,col,'filled');  
 set(hin,'MarkerEdgeColor',[0.5 0.5 0.5]);
   hold on;  