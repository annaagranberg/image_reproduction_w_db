

% ----------- Read in OG picture -----------
og_img = imread("testbilder/photo_landscape.jpg");
in_img = im2double(imresize(og_img, [1000,1000], "bilinear"));

in_img_lab = rgb2lab(in_img);

[height, width, ~] = size(og_img);
[refheight, refwidth, ~] = size(in_img);

if height < refheight || width < refwidth
    warning('Original image dimensions requires resizing, this might effect the result');
end

% ----------- Variables -----------
checking_size = 10;

optimazation_v1 = false; % optimazation_db.m
numClusters = 10;
numImagesToSelectPerCluster = 5;

optimazation_v2 = false; % optimazation_input_img.m
numImagesToSelect = 100;

rep_w_structure = false; % reproduction_w_structure.m

% ----------- Read in image db -----------
selectedImages = db_readin(imageDatastore('images_2\*.jpg'), checking_size); %%images_2 -> .jpg


% ----------- Optimazation -----------
tic 
if(optimazation_v1)
    selectedImages = optimization_db(numImagesToSelectPerCluster, numClusters, selectedImages); 
end

if(optimazation_v2)
    selectedImages = optimization_input_img(in_img_lab, numImagesToSelect, selectedImages);
end

% figure
% for i = 1:9
%     subplot(3, 3, i); imshow(lab2rgb(selectedImages{i+9}));
% end
% hold off

% % ----------- Resizing -----------
for i = 1:size(selectedImages)
    selectedImages{i} = imresize(selectedImages{i}, [checking_size, checking_size], "bilinear");
end

% ----------- Image reproduction -----------
if(rep_w_structure)
    [res_img, best_indices] = reproduction_w_structure(in_img_lab, checking_size, selectedImages);
else
    res_img = reproduction(in_img_lab, checking_size, selectedImages);
end
 
toc
% ----------- Compute sCIELAB value -----------
[SNR, SCIELAB, SSIM]  = quality(in_img, res_img);

disp("SNR: " + SNR);
disp("SCIELAB: " + round(SCIELAB, 3));
disp("SSIM: " + SSIM);

% ----------- Dispaly final result -----------
figure
subplot(1, 2, 1); imshow(in_img); title('Original image');
subplot(1, 2, 2); imshow(res_img); title('Resulting image with database optimazation'); 
text(10,2100, "SNR: " + SNR);
text(10,2300, "SCIELAB: " + SCIELAB);
text(10,2500, "SSIM: " + SSIM);
