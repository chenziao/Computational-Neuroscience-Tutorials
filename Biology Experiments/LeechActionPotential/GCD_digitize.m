function [y,unit] = GCD_digitize( x, tol )
% Return digitized array and the greatest common divisor of input array.
% Return original array and 0 if no GCD is found.
if numel(x)<2
    error('Not enough numbers of elements in input array.');
end
if nargin<2
    tol = 1e-8; % tolerance of rounding precision
end

%itr = 0;
uniq = unique(abs(x(:)));
if uniq(1)==0, uniq(1)=[]; end
m = uniq(1);
while numel(uniq)>1 && uniq(1)>m*tol
    unit = uniq(1);
    t = unit*tol;
    res = mod(uniq(2:end),unit);
    res = sort(res(res>t));
    uniq = [res;unit];
%    itr = itr+1;
end

if numel(uniq)>1
    y = x;
    unit = 0;
else
    unit = m/round(m/unit);
    y = round(x/unit);
end
% disp(itr);
end
