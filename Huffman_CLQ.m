function Huffman_CLQ(p,r )
%这个是霍夫曼编码的核心代码，分别调用了check_p，first_compress，compress_pp等三个函数，具体功能见各个函数
[pp,cp_1]=compress_pp(p,r) ; %pp为对p排序后矩阵
c={};%c为最终编码存储的位置
[n,~]=size(pp);
%p压缩了n-1次，
for ii=1:r
    c=[c;num2str(ii-1)];
end
%对多于3行的pp的编码方式（先有规律编码，再最后一步编码）
if n >=3
    for i=2:n-1
        %对于除了最后一步之外的编码
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
                %此时hh_diff表示的意思：矩阵pp中第n-i+2行第hh个数字是由n-i+1行中的数字相加而来
                break;
            end
        end

        % 编码模块
        %c代表这一层的编码code，cc代表下一行的编码,cc_short代表短的编码（由非合并而来的符号的编码）
        %
        if hh_diff==1
            cc=c(hh_diff+1:length(c));

            for j=1:r
                cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
                cc=[cc;  cc_long  ];
            end
        else  %当hh_diff不为1的时候
            cc=[c(1:hh_diff-1);c(hh_diff+1:length(c))];
            for j=1:r
                cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
                cc=[cc;  cc_long  ];
            end
        end
        c=cc;
    end

    %最后一步的编码，第一次压缩s个
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

        for j=1:cp_1
            cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
            cc=[cc;  cc_long  ];
        end
    else  %当hh不为1的时候
        cc=c(1:hh_diff-1);
        cc=[cc;c(hh_diff+1:length(c))];
        if cp_1==1
            cp_1=cp_1+1;%当s=1时需要加1，因为s=1时并未真正压缩，之前已经处理过，因此这里对应要做出变化
        end
        for j=1:cp_1
            cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
            cc=[cc;  cc_long  ];
        end
    end
    c=cc;
end

%对于只进行了一步的编码（n=2）
if n==2
    k1=pp(2,:);
    k1(k1==0)=[];
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

        for j=1:cp_1
            cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
            cc=[cc;  cc_long  ];
        end
    else  %当hh不为1的时候
        cc=c(1:hh_diff-1);
        cc=[cc;c(hh_diff+1:length(c))];
        if cp_1==1
            cp_1=cp_1+1;%当s=1时需要加1，因为s=1时并未真正压缩，之前已经处理过，因此这里对应要做出变化
        end
        for j=1:cp_1
            cc_long=strcat (  c(hh_diff) , num2str(j-1)     );
            cc=[cc;  cc_long  ];
        end
    end
    c=cc;
end

if n==1
    c=c(1:length(pp));
end
disp('第一行的概率以及对应的第二行霍夫曼编码：')
[sprintfc('%g',pp(1,:));c']


end
