function region = PlotLanes(lanes)
min_x = [];
max_x = [];
min_y = [];
max_y = [];
for lane = lanes
    region_i = PlotLane(lane);
    min_x = [min_x, region_i.min_x];
    max_x = [max_x, region_i.max_x];
    min_y = [min_y, region_i.min_y];
    max_y = [max_y, region_i.max_y];
end
region.min_x = min(min_x);
region.max_x = max(max_x);
region.min_y = min(min_y);
region.max_y = max(max_y);

end