%% Initialise the vl library.
run('C:\Users\Anton Troynikov\Documents\MATLAB\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup.m')

%% Read the first image
i_0 = imread('img_sequence/0000.png');

%% Initialise intrinsics
A = [472.3 0.64 329.0; 0 471.0 268.3; 0 0 1];

%% Get the SIFT points within the object boundary.
singled_0 = single(rgb2gray((i_0)));
[f_0,d_0] = vl_sift(singled_0(73:390, 97:557));

f_0(1,:) = f_0(1,:)+97;
f_0(2,:) = f_0(2,:)+73;

%% Transform features into homogeneous coordinates 
h_f0 = [f_0(1:2,:);zeros(1,size(f_0,2))];

%% Reproject the points into the image plane
M_0 = inv(A)*h_f0;