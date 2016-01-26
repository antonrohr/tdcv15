function intensity_deltas = computeIntensityDeltas(reference_image, ref_intensities, grid_coordinates, homographies)
%COMPUTEINTENSITYDELTAS computes the difference in intensities for each
%grid point between the warped and reference images. 

%Need to floop the pig here
grid_coordinates = grid_coordinates';


intensity_deltas = zeros(size(grid_coordinates,1), size(homographies,2));
for i = 1 : size(homographies,2)
    H = homographies{i};
    
    %Backwarp the template
    
    backwarped_grid = inv(H)*[grid_coordinates(:,1),grid_coordinates(:,2),ones(size(grid_coordinates,1),1)]';
    backwarped_grid = backwarped_grid';
    backwarped_grid = backwarped_grid./repmat(backwarped_grid(:,3),1,3);
    backwarped_grid = backwarped_grid(:,1:2);
    
    %Sample the backwarped template
    sample = interp2(1:size(reference_image,2),1:size(reference_image,1),reference_image, ...
        backwarped_grid(:,1),backwarped_grid(:,2),'linear',0);
    %Normalize the sample
    sample = sample - mean(sample);
    sample = sample./std(sample);

    %Compute the intensity differences 
    intensity_deltas(:,i) = sample - ref_intensities;
    
end

intensity_deltas = intensity_deltas + 0.001*randn(size(intensity_deltas));

end

