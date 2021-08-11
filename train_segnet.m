clear;
clc;

%% Load the images
image_folder = fullfile('dataset\images');
imds = imageDatastore(image_folder);
disp('Loading images completed')

%% Define the class labels
classes = [    
    "Danger"
    "Background"
    ];
label_ids = pixel_label_ids();

%% Load the ground-truths
label_folder = fullfile('dataset\labels');
pxds = pixelLabelDatastore(label_folder, classes, label_ids);
disp('Loading labels completed')

%% Use 70% of the data for training, the rest for testing
[imds_train, imds_test, pxds_train, pxds_test] = partition_data(imds, pxds, 0.7);
disp('Creating training & test dataset completed')

%% Create the Network
input_shape = [504 368 3];
num_classes = numel(classes);
layers      = segnetLayers(input_shape, num_classes, 'vgg16');
disp('Creating the network completed')

%% Balance classes using class weighting
table      = countEachLabel(pxds);
image_freq = table.PixelCount ./ table.ImagePixelCount;
class_weights = median(image_freq) ./ image_freq;

%% Create a new pixel classification layer
pixel_layer = pixelClassificationLayer('Name', 'labels',...
                                       'ClassNames', table.Name,...
                                       'ClassWeights', class_weights);

%% Update the SegNet network with the new layer
layers = removeLayers(layers, 'pixelLabels');
layers = addLayers(layers, pixel_layer);
layers = connectLayers(layers, 'softmax' ,'labels');
disp('Updating the network completed')

%% Define training options
options = trainingOptions('sgdm', ...
    'Momentum', 0.9, ...
    'InitialLearnRate', 1e-3, ...
    'L2Regularization', 0.0005, ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 4, ...
    'Shuffle', 'every-epoch', ...
    'VerboseFrequency', 2);

%% Apply data augmentation
augmenter = imageDataAugmenter('RandXReflection',true,...
                'RandXTranslation', [-10 10], 'RandYTranslation',[-10 10]);

%% Train the network
datasource = pixelLabelImageSource(imds_train, pxds_train,...
                                   'DataAugmentation', augmenter);
[net, info] = trainNetwork(datasource, layers, options); % train a network from scratch