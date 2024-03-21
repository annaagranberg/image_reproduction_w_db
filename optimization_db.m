function [selectedImages] = optimization_db(numImagesToSelectPerCluster, numClusters, imgs)

    disp("Starting database optimazation...");

    % Initialize cell arrays to store average distances and sorted indices
    avgDistancesCell = cell(1, numClusters);
    sortedIndicesCell = cell(1, numClusters);

    % Concatenate all images into a single matrix
    allImages = cat(3, imgs{:});

    % Perform K-means clustering
    meanLAB = mean(reshape(allImages, [], 3));
    disp("K-means clustering...");
    [idx, centers] = kmeans(reshape(allImages, [], 3),numClusters, 'MaxIter', 500);

    % Plot cluster centers in LAB color space
    figure;
    scatter3(centers(:,1), centers(:,2), centers(:,3), 100, centers, 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
    xlabel('L*');
    ylabel('a*');
    zlabel('b*');
    title('Cluster Centers in LAB Color Space');

    % Display representative images from each cluster
    % figure;
    % for i = 1:numClusters
    %     subplot(1, numClusters, i);
    %     selectedIndices = find(idx == i);
    %     imshow(imgs{selectedIndices(1)});
    %     title(['Cluster ' num2str(i)]);
    % end


    % Calculate Euclidean distances to cluster centers
    distances = pdist2(reshape(allImages, [], 3), centers);

    % Calculate the average distance for each image
    avgDistances = mean(distances, 2);

    disp("Separating and sorting indices for each cluster...");
    % Separate average distances and sorted indices for each cluster
    for i = 1:numClusters
        [~, sortedIndices] = sort(avgDistances((i - 1) * numel(imgs) + 1 : i * numel(imgs)));
        avgDistancesCell{i} = avgDistances((i - 1) * numel(imgs) + 1 : i * numel(imgs));
        sortedIndicesCell{i} = sortedIndices;
    end

    % Initialize a cell array to store selected images
    selectedImages = cell(numImagesToSelectPerCluster * numClusters, 1);

    % Select the top images based on uniqueness measure for each cluster
    for i = 1:numClusters
        selectedIndices = sortedIndicesCell{i}(1:min(numImagesToSelectPerCluster, numel(sortedIndicesCell{i})));

        % Add selected images to the result cell array
        selectedImages((i - 1) * numImagesToSelectPerCluster + 1 : i * numImagesToSelectPerCluster) = imgs(selectedIndices);
    end

    disp("Done");
end
