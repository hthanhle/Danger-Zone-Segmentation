function pixel_label_color_bar(cmap, class_labels)
    % Add a colorbar to the current axis. The colorbar is formatted
    % to display the class names with the color

    colormap(gca,cmap)

    % Add colorbar to current figure
    c = colorbar('peer', gca);

    % Use class names for tick marks
    c.TickLabels = class_labels;
    num_classes  = size(cmap,1);

    % Center tick labels
    c.Ticks = 1/(num_classes*2) : 1/num_classes : 1;

    % Remove tick mark.
    c.TickLength = 0;
end
