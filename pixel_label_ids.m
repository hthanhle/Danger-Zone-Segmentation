function label_ids = pixel_label_ids()
    % Return the label IDs corresponding to each class
    label_ids = { ...
        [
            255 255 255; % danger: white regions in the ground-truths
        ]  
        [
            000 000 000; % background: back regions
        ]
        };
end