function [D, dist, aLongestString] = LongestCommonSubsequence(s1,s2)
% LongestCommonSubsequence calcualtes the longest common subsequence
% between the arrays s1 and s2
% https://en.wikipedia.org/wiki/Longest_common_subsequence_problem


% in here, the function is used to measure duration of the longest common 
% sequence between sequence of detected syllables and syllables in the input.

% s1 would be the syllable sequence in the input sentence
% s2 would be the syllable units seqeunce - in causal states of the 2nd
% level of the model

% implementation by David Cumin, from Matlab File exchange central
% https://ch.mathworks.com/matlabcentral/fileexchange/24559-longest-common-subsequence

X = s1;
Y = s2;


%%%Make matrix
n =length(X);
m =length(Y);
L=zeros(n+1,m+1);
L(1,:)=0;
L(:,1)=0;
b = zeros(n+1,m+1);
b(:,1)=1;%%%Up
b(1,:)=2;%%%Left
for i = 2:n+1
    for j = 2:m+1
        if (X(i-1) == Y(j-1))
            L(i,j) = L(i-1,j-1) + 1;
            b(i,j) = 3;%%%Up and left
        else
            L(i,j) = L(i-1,j-1);
        end
        if(L(i-1,j) >= L(i,j))
            L(i,j) = L(i-1,j);
            b(i,j) = 1;%Up
        end
        if(L(i,j-1) >= L(i,j))
            L(i,j) = L(i,j-1);
            b(i,j) = 2;%Left
        end
    end
end
L(:,1) = [];
L(1,:) = [];
b(:,1) = [];
b(1,:) = [];
dist = L(n,m);
D = (dist / min(m,n));
if(dist == 0)
    aLongestString = '';
else
    %%%now backtrack to find the longest subsequence
    i = n;
    j = m;
    p = dist;
    aLongestString = {};
    while(i>0 && j>0)
        if(b(i,j) == 3)
            aLongestString{p} = X(i);
            p = p-1;
            i = i-1;
            j = j-1;
        elseif(b(i,j) == 1)
            i = i-1;
        elseif(b(i,j) == 2)
            j = j-1;
        end
    end
    if ischar(aLongestString{1})
        aLongestString = char(aLongestString)';
    else
        aLongestString = cell2mat(aLongestString);
    end
end

end

