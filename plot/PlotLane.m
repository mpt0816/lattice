function region = PlotLane(lane)
center_x = [];
center_y = [];
left_boundary_x = [];
left_boundary_y = [];
right_boundary_x = [];
right_boundary_y = [];

center_line = lane.center_line;
for pt = center_line
    center_x = [center_x, pt.x];
    center_y = [center_y, pt.y];
end

left_boundary = lane.left_boundary;
for pt = left_boundary
    left_boundary_x = [left_boundary_x, pt.x];
    left_boundary_y = [left_boundary_y, pt.y];
end

right_boundary = lane.right_boundary;
for pt = right_boundary
    right_boundary_x = [right_boundary_x, pt.x];
    right_boundary_y = [right_boundary_y, pt.y];
end

road_color = [190 190 190] / 255; %% grey
road_boundary_color = [255 165 0] / 255; %% orange
p1 = fill([left_boundary_x, flip(right_boundary_x)], [left_boundary_y, flip(right_boundary_y)], road_color);
set(p1,'edgealpha',0);
set(p1, 'handlevisibility', 'off');
hold on;

if center_y(1) > 1
    left_region_shoudler = PlotShoulder(lane.left_shoulder);
    hold on;
    
    boundary = plot(left_boundary_x, left_boundary_y, 'w-', 'LineWidth', 1.0);
    set(boundary, 'handlevisibility', 'off');
    hold on;
    
    boundary = plot(right_boundary_x, right_boundary_y, 'w--', 'LineWidth', 1.0);
    set(boundary, 'handlevisibility', 'off');
else
    right_region_shoudler = PlotShoulder(lane.right_shoulder);
    hold on;
    
    boundary = plot(left_boundary_x, left_boundary_y, 'w--', 'LineWidth', 1.0);
    set(boundary, 'handlevisibility', 'off');
    hold on;
    
    boundary = plot(right_boundary_x, right_boundary_y, 'w-', 'LineWidth', 1.0);
    set(boundary, 'handlevisibility', 'off');
end


region.min_x = min([min(center_x), min(left_boundary_x), min(right_boundary_x)]);
region.max_x = max([max(center_x), max(left_boundary_x), max(right_boundary_x)]);
region.min_y = min([min(center_y), min(left_boundary_y), min(right_boundary_y)]);
region.max_y = max([max(center_y), max(left_boundary_y), max(right_boundary_y)]);

axis equal;
xlabel('x(m)');
ylabel('y(m)');
end

