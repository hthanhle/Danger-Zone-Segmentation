function imds = resize_images(imds, in_folder, height, width)    
    if ~exist(in_folder,'dir')
        mkdir(in_folder)
    else
        imds = imageDatastore(in_folder);
        return; % Skip if images already resized
    end
    reset(imds)
    
    while hasdata(imds)
        % Read an image
        [I,info] = read(imds);

        % Resize image
        I = imresize(I,[height width]); % resize the image to [408 306]

        % Write to disk
        [~, filename, ext] = fileparts(info.Filename);
        imwrite(I,[in_folder filename ext])
    end

    imds = imageDatastore(in_folder);
end
