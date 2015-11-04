function output = bilateralFilter( input, sigma, sigmar, border_treatment )
%BILATERALFILTER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

input = im2double(input);
gaussian_mask = gaussianKernel2d( sigma ) * 2 * pi * sigma^2;
[y_size, x_size] = size(gaussian_mask);
pad_y = floor(y_size / 2);
pad_x = floor(x_size / 2);


%Initialize the output
output = im2double(zeros(size(input)));

%Do padding
padded_image = pad(input, pad_y, pad_x, border_treatment);

%Do convolution
%Each pixel in the output is the convolution of pixels in the padded image
%with the filter mask.
for i = 1:size(output,2)
    for j = 1:size(output,1)
        filter_area = padded_image(j:j+y_size-1,i:i+x_size-1);
        multi_matrix = gaussian_mask.*bilateralMask(filter_area, sigmar);
        c = sum(sum(multi_matrix));
        output(j,i) = sum(sum(filter_area.*multi_matrix))/c;
    end
end


end
