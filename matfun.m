function [ funmat ] = matfun( fun ,mat, dim, outputsize)
%MATFUN Apply function to the specified dimension of the matrix
%   A = MATFUN(FUN, MAT, DIM) applies the function specified by FUN to the dimension DIM of the matrix MAT.
%   DIM is vector which maximum size is 3.
%   A = MATFUN(FUN, MAT, DIM, OUTPUTSIZE) applies the function specified by FUN to the dimension DIM of the matrix MAT.
%   OUTPUTSIZE specify the size of the output A.

initmatSize = size(mat);
if nargin == 3
    outputsize = initmatSize;
end
l = length(initmatSize);
ld = length(dim);
if ld>3
    error('The size of DIM must be between 1 and 3.')
end

initOrder = 1:l;
order = initOrder;
order(1:ld) = dim;
tempOrder = initOrder;
tempOrder(dim) = [];
order(1+ld : end) = tempOrder;
if ~isequal(order, 1:length(size(mat)))
    mat = permute(mat, order);
end

matSize = size(mat);

lengthRepVec = prod(matSize(ld+1:end));
calc = matSize(1:ld);

if l - ld > 1
    mat = reshape(mat, [calc, lengthRepVec]);
end

testSize = size(fun(mat(:,1)));
if ~isequal(testSize(1:ld), initmatSize(1:ld)) && nargin == 3
    warning('The size of the output is different from the size of the input matrix. You should specify the size OUTPUTSIZE of the output matrix.');
end

switch ld
    case 1
        if isequal(initmatSize, outputsize)
            funmat = zeros(matSize(1), lengthRepVec);
        end
        for ifun = 1:lengthRepVec
            funmat(:,ifun) = fun(mat(:,ifun));
        end
    case 2
        if isequal(initmatSize, outputsize)
            funmat = zeros(matSize(1), matSize(2), lengthRepVec);
        end
        for ifun = 1:lengthRepVec
            funmat(:,:,ifun) = fun(mat(:,:,ifun));
        end
    case 3
        if isequal(initmatSize, outputsize)
            funmat = zeros(matSize(1), matSize(2), matSize(3), lengthRepVec);
        end
        for ifun = 1:lengthRepVec
            funmat(:,:,:,ifun) = fun(mat(:,:,:,ifun));
        end
end


if l - ld > 1
    try
        funmat = reshape(funmat, outputsize);
    catch exception
        if strcmp(exception.identifier, 'MATLAB:getReshapeDims:notSameNumel') && nargin == 4
            error('OUTPUTSIZE is not consistent with the actual size of the output.');
        else
            error(exception.message);
        end
    end
end 


end

