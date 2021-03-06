clc;    clear;
im = imread('license_plate.jpg');
figure(8),imshow(im),title('original image');
%convert it to grayscale level
im_gray = rgb2gray(im);
figure(9),imshow(im_gray),title('grayscale image');
black_white_im = im_gray < 150;
figure(3),imshow(black_white_im),title('Black and white image');

%locate the plate where we are interested in (where the numbers and letters
%are located)
im_enhanced = locate_num_letter(black_white_im);
figure(4),imshow(im_enhanced),title('enhanced image');
%%
%seprate each letter
whitepixels = sum(im_enhanced);
figure(5),imshow(im_enhanced);
hold on;
plot(max(whitepixels) - whitepixels, 'r','LineWidth', 3);
chars = whitepixels > 5;
plot(diff(chars));
startregion = [1 find(diff(chars) == 1)];
endregion = [find(diff(chars) == -1) length(chars)];
chars = endregion - startregion;
charTH = mean(chars);
%The true character stars at the third of the 'chars', and end at the ninth
%of the 'chars'
%%
templateDir = fullfile(pwd, 'templates');
templates = dir(fullfile(templateDir, "*.png"));
% template1 = imread(fullfile(templates(1).folder, templates(1).name));
% figure(6);  imshow(template1);
figure(6),title('database');
candidateImage = cell(length(templates), 2);
for p = 1:length(templates)
    subplot(6, 7, p);
    [~, fileName] = fileparts(templates(p).name);
    candidateImage{p, 1} = fileName;
    candidateImage{p, 2} = imread(fullfile(templates(p).folder, templates(p).name));
    imshow(candidateImage{p, 2});
end

LicenseNumber = '';
for p = 1:length(chars)
    if chars(p) > charTH
        % extract the letter
        letterImage = im_enhanced(:, startregion(p):endregion(p));    
        distance = zeros(1, length(templates));          % compare to templates
        for t = 1:length(templates)
            letterImage = imresize(letterImage, size(candidateImage{t,2}));
            distance(t) = abs(sum((letterImage-double(candidateImage{t,2})).^2, "all"));
        end
        [d, idx] = min(distance);
        letter = candidateImage{idx, 1};
        if strcmp(letter, 'other')
            letter = '~';
        end
        LicenseNumber(end+1) = letter;
    end
end
LicenseNumber