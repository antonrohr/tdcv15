%read image
image = double(imread('Lena.gif'));

%create 3x3 mask
mask = ones(3,3);

type = 'clamp';

outputImage = convFilter(image, mask, type);



