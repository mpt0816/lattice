function scenarios = Scenario()
    scenarios = [];
    
    %% scenario 1: 直道，没有障碍物
    scenario.name = 'scenario#1#straight-lane';
    key_points = KeyPointStraightPath();
    lane_generator = GenerateLane();
    lane_generator.SetShoulderHeight(0.1);
    scenario.lanes = lane_generator.GenerateThreeParallelLanes(key_points);
    scenario.key_points = key_points;
    
    obstacle_type = 'bus';
%     obstacle_type = 'car';
    num_of_obstacle = 0;
    invade = 0;
    obstacle_generator = GenerateObstacle(scenario.lanes(1), obstacle_type, num_of_obstacle, invade);
    scenario.obstacles = obstacle_generator.GetObstacles();
    
    scenarios = [scenarios, scenario];
    
end