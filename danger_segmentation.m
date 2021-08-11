function I = danger_segmentation(net, input_image)
    % Perform segmentation on the input image
    I    = semanticseg(input_image, net);
    
    % Output the result
    cmap = color_map;
    I    = labeloverlay(input_image, I, 'ColorMap', cmap);
end

