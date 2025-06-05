function plotbox(targetImage, M, templateRows, templateCols)
    % Find the maximum value and its location in the correlation matrix
    [maxValue, linearIndex] = max(M(:));
    [row, col] = ind2sub(size(M), linearIndex);

    % Display the target image
    figure;
    imshow(targetImage);
    hold on;

    % Draw a bounding box around the matched region
    rectangle('Position', [col, row, templateCols, templateRows], ...
              'EdgeColor', 'yellow', 'LineWidth', 2);

    % Add a title to the figure
    title(['Matched Template - Max Correlation: ', num2str(maxValue)]);
    hold off;
end
