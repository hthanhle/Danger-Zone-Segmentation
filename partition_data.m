function [imds_train, imds_test, pxds_train, pxds_test] = partition_data(imds, pxds, ratio)
    % Set initial random state for example reproducibility
    rng(0);
    num_files = numel(imds.Files);
    shuffledIndices = randperm(num_files);   
    n = round(ratio * num_files);
    train_idx = shuffledIndices(1:n);

    % Use the rest for testing
    test_idx = shuffledIndices(n+1 : end);

    % Create image datastores for training and test
    train_images = imds.Files(train_idx);
    test_images  = imds.Files(test_idx);
    imds_train   = imageDatastore(train_images);
    imds_test    = imageDatastore(test_images);

    % Extract class and label IDs info
    classes   = pxds.ClassNames;
    label_ids = 1 : numel(pxds.ClassNames);

    % Create pixel label datastores for training and test
    train_labels = pxds.Files(train_idx);
    test_labels  = pxds.Files(test_idx);
    pxds_train   = pixelLabelDatastore(train_labels, classes, label_ids);
    pxds_test    = pixelLabelDatastore(test_labels, classes, label_ids);
end
