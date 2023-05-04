function Huffman_CLQ_test(p,r )
%这个是霍夫曼编码的核心代码，分别调用了check，first_S，yasuo等三个函数，具体功能见各个函数
[pp,s]=yasuo_pp(p,r) ; %pp为对p排序后矩阵
c={};%c为最终编码存储的位置
[n,~]=size(pp);
%p压缩了n-1次，
for ii=1:r
    c=[c;num2str(ii-1)];
end

%这里有点问题，要求n不能少于3
for i=2:n-1
    k1=pp(n-i+2,:);
    k1(k1==0)=[];
    %去除这一行的0值
    k2=pp(n-i+1,:);
    k2(k2==0)=[];
    %去除上一行的0值

    Ln1=length(k1);
    %寻找下一行中那个元素是上一行两个元素相加得来的
    for hh=1:Ln1
        if k1(hh)==k2(hh)
            continue;
        else
            hh_diff=hh;
            %hh_diff表示的意思：矩阵pp中第n-i+2行第hh_diff个数字是由n-i+1行中的数字相加而来
            break;
        end
    end

    % 编码模块
    %c代表这一层的编码code，cc代表下一行的编码,cc_short代表短的编码（由非合并而来的符号的编码）
    % cc_long代表长的编码（由合并而来的符号的编码）
    if hh_diff==1
        cc_short=c(hh_diff+1:length(c));

        for j=0:r-1
            bb=strcat (  c(hh_diff) , num2str(j)     );
            cc=[cc_short;  bb  ];
        end
    else  %当hh不为1的时候
        cc_short=c(1:hh_diff-1);
        cc_short=[cc_short;c(hh_diff+1:length(c))];
        for j=0:r-1
            bb=strcat (  c(hh_diff) , num2str(j)     );
            cc=[cc_short;  bb  ];
        end
    end
    c=cc;
end


%第一次压缩s个，现在进行最后一步编码
k1=k2;
k2=pp(1,:);
for hh=1:length(k1)
    if k1(hh)==k2(hh)
        continue;
    else
        hh_diff=hh;%此时hh表示的意思：矩阵pp中第n-i+2行第hh个数字是由n-i+1行中的数字相加而来
        break;
    end
end
if hh_diff==1
    cc=c(hh_diff+1:length(c));

    for j=0:s-1
        bb=strcat (  c(hh_diff) , num2str(j)     );
        cc=[cc;  bb  ];
    end

else  %当hh不为1的时候
    cc=c(1:hh_diff-1);
    cc=[cc;c(hh_diff+1:length(c))];
    if s==1
        s=s+1;%当s=1时需要加1，因为s=1时并未真正压缩，之前已经处理过，因此这里对应要做出变化
    end
    for j=0:s-1
        bb=strcat (  c(hh_diff) , num2str(j)     );
        cc=[cc;  bb  ];
    end
end
c=cc;
disp('第一行的概率以及对应的第二行霍夫曼编码：')
[sprintfc('%g',pp(1,:));c']


end