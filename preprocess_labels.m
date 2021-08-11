clear, clc;
in_folder = 'dataset (original)';
pattern   = fullfile(in_folder, '*.png');
files     = dir(pattern);

for k = 1 : length(files)
    filename = fullfile(in_folder, files(k).name);
    I = imread(filename);
    
    % Convert to RGB
    I = im2uint8(I);
    I = cat(3, I, I, I);
    
    % Pre-process the filename
    filename = erase(filename, '_');
    filename = erase(filename, 'danger');
    filename = strrep(filename, ' (original)', '\labels_rgb');
    
    % Save the pre-processed image
    imwrite(I, filename);
    disp(k);
end