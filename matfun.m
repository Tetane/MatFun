function funmat = matfun(fun, mat, dim)
%MATFUN Apply function to the specified dimensions of the matrix
%   A = MATFUN(FUN, MAT, DIM) applies the function specified by FUN to the dimensions DIM of the matrix MAT.
%   DIM is vector which maximum size is 3.

% Example1:
% A = rand(3,1000,1000);
% % We want to compute the norm of the vector along the first dimension.
% B = matfun(@norm, A, 1);
% % B is a 1000x1000 matrix containing the norms of the vectors.

% Example2:
% A = rand(4,4,1000);
% % We want apply the inverse function to all the 4x4 matrices
% B = matfun(@inv, A, [1,2]);
% % B is a 4x4x1000 matrix


initmatSize = size(mat);
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

switch ld
    case 1
        testSize = size(fun(mat(:,1)));
        funmat = zeros(testSize(1), lengthRepVec);
        for ifun = 1:lengthRepVec
            funmat(:,ifun) = fun(mat(:,ifun));
        end
    case 2
        testSize = size(fun(mat(:,:,1)));
        funmat = zeros(testSize(1), testSize(2), lengthRepVec);
        for ifun = 1:lengthRepVec
            funmat(:,:,ifun) = fun(mat(:,:,ifun));
        end
    case 3
        testSize = size(fun(mat(:,:,:,1)));
        funmat = zeros(testSize(1), testSize(2), testSize(3), lengthRepVec);
        for ifun = 1:lengthRepVec
            funmat(:,:,:,ifun) = fun(mat(:,:,:,ifun));
        end
end

if l - ld > 1
    funmat = squeeze(reshape(funmat, [testSize(1:ld), matSize(ld+1:end)]));
else
    funmat = squeeze(funmat);
end

end

