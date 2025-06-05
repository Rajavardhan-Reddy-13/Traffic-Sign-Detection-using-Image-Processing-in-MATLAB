% Main script for traffic signal template matching

% Load the target and template images
targetImage = imread('test2.jpg'); % Replace with your target image path
templateImage = imread('temp4.jpg'); % Replace with your template image path

% Preprocess images to focus on traffic signals
targetImage = preprocessImage(targetImage);
templateImage = preprocessImage(templateImage);

% Compute the normalized cross-correlation matrix
M = ncrossco(targetImage, templateImage);

% Get the size of the template
[templateRows, templateCols] = size(templateImage);

% Plot the bounding box around the matched template
plotbox(targetImage, M, templateRows, templateCols);
