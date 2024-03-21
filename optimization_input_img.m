function [selectedImages] = optimization_input_img(in_img_lab, numImagesToSelect, imgs)
%OPTIMIZATION_INPUT_IMG Summary of this function goes here
%   Detailed explanation goes here

    numdominantColours = 50;

    dominatColoursOG = dominantColours(lab2rgb(in_img_lab), numdominantColours);
    OG = cell(numdominantColours, 1);

    for i = 1:numdominantColours
        OG{i} = ind2rgb(i, dominatColoursOG);
    end

    % Plot all the information
    % figure;
    % subplot(1, 3, 1); imshow(og_img); axis off; title('Original RGB Image');
    % subplot(1, 3, 2); imagesc(X); colormap(map); title('Indexed with 6 colors'); axis off; axis square; 
    % subplot(1, 3, 3); imagesc(lab); title('CIELAB representation'); axis off; axis square; 
    % hold off; 

    % figure; 
    % color_square = zeros(1, 1, 3); 
    % 
    % subplot(2, 3, 1);
    % color_square(:, :, :) = OG{1}; 
    % imshow(color_square);
    % title('DC 1');
    % 
    % subplot(2, 3, 2);
    % color_square(:, :, :) = OG{2}; 
    % imshow(color_square);
    % title('DC 2');
    % 
    % subplot(2, 3, 3);
    % color_square(:, :, :) = OG{3}; 
    % imshow(color_square);
    % title('DC 3');
    % 
    % subplot(2, 3, 4);
    % color_square(:, :, :) = OG{4}; 
    % imshow(color_square);
    % title('DC 4');
    % 
    % subplot(2, 3, 5);
    % color_square(:, :, :) = OG{5}; 
    % imshow(color_square);
    % title('DC 5');
    % 
    % subplot(2, 3, 6);
    % color_square(:, :, :) = OG{6}; 
    % imshow(color_square);
    % title('DC 6');
    % hold off

    similarities = zeros(numel(imgs), 1); 

    disp("Starting dominant colour optimazation...");
    for i = 1:numel(imgs)
        imgDominantColors = dominantColours(lab2rgb(imgs{i}), numdominantColours);

        currentColors = cell(numdominantColours, 1);
        for j = 1:numdominantColours
            currentColors{j} = ind2rgb(j, imgDominantColors);
        end

        % Calculate similarity for each dominant color and average
        totalSimilarity = 0;
        for j = 1:numdominantColours
            totalSimilarity = totalSimilarity + calculateSimilarity(OG{j}, currentColors{j});
        end

        similarities(i) = totalSimilarity / numdominantColours;
    end
    
    % Select the top images based on similarity
    [~, sortedIndices] = sort(similarities, 'descend');
    selectedIndices = sortedIndices(1:numImagesToSelect);

    % Save selected images to a cell variable
    selectedImages = cell(numImagesToSelect, 1);
    
    for i = 1:numImagesToSelect
        selectedImages{i} = imgs{selectedIndices(i)};
    end

    disp("Done")
end


% Calc similiarity
function similarity = calculateSimilarity(ogColour, currentColour)
    Lab1 = rgb2lab(ogColour, 'WhitePoint', 'D65');
    Lab2 = rgb2lab(currentColour, 'WhitePoint', 'D65');

    diff = sqrt(sum((Lab1 - Lab2).^2));
    similarity = 1 - diff / (sqrt(3) * 100);
end

% Ta fram dominant colours
function dominantColours = dominantColours(og_img, numColours)
    % Convert LAB image to indexed image
    [~, dominantColours] = rgb2ind(og_img, numColours);
end

