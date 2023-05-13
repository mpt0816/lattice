function PlotBoundaries(boundaries)
    PlotBoundary(boundaries.lane_boundary, 'b-');
    hold on;
    
    PlotBoundary(boundaries.shoulder_boundary, 'k-');
    hold on;
    
    PlotBoundary(boundaries.obstacle_boundary, 'r-');
    
    legend('lane boundary', 'shoulder boundary', 'obstacle boundary');
end

