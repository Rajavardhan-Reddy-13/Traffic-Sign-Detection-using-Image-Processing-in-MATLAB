clear;               % Clears all variables from the workspace
clc;                 % Clears the command window
close all;           % Closes all open figure windows

img = imread('test1.jpg');  % Loads the input image (replace 's2.jpg' with your image file name)

%% ---------- COLOR-BASED SEGMENTATION ----------

hsvImg = rgb2hsv(img);   % Converts the RGB image to HSV color space for easier color filtering

saturationChannel = hsvImg(:,:,2);     % Extracts the Saturation channel from HSV
brightnessChannel = hsvImg(:,:,3);     % Extracts the Brightness (Value) channel from HSV

% Red color mask: detects areas that are red based on hue, saturation, and brightness
redMask = (hsvImg(:,:,1) > 0.9 | hsvImg(:,:,1) < 0.1) & ...
          (saturationChannel > 0.6) & (brightnessChannel > 0.7);

% Yellow color mask: detects areas that are yellow using hue between 0.1 and 0.2
yellowMask = (hsvImg(:,:,1) > 0.1 & hsvImg(:,:,1) < 0.2) & ...
             (saturationChannel > 0.6) & (brightnessChannel > 0.7);

% Blue color mask: detects areas that are blue using hue between 0.5 and 0.7
blueMask = (hsvImg(:,:,1) > 0.5 & hsvImg(:,:,1) < 0.7) & ...
           (saturationChannel > 0.6) & (brightnessChannel > 0.5);

%% ---------- MORPHOLOGICAL CLEANING (RED) ----------

cleanRedMask = imopen(redMask, strel('disk', 5));    % Removes small noise using morphological opening
cleanRedMask = imclose(cleanRedMask, strel('disk', 5)); % Closes small holes/gaps using morphological closing
cleanRedMask = imfill(cleanRedMask, 'holes');        % Fills internal holes in detected red areas
labeledRedMask = bwlabel(cleanRedMask);              % Labels connected red regions for analysis

%% ---------- MORPHOLOGICAL CLEANING (YELLOW) ----------

cleanYellowMask = imopen(yellowMask, strel('disk', 5));    
cleanYellowMask = imclose(cleanYellowMask, strel('disk', 5));
cleanYellowMask = imfill(cleanYellowMask, 'holes');
labeledYellowMask = bwlabel(cleanYellowMask);        % Labels yellow connected components

%% ---------- MORPHOLOGICAL CLEANING (BLUE) ----------

cleanBlueMask = imopen(blueMask, strel('disk', 5));        
cleanBlueMask = imclose(cleanBlueMask, strel('disk', 5));  
cleanBlueMask = imfill(cleanBlueMask, 'holes');            
labeledBlueMask = bwlabel(cleanBlueMask);                  % Labels blue connected components

%% ---------- REGION ANALYSIS FOR RED ----------

propsRed = regionprops(labeledRedMask, 'BoundingBox', 'Area', 'PixelIdxList'); % Get properties of red regions
if ~isempty(propsRed)     % If at least one red region is found
    redDominance = zeros(length(propsRed), 1);   % Create array to store dominance score
    for i = 1:length(propsRed)
        regionPixels = propsRed(i).PixelIdxList;   % Get pixel indices for the region
        % Sum of saturation + brightness in this region = dominance score
        redDominance(i) = sum(saturationChannel(regionPixels)) + sum(brightnessChannel(regionPixels));
    end
    [~, maxRedIdx] = max(redDominance);       % Get index of most dominant red region
    mostDominantRed = propsRed(maxRedIdx);    % Save the most dominant red region
else
    mostDominantRed = [];                     % No red region found
end

%% ---------- REGION ANALYSIS FOR YELLOW ----------

propsYellow = regionprops(labeledYellowMask, 'BoundingBox', 'Area', 'PixelIdxList');
if ~isempty(propsYellow)
    yellowDominance = zeros(length(propsYellow), 1);
    for i = 1:length(propsYellow)
        regionPixels = propsYellow(i).PixelIdxList;
        yellowDominance(i) = sum(saturationChannel(regionPixels)) + sum(brightnessChannel(regionPixels));
    end
    [~, maxYellowIdx] = max(yellowDominance);
    mostDominantYellow = propsYellow(maxYellowIdx);
else
    mostDominantYellow = [];
end

%% ---------- REGION ANALYSIS FOR BLUE ----------

propsBlue = regionprops(labeledBlueMask, 'BoundingBox', 'Area', 'PixelIdxList');
if ~isempty(propsBlue)
    blueDominance = zeros(length(propsBlue), 1);
    for i = 1:length(propsBlue)
        regionPixels = propsBlue(i).PixelIdxList;
        blueDominance(i) = sum(saturationChannel(regionPixels)) + sum(brightnessChannel(regionPixels));
    end
    [~, maxBlueIdx] = max(blueDominance);
    mostDominantBlue = propsBlue(maxBlueIdx);
else
    mostDominantBlue = [];
end

%% ---------- VISUALIZATION OF RESULTS ----------

figure;  % Create new figure window

% Display the original image
subplot(1, 2, 1);            % Left subplot
imshow(img);                 
title('Input');              % Title for input image

% Display image with bounding boxes
subplot(1, 2, 2);            % Right subplot
imshow(img);                 
title('Output');             
hold on;                     % Keep the image visible while drawing boxes

% Draw red bounding box if detected
if ~isempty(mostDominantRed)
    bbox = mostDominantRed.BoundingBox;           % Get [x, y, width, height]
    rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2); % Red border
end

% Draw yellow bounding box if detected
if ~isempty(mostDominantYellow)
    bbox = mostDominantYellow.BoundingBox;
    rectangle('Position', bbox, 'EdgeColor', 'y', 'LineWidth', 2); % Yellow border
end

% Draw blue bounding box ONLY if no red or yellow signs found
if ~isempty(mostDominantBlue) && isempty(mostDominantRed) && isempty(mostDominantYellow)
    bbox = mostDominantBlue.BoundingBox;
    rectangle('Position', bbox, 'EdgeColor', 'b', 'LineWidth', 2); % Blue border
end

hold off;   % Stop drawing on the image
