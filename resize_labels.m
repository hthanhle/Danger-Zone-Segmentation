function pxds = resize_labels(pxds, in_folder, height, width)
    classes   = pxds.ClassNames;
    label_ids = 1 : numel(classes);
    if ~exist(in_folder,'dir')
        mkdir(in_folder)
    else
        pxds = pixelLabelDatastore(in_folder, classes, label_ids);
        return; % Skip if images already resized
    end
    reset(pxds)

    while hasdata(pxds)
        % Read the pixel data
        [C, info] = read(pxds);

        % Convert from categorical to uint8
        L = uint8(C);

        % Resize the data. Use 'nearest' interpolation to preserve label IDs
        L = imresize(L, [height width], 'nearest'); % Resize pixel label data to [408 306]

        % Write the data to disk.
        [~, filename, ext] = fileparts(info.Filename);
        imwrite(L, [in_folder filename ext])
    end

    label_ids = 1 : numel(classes);
    pxds = pixelLabelDatastore(in_folder, classes, label_ids);
end
