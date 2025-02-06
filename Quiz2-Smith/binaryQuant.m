% Paige Smith
% Quiz 2
% 2/7/25

% Create a MatLab function that manipulates/quantizes images

function outputImg = binaryQuant(inputFile, T)
    % inputFile = name of image file
    % T = threshold color value, 127 is tested for this assignment
    % outputImg = output image after applying quantization

    % read in png
    orig = imread("Bibble.png");
    
    % convert image to grayscale
    img = rgb2gray(orig);
    [m, n] = size(img);
    outputImg = zeros(m, n, 'uint8');
    T= 127;
    % apply threshold quantization
    % if pixel value greater than T, set to 255
    for i=1:m
        for j=1:n
            % convert the output to a binary format
            if (img(i,j) >= T)
                outputImg(i,j) = 255;
            else
                outputImg(i,j) = 0;
            end

        end
    end
    

    % display result
    figure;
    hold on;
    title("Original Vs. Binary Quantized");
    subplot(2,1,1), imshow(orig);
    subplot(2,1,2), imshow(outputImg);

    % save output result
    imwrite(outputImg, "binaryImg.png");

end