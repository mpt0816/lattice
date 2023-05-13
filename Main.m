clc; clear all; close all;

%% 添加路径
current_folder = pwd;
addpath(genpath(current_folder));

%% 生成测试场景
scenarios = Scenario();

for scenario = scenarios
    
    %% 生成规划器并求解
    
    planner = LatticePlanner(scenario.lanes(2), scenario.lanes(1).center_line(1));
    path = planner.Plan(false);
    
    path1 = path;
    
    subplot(2,1,1);
    region = PlotEnvironment(scenario);
    PlotPlannedPathArea(path, 1.0, 0.0);
    PlotTruckArea(path(end - 12), true, 1.0, 1.0);
    PlotTrajectoryLine(path, true, true, true);
    
    legend_buffer = 20.0;
    if strcmp(scenario.name, 'scenario#11#S-turn') || strcmp(scenario.name, 'scenario#12#S-turn')
        legend_buffer = legend_buffer + 30.0;
    end
    set(gca, 'XLim', [region.min_x, region.max_x]);
    set(gca, 'YLim', [region.min_y, region.max_y + legend_buffer]);
    xlabel('x(m)');
    ylabel('y(m)');
    text(20, 12, 'OverShot By Traditional Method', 'FontSize', 10);
    legend({'Tractor Body', 'Trailer Body', 'Tractor Path', 'Trailer Path'}, ...
        'Location','northeast', 'FontSize', 8);
    axis equal;
    
    path = planner.Plan(true);
    path2 = path;
     
    subplot(2,1,2);
    region = PlotEnvironment(scenario);
    PlotPlannedPathArea(path, 1.0, 0.0);
    PlotTruckArea(path(end - 12), true, 1.0, 1.0);
    PlotTrajectoryLine(path, true, true, true);
    
    legend_buffer = 20.0;
    if strcmp(scenario.name, 'scenario#11#S-turn') || strcmp(scenario.name, 'scenario#12#S-turn')
        legend_buffer = legend_buffer + 30.0;
    end
    set(gca, 'XLim', [region.min_x, region.max_x]);
    set(gca, 'YLim', [region.min_y, region.max_y + legend_buffer]);
    xlabel('x(m)');
    ylabel('y(m)');
    text(20, 12, 'No OverShot By Tractrix Method', 'FontSize', 10);
    legend({'Tractor Body', 'Trailer Body', 'Tractor Path', 'Trailer Path'}, ...
        'Location','northeast', 'FontSize', 8);
    axis equal;
    
    figure;
    PlotPlannedKappa(path1, path2);
    
    Analyse(path1, path2);
    
    y = scenario.lanes(2).center_line(1).y;
    disp(strcat('目标车道中心线y =  ', 32, num2str(y)));
    
    width = GetTruckParams().tractor.width / 2.0;
    disp(strcat('车宽 =  ', 32, num2str(width)));
    
%     MakePathPlanGif2(scenario, path1, path2, current_folder)
end