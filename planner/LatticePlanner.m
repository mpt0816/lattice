classdef LatticePlanner < handle
    %UNTITLED2 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        reference_line_;
        start_point_;
        truck_param_;
    end
    
    methods
        function obj = LatticePlanner(traget_lane, start_point)
            obj.reference_line_ = traget_lane.center_line;
            obj.start_point_ = start_point;
            obj.truck_param_ = GetTruckParams();
        end
        
        function pt_front = InferFrontAxeCenterFromRearAxeCenter(obj, pt_rear)
            pt_front = pt_rear;
            tractor_wheel_base = obj.truck_param_.tractor.wheel_base;
            pt_front.x = pt_rear.x + tractor_wheel_base * cos(pt_rear.theta);
            pt_front.y = pt_rear.y + tractor_wheel_base * sin(pt_rear.theta);
            pt_front.s = pt_rear.s + tractor_wheel_base;
        end
        
        function path = Plan(obj, use_front)
            start_point = obj.start_point_;
            if use_front
                start_point = obj.InferFrontAxeCenterFromRearAxeCenter(start_point);
            end
            
            lane_change_length = 80;
            start_state = [0.0, 0.0, 0.0];
            end_state = [0.3, 0.0, 0.0];
            
            sl_curve = QuinticPolynomialCurve1d(start_state(1), start_state(2), start_state(3), ...
                                                end_state(1), end_state(2), end_state(3), lane_change_length);
            
            path = obj.FromFrenetToPath(start_point.s, sl_curve);
            
            if use_front
                path = obj.ConvertPathPointRefFromFrontAxeToRearAxe(start_point, path);
            end
            
            path = obj.UpdateBeta(path);
        end
        
        function path = FromFrenetToPath(obj, start_s, sl_curve)
            length = obj.reference_line_(end).s;
            kLenghtResolution = 0.5;
            s = 0;
            path = [];
            while s < length
                d = sl_curve.Evaluate(0, s);
                d_p = sl_curve.Evaluate(1, s);
                d_pp = sl_curve.Evaluate(2, s);
                
                match_point = obj.GetPathPointByS(s + start_s);
                
                rs = match_point.s;
                rx = match_point.x;
                ry = match_point.y;
                rtheta = match_point.theta;
                rkappa = match_point.kappa;
                rdkappa = match_point.dkappa;
                
                s_conditions = [rs, 0.0, 0.0];
                d_conditions = [d, d_p, d_pp];
                
                [pt.x, pt.y, pt.theta, pt.kappa] = obj.frenet_to_cartesian(rs, rx, ry, rtheta, rkappa, rdkappa, s_conditions, d_conditions);
                pt.s = s;
                s = s + kLenghtResolution;
                path = [path, pt];
            end
        end
        
        function  match_point = GetPathPointByS(obj, s)
            num = length(obj.reference_line_);
            index = 1;
            for i = 1 : 1 : num
                if obj.reference_line_(i).s >= s
                    index = i;
                    break;
                end
            end
            if obj.reference_line_(end).s < s
                index = num;
            end
            front_index = max(1, index - 1);
            match_point = obj.InterpolateUsingLinearApproximation(obj.reference_line_(front_index), obj.reference_line_(index), s);
        end
        
        function path_point = InterpolateUsingLinearApproximation(obj, p0, p1, s)
            s0 = p0.s;
            s1 = p1.s;
            if abs(s1 - s0) < 1e-5
                path_point = p0;
                return;
            end
            
            weight = (s - s0) / (s1 - s0);
            path_point.x = (1 - weight) * p0.x + weight * p1.x;
            path_point.y = (1 - weight) * p0.y + weight * p1.y;
            path_point.theta = (1 - weight) * p0.theta + weight * p1.theta;
            path_point.kappa = (1 - weight) * p0.kappa + weight * p1.kappa;
            path_point.dkappa = (1 - weight) * p0.dkappa + weight * p1.dkappa;
            path_point.s = s;
        end
        
        function [x, y, theta, kappa] = frenet_to_cartesian(obj, rs, rx, ry, rtheta, rkappa, rdkappa, s_condition, d_condition)
            cos_theta_r = cos(rtheta);
            sin_theta_r = sin(rtheta);
            
            x = rx - sin_theta_r * d_condition(1);
            y = ry + cos_theta_r * d_condition(1);
            
            one_minus_kappa_r_d = 1 - rkappa * d_condition(1);
            
            tan_delta_theta = d_condition(2) / one_minus_kappa_r_d;
            delta_theta = atan2(d_condition(2), one_minus_kappa_r_d);
            cos_delta_theta = cos(delta_theta);
            
            theta = NormalizeAngle(delta_theta + rtheta);
            
            kappa_r_d_prime = rdkappa * d_condition(1) + rkappa * d_condition(2);
            kappa = (((d_condition(3) + kappa_r_d_prime * tan_delta_theta) * ...
                cos_delta_theta * cos_delta_theta) / ...
                (one_minus_kappa_r_d) + ...
                rkappa) * cos_delta_theta / (one_minus_kappa_r_d);
        end
        
        function new_path = ConvertPathPointRefFromFrontAxeToRearAxe(obj, start_point, path)
            new_path = [];
            front_to_rear_axe_distance = obj.truck_param_.tractor.wheel_base;
            heading_rear_axe = start_point.theta;
            last_front_axe_point = path(1);
            i = 0;
            last_path_point = start_point;
            
            for path_point = path 
                if i == 0
                    last_front_axe_point = path_point;
                    path_point.theta = heading_rear_axe;
                    path_point.x = path_point.x - front_to_rear_axe_distance * cos(path_point.theta);
                    path_point.y = path_point.y - front_to_rear_axe_distance * sin(path_point.theta);
                    path_point.kappa = start_point.kappa;
                    path_point.dkappa = start_point.dkappa;
                else 
                    delta_s = hypot(path_point.x - last_front_axe_point.x, path_point.y - last_front_axe_point.y);
                    heading_rear_axe = heading_rear_axe + sin(path_point.theta - heading_rear_axe) / front_to_rear_axe_distance * delta_s;
                    last_front_axe_point = path_point;
                    path_point.theta = NormalizeAngle(heading_rear_axe);
                    path_point.x = path_point.x - front_to_rear_axe_distance * cos(path_point.theta);
                    path_point.y = path_point.y - front_to_rear_axe_distance * sin(path_point.theta);
                    delta_s_rear_axe = hypot(last_path_point.x - path_point.x, last_path_point.y - path_point.y);
                    path_point.kappa = NormalizeAngle(path_point.theta - last_path_point.theta) / delta_s_rear_axe;
                    path_point.dkappa = (path_point.kappa - path_point.kappa) / delta_s_rear_axe;
                end
                last_path_point = path_point;
                new_path = [new_path, path_point];
                i = i + 1;
            end
        end
        
        function new_path = UpdateBeta(obj, path)
            new_path = [];
            num = length(path);
            last_theta = path(1).theta;
            params = GetTruckParams();
            for i = 1 : 1 : num
                rf_pt = path(i);
                pt = rf_pt;
                pt.kappa = rf_pt.kappa;
                if i == 1
                    theta = path.theta;
                    pt.beta = 0.0;
                else
                    theta = last_theta + 0.5 * sin(rf_pt.theta - last_theta) / params.trailer.wheel_base;
                    pt.beta = NormalizeAngle(theta - rf_pt.theta);
                end
                last_theta = theta;
                new_path = [new_path, pt];
            end
        end
       
    end
end

