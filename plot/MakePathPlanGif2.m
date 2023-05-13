function MakePathPlanGif2(scenario, path1, path2, file_path)
    
    gif_name = strcat(scenario.name,  '.gif');
    png_name = strcat(scenario.name,  '.png');
    
    legend_buffer = 20.0;
    if strcmp(scenario.name, 'scenario#11#S-turn') || strcmp(scenario.name, 'scenario#12#S-turn')
        legend_buffer = legend_buffer + 30.0;
    end
    
    step = 1;
    path_length = length(path1);
    for frame = 1 : 3 : path_length
        close all;
        
        path = path1(1 : frame);
        
        subplot(2,1,1);
        region = PlotEnvironment(scenario);
        PlotPlannedPathArea(path, 1.0, 0.0);
        PlotTruckArea(path(end), true, 1.0, 1.0);
        PlotTrajectoryLine(path, true, true, true);
        
        set(gca, 'XLim', [region.min_x, region.max_x]);
        set(gca, 'YLim', [region.min_y, region.max_y + legend_buffer]);
        xlabel('x(m)');
        ylabel('y(m)');
        text(20, 12, 'OverShot By Traditional Method', 'FontSize', 10);
        legend({'Road Center', 'Tractor Body', 'Trailer Body', 'Tractor Path', 'Trailer Path'}, ...
            'Location','northeast', 'FontSize', 8);
        axis equal;
        %         axis off;
        
        path = path2(1 : frame);
        
        subplot(2,1,2);
        region = PlotEnvironment(scenario);
        PlotPlannedPathArea(path, 1.0, 0.0);
        PlotTruckArea(path(end), true, 1.0, 1.0);
        PlotTrajectoryLine(path, true, true, true);
        
        set(gca, 'XLim', [region.min_x, region.max_x]);
        set(gca, 'YLim', [region.min_y, region.max_y + legend_buffer]);
        xlabel('x(m)');
        ylabel('y(m)');
        text(20, 12, 'No OverShot By Tractrix Method', 'FontSize', 10);
        legend({'Road Center', 'Tractor Body', 'Trailer Body', 'Tractor Path', 'Trailer Path'}, ...
            'Location','northeast', 'FontSize', 8);
        axis equal;
%         axis off;
        %% make gif
        pause(0.05);
        MakeGif([file_path, '\figure\', gif_name], step);
        step = step + 1;
    end
    saveas(gcf, [file_path, '\figure\', png_name]);
    close all;
end