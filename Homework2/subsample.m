% Rebecca May, Paige Smith
% Homework 2
% Due: 3/27/25

% Create a MatLab function that converts an image's RGB values to
% YCbCr and applies subsampling to it. 

% This function will be called in the MatLab subsampling application
function [outputImgRGB, outputImgGray] = subsample(inputImg, config) 
    % Grab the image and put its values in a matrix
    OrigImage = double(inputImg);
    [row, col, layer] = size(OrigImage);

    % YCbCr Matrix (given in assignment)
    ConvertYCbCr = [0.299 0.587 0.114; -0.16874 -0.33126 0.5; 0.5 -0.41869 -0.08131];

    % Column YCbCr aid matrix (given in assignment)
    YCbCrAid = [0; 0.5; 0.5];
    
    % Convert to YCbCr
    ConvertedImage = zeros(row, col, layer);

    % Iterate through the rows and columns and convert to YCbCr 
    for x = 1:row
            for y = 1:col
                % Separate the RGB layers and perform conversion
                OrgRGB = [OrigImage(x, y, 1); OrigImage(x, y, 2); OrigImage(x, y, 3)];
                YCbCr = (ConvertYCbCr * OrgRGB) + YCbCrAid;
                % Put layers back in one matrix to apply subsampling later
                ConvertedImage(x, y, 1) = YCbCr(1, 1);
                ConvertedImage(x, y, 2) = YCbCr(2, 1);
                ConvertedImage(x, y, 3) = YCbCr(3, 1);
            end
    end

    % Perform subsambling
    Subsampled = ConvertedImage;
    % Determine which subsample was chosen
    if (config)
        % 4:2:2 is chosen when true
        % Loop over the matrix in 2x4 blocks
        for r = 1:2:row
            for c = 1:4:col
                % Safe indexing to stay within bounds
                r2 = min(r+1, row);     % 2nd row
                c2 = min(c+1, col);     % 2nd column
                c3 = min(c+2, col);     % 3rd column
                c4 = min(c+3, col);     % 4th column
        
                % ===== Cb Layer =====
                % Copy cell with with into corresponding cells in 2x4
                Subsampled(r, c2, 2) = ConvertedImage(r, c, 2);
                Subsampled(r, c4, 2) = ConvertedImage(r, c3, 2);
                Subsampled(r2, c2, 2) = ConvertedImage(r2, c, 2);
                Subsampled(r2, c4, 2) = ConvertedImage(r2, c3, 2);
        
                % ===== Cr Layer =====
                % Copy cell with with into corresponding cells in 2x4
                Subsampled(r, c2, 3) = ConvertedImage(r, c, 3);
                Subsampled(r, c4, 3) = ConvertedImage(r, c3, 3);
                Subsampled(r2, c2, 3) = ConvertedImage(r2, c, 3);
                Subsampled(r2, c4, 3) = ConvertedImage(r2, c3, 3);
            end
        end
    else
        %4:2:0 is chosen when false
        % Loop over the matrix in 2x4 blocks
        for  r = 1:2:row
            for c = 1:4:col
            % Compute safe indices within bounds
            r2 = min(r+1, row);         % 2nd row
            c2 = min(c+1, col);         % 2nd column
            c3 = min(c+2, col);         % 3rd column
            c4 = min(c+3, col);         % 4th column
    
            % ===== Cb Layer =====
            % Copy cell with with into corresponding cells in 2x4
            Subsampled(r, c2, 2) = ConvertedImage(r, c, 2);
            Subsampled(r2, c,  2) = ConvertedImage(r, c, 2);
            Subsampled(r2, c2, 2) = ConvertedImage(r, c, 2);
            Subsampled(r, c4, 2) = ConvertedImage(r, c3, 2);
            Subsampled(r2, c3, 2) = ConvertedImage(r, c3, 2);
            Subsampled(r2, c4, 2) = ConvertedImage(r, c3, 2);
    
            % ===== Cr Layer =====
            % Copy cell with with into corresponding cells in 2x4
            Subsampled(r, c2, 3) = ConvertedImage(r, c, 3);
            Subsampled(r2, c, 3) = ConvertedImage(r, c, 3);
            Subsampled(r2, c2, 3) = ConvertedImage(r, c, 3);
            Subsampled(r, c4, 3) = ConvertedImage(r, c3, 3);
            Subsampled(r2, c3, 3) = ConvertedImage(r, c3, 3);
            Subsampled(r2, c4, 3) = ConvertedImage(r, c3, 3);
            end
        end
    end

    % Make a copy of the YCbCr converted image for output2
    % Separate the layers from Cr subsampled image
    outputImgGray(:, :) = Subsampled(:, :, 3);

    % Save the grayscale output image
    imwrite(outputImgGray, "ouputImgGray.png");
    
    % RGB Matrix (given in assignment)
    ConvertRGB = [1 0 1.402; 1 -0.34414 -0.71414; 1 1.77200 0];
    outputImgRGB = zeros(row, col, layer);

    % Iterate through subsampled matrix and convert back to RGB values
    for x = 1:row
            for y = 1:col
                % Subtract 0.5 from Cb and Cr rows only
                RGBAid = [Subsampled(x, y, 1); Subsampled(x, y, 2)-0.5; Subsampled(x, y, 3)-0.5];
            
                % Convert the subsampled matrix back to RGB Form
                RGB = (ConvertRGB)*(RGBAid);
                RGB = max(0, min(255, RGB));

                % Add R and G and B layers back 
                outputImgRGB(x, y, 1) = RGB(1, 1);
                outputImgRGB(x, y, 2) = RGB(2, 1);
                outputImgRGB(x, y, 3) = RGB(3, 1);
            end
    end

    % Save RGB output image
    outputImgRGB = uint8(outputImgRGB);
    imwrite(outputImgRGB, "ouputImgRGB.png");

    % Display for .m running testing purposes
    disp(outputImgRGB(1:4, 1:8, 2))
    disp(OrigImage(1:4, 1:8, 2))
end