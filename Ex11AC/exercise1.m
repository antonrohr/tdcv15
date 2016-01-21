inputImageRGB = imread('2043_000162.jpeg');
inputImageGray = rgb2gray(inputImageRGB);

% template measures 
templateTLR = 337; % TLR = TopLeftRow
templateTLC = 365; % TLC = TopLeftCol
templateBRR = 400; % BRR = BotRightRow
templateBRC = 450; % BRC = BotRightCol

templateRGB = inputImageRGB(templateTLR:templateBRR, templateTLC:templateBRC, :);
templateGray = inputImageGray(templateTLR:templateBRR, templateTLC:templateBRC);


%scoresNCC = ncc(im2double(templateGray),im2double(inputImageGray));
%[maxNCCrow, maxNCCcol] = find(scoresNCC==max(max(scoresNCC)),1);

%how many pyramid levels are wanted
pyrLevels = 20;

%initialize search window [row col]
searchWinTL = [1,1];
searchWinBR = size(inputImageGray);

for i = 1:pyrLevels
    %templateGrayScaled = imresize(templateGray, i/pyrLevels);
    %inputImageGrayScaled = imresize(inputImageGray, i/pyrLevels);
 	
    scale = i/pyrLevels; % set the scaling factor
    
    resultTL = templateMatching(im2double(templateGray), im2double(inputImageGray), @nccPowerFunc, @findMax, scale, searchWinTL, searchWinBR);
    %resultTL = templateMatching(im2double(templateGray), im2double(inputImageGray), @ssdPowerFunc, @findMin, scale, searchWinTL, searchWinBR);
    resultBR = resultTL + size(templateGray);
    
    searchWinTL = resultTL - round(size(inputImageGray)/(scale*50));
    searchWinBR = resultBR + round(size(inputImageGray)/(scale*50));
    
    drawedImg = drawRectangle(inputImageRGB, resultTL(1), resultTL(2), resultBR(1), resultBR(2));
    imshow(drawedImg);
    disp('');
    
end




%drawedImg = drawRectangle(inputImageRGB, minSSDrow, minSSDcol, minSSDrow+size(templateRGB,1), minSSDcol+size(templateRGB,2));
