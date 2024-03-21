function [imgs] = db_readin(datastore_path, checking_size)

%  datastore_path: path to located folder with images
%  checking_size: area of intrest, används ej längre

imgs = readall(datastore_path);

tot = size(imgs, 1);


disp("Reading database...")
for i = 1:tot

    img = im2double(imgs{i});
    img = imresize(img, [32, 32], "bilinear");
    img = rgb2lab(img);
    imgs{i} = img;
end

disp("Done")
end

