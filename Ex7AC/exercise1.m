%% initialization for first image (0000.png)

% initialize R0 and T0
R0 = eye(3);
T0 = 0;

% initialize intrinsic camera matrix
A = [472.3 0.64 329.0 ; 0 471.0 268.3 ; 0 0 1];

% initialize the first image
I0RGB = imread('img_sequence/0000.png');
I0 = im2single(rgb2gray(I0RGB));

% compute sift features and descriptors 
[feat0, desc0] = vl_sift(I0(73:390, 97:557));
feat0(1,:) = feat0(1,:)+97;
feat0(2,:) = feat0(2,:)+73;

% upperLeft = [ 97 ; 73 ]
% downRight = [ 557 ; 385 ]

m0 = [ feat0(1,:) ; feat0(2,:) ; ones(1,size(feat0,2)) ];

% do backprojection
M0 = inv(A) * m0;


%% _________________________________Loading exercise 2 (the comparison of other stuff)

% get the remaining images and save them to a cellArray
% e.g. image{1} is '0001.png'
images = readImages();

inliers = cell(44,2);
savedRT = zeros(44, 5);

savedCam = zeros(44, 3);

%for i = 1:44
for i = 1:44
    tic
    % get the current image and do conversion for feature extraction
    currentImageRGB = images{i};    
    currentImage = im2single(rgb2gray(currentImageRGB));
        
    [feati, desci] = vl_sift(currentImage);
    
    matchThreshold = 1;
    [matchesi, scoresi] = vl_ubcmatch(desc0, desci, matchThreshold); 
    
    % filter out matched features (without orientation/scale)
    matchedFeat0 = feat0(1:2,matchesi(1,:));
    matchedFeati = feati(1:2,matchesi(2,:));
    
    % get Homography and inliers
    % size(matchesi)
    %[tform,inlyingFeat0,inlyingFeati] = estimateGeometricTransform(matchedFeat1',matchedFeati','projective');
    
    % get homography and inliers our way
    [inlierIndices, H] = ransacAdapted(matchedFeat0, matchedFeati, 2,4);
    inlyingFeat0 = matchedFeat0(:,inlierIndices);
    inlyingFeati = matchedFeati(:,inlierIndices);
    
    inlyingM0 = M0(:, inlierIndices);
    
    % visualizing features
    output = drawMatches(I0RGB, currentImageRGB, inlyingFeat0, inlyingFeati);
    %imshow(output);
    
    % save inlyingFeatures
    inliers{i}{1} = inlyingM0;
    inliers{i}{2} = inlyingFeati;
    
    
    imwrite(output,['result_sequence/img_', sprintf('%03d',i), '.png']);
    toc

    % x = [ux, uy, uz, t1, t2]
    fExponential = @(x) energyFunction( x, A, inlyingM0, inlyingFeati); 
    x = fminsearch(fExponential, [0,0,0,0,0]);
    savedRT(i,:) = x;
    
    % obtain R using Rodrigues formula
    w_hat = [0, -x(3), x(2) ; x(3) , 0 -x(1) ; -x(2), x(1), 0];
    length_w = norm([x(1), x(2), x(3)]);    
    Ri = eye(3) + w_hat / length_w * sin(length_w) + (w_hat^2)/(length_w^2) * (1-cos(length_w));
    
    Ti = [x(4);x(5);1];
    
    savedCam(i,:) = -Ri'*Ti
    
end







%I1RGB = imread('img_sequence/0001.png');
%I1 = im2single(rgb2gray(I1RGB));

% [feat1, desc1] = vl_sift(I1);

%matchThreshold = 1;
%[matches, scores] = vl_ubcmatch(desc0, desc1, matchThreshold); 

% filter out matched features (without orientation/scale)
% matchedFeat1 = feat0(1:2,matches(1,:));
% matchedFeat2 = feat1(1:2,matches(2,:));

% get Homography

% [tform,inlyingFeat0,inlyingFeat1] = estimateGeometricTransform(matchedFeat1',matchedFeat2','projective');


% visualizing features
% output = drawMatches(I0RGB, I1RGB, inlyingFeat0', inlyingFeat1');
% imshow(output);
