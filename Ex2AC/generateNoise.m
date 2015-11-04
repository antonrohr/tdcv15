function [ outputImage ] = generateNoise( inputImage, type, arg)


[rows, cols] = size(inputImage);

outputImage = inputImage;

if strcmp(type, 'salt')
    
    %arg is number of salted pixels
    randData = rand(3, arg);

    for i = 1:arg;
        x = ceil(rows * randData(1, i));
        y = ceil(cols * randData(2, i));

           
        outputImage(x,y) = round(randData(3,i));
    end


end

if strcmp(type, 'gaussian');

    %arg is signal to noise ratio
    outputImage = awgn(outputImage, arg);
    
end

