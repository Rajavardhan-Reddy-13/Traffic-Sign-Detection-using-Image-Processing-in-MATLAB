function M = ncrossco(image1, image2)
    % Convert images to grayscale if necessary
    if size(image1, 3) == 3
        image1 = rgb2gray(image1);
    end
    if size(image2, 3) == 3
        image2 = rgb2gray(image2);
    end

    % Determine which image is the target and which is the template
    if numel(image1) > numel(image2)
        targetImage = image1;
        templateImage = image2;
    else
        targetImage = image2;
        templateImage = image1;
    end

    % Get sizes of target and template images
    [R1, C1] = size(targetImage);
    [R2, C2] = size(templateImage);

    % Subtract mean from the template image
    templateMean = mean(templateImage(:));
    templateImage = double(templateImage) - templateMean;

    % Initialize the normalized cross-correlation matrix
    M = zeros(R1 - R2 + 1, C1 - C2 + 1);

    % Perform normalized cross-correlation
    for i = 1:(R1 - R2 + 1)
        for j = 1:(C1 - C2 + 1)
            % Extract a subregion from the target image
            subRegion = double(targetImage(i:i + R2 - 1, j:j + C2 - 1));
            
            % Subtract mean from the subregion
            subRegionMean = mean(subRegion(:));
            subRegion = subRegion - subRegionMean;

            % Compute normalized cross-correlation coefficient
            numerator = sum(sum(subRegion .* templateImage));
            denominator = sqrt(sum(sum(subRegion.^2)) * sum(sum(templateImage.^2)));
            M(i, j) = numerator / denominator;
        end
    end
end
