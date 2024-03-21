function [res_rgb, best_indices] = reproduction_w_structure(in_img_lab, checking_size, imgs)

comp_img = ones(size(in_img_lab)); %allocate
res_img = ones(size(in_img_lab)); %allocate

i_range = size(in_img_lab, 1) / checking_size;
j_range = size(in_img_lab, 2) / checking_size;

% Ensure that the size of in_img_lab is divisible by checking_size
assert(mod(size(in_img_lab, 1), checking_size) == 0, 'Height of in_img_lab is not divisible by checking_size');
assert(mod(size(in_img_lab, 2), checking_size) == 0, 'Width of in_img_lab is not divisible by checking_size');

loading = waitbar(0, 'Processing image...');

% best_indices = zeros(i_range, j_range, 3); % Array to store the three best indices for each block

for i = 1:i_range
    for j = 1:j_range

        % ----------- Get the area we are checking -----------
        area = in_img_lab((i-1)*checking_size+1 : i*checking_size, (j-1)*checking_size+1 : j*checking_size, :);

        % ----------- Comparing variables -----------
        differences = zeros(size(imgs, 1), 1);

        for k = 1:1:size(imgs, 1)

            % ----------- Calc the difference -----------
            refImg = imgs{k};
            [mean1, max1, deltaE1] = Euclidean(area(:,:,1), area(:,:,2), area(:,:,3), mean(refImg(:,:,1)), mean(refImg(:,:,2)), mean(refImg(:,:,3)));

            differences(k) = abs(mean(mean1));
        end

        % Find the index of the smallest difference
        [~, best_index] = min(differences);

        % Use the best image directly
        best_image = imgs{best_index};

        res_img((i-1)*checking_size+1 : i*checking_size, (j-1)*checking_size+1 : j*checking_size, :) = best_image;
    end
    waitbar(i/i_range, loading)
end

res_rgb = lab2rgb(res_img);
close(loading)

end
