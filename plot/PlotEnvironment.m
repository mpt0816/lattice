function region = PlotEnvironment(scenario)
    region = PlotLanes(scenario.lanes);
    hold on;
    PlotObstacles(scenario.obstacles);
end