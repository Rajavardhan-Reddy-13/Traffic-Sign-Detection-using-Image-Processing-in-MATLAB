function processedImage = preprocessImage(image)
    % Convert to grayscale if necessary
    if size(image, 3) == 3
        imageGray = rgb2gray(image);
    else
        imageGray = image;
    end

    % Apply edge detection to highlight traffic signs
    edges = edge(imageGray, 'Canny');

    % Morphological operations to clean up edges
    edges = imdilate(edges, strel('disk', 2)); % Dilate edges
    edges = imfill(edges, 'holes'); % Fill holes
    edges = bwareaopen(edges, 500); % Remove small objects

    % Apply the edge mask to the grayscale image
    processedImage = uint8(edges) .* imageGray;

    % Optionally display the preprocessed image
    figure;
    imshow(processedImage);
    title('Preprocessed Image - Focused on Traffic Signals');
end
