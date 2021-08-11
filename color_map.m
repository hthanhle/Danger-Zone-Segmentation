function cmap = color_map()
    cmap = [    
            255 0 0     % danger: red color
            128 128 128 % background: gray color
        ];

    % Normalize between [0 1].
    cmap = cmap ./ 255;
end