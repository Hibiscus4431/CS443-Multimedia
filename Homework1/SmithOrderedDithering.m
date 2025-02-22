% Paige Smith
% CS 443 - Homework 1

% Part 1: Dithering implementation

% Implement and apply the Ordered Dithering algorithm on two 
% given images
% Convert images to grayscale before algorithm application

% Ordered Dithering pseudo:
%{for x = 0 to xmax do
%   for y = 0 to ymax do
%       i = x mod n
%       j = y mod n

%       if I(x,y) > D(i,j) then
%           O(x,y) = 1

%      else
%           O(x,y) = 0
            %}


% Create a MatLab function that applies the ordered dithering algorithm
% to an input image

function outputImg = orderedDithering(inputFile)
    %inputFile is a .png
    %read in the png
    original = imread(inputFile);

    %convert image to grayscale
    % convert image to grayscale
    grayImg = rgb2gray(original);

    %get size of grayscale image matrix
    [m, n] = size(grayImg);

    %create matrix for dithered image with this size
    outputImg = zeros(m, n, 'uint8');

    %convert grayscale matrix to double to maintain precision
    doubleMatrix = double(grayImg);

    %normalize the grayscale matrix (divide by 255)
    doubleMatrix = (1/255)*doubleMatrix;

    %input the given dither matrix
    ditherMatrix = [0 8 2 10; 12 4 14 6; 3 11 1 9; 15 7 13 5];
    ditherMatrix = (1/16)*ditherMatrix;
    
    %apply the algorithm to the grayscale image
    for i=1:m
        for j=1:n
            col = (mod(i,4))+1; % 4 = n x n dither matrix size
            row = (mod(j,4))+1;
            
            %compare the input matrix value to the dither matrix value
            %and change value accordingly if greater or less than dither value
            if (doubleMatrix(i,j) > ditherMatrix(col, row))
                outputImg(i,j) = 255;
            else
                outputImg(i,j) = 0;
            end

        end
    end

    %change image back to uint8 for imshow to display properly
    outputImg = uint8(outputImg);
   
end

%call function with given images
img1 = "boy.png";
outputImg = orderedDithering(img1);
imwrite(outputImg, "ditheredBoy.png");

% display result
figure;
hold on;
subplot(2,1,1), imshow(outputImg), title('Ordered Dithering Image - Boy');

img2 = "alu.png";
outputImg = orderedDithering(img2);
imwrite(outputImg, "ditheredALU.png");
subplot(2,1,2), imshow(outputImg), title('Ordered Dithering Image - ALU');