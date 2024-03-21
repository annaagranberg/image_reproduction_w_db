function [SNR, SCIELAB, SSIM] = quality(in_img, res_img)
%QUALITY Summary of this function goes here
%   Detailed explanation goes here


xyz_in_img = rgb2xyz(im2double(in_img));
xyz_res_rgb = rgb2xyz(im2double(res_img));

ppi = 172; d = 24; %172 %108 -> 1.3
sampPerDegree = ppi*d*tan(pi/180);

addpath('scielab');
SCIELAB = mean(scielab(sampPerDegree, xyz_res_rgb, xyz_in_img, [95.05, 100, 108.9], 'xyz'), 'all');

SNR = mysnr(in_img, in_img - res_img);

[SSIM, map] = ssim(in_img, res_img);

end

