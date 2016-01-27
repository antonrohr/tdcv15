function [ matches_1, matches_2 ] = matchSIFT( image_1, image_2 )

%Performs SIFT feature detection in two images, then performs feature
%matching using Euclidian distance. Only feature points are recorded,
%descriptors are discarded. 

[f1,d1] = vl_sift(image_1) ;
[f2,d2] = vl_sift(image_2) ;

[matches, scores] = vl_ubcmatch(d1,d2) ;

[matches_1, matches_2] = match_points( f1, f2, matches );

end
