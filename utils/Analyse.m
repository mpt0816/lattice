function Analyse(path1, path2)
    
    [min_y_1, max_y_1] = LateralAnalyse(path1);
    [min_kappa_1, max_kappa_1] = KappaAnalyse(path1);
    [min_beta_1, max_beta_1] = BetaAnalyse(path1);
    
    [min_y_2, max_y_2] = LateralAnalyse(path2);
    [min_kappa_2, max_kappa_2] = KappaAnalyse(path2);
    [min_beta_2, max_beta_2] = BetaAnalyse(path2);
    
    disp(strcat('min_y_1 ', 32, num2str(min_y_1)));
    disp(strcat('max_y_1 ', 32, num2str(max_y_1)));
    disp(strcat('min_kappa_1 ', 32, num2str(min_kappa_1)));
    disp(strcat('max_kappa_1 ', 32, num2str(max_kappa_1)));
    disp(strcat('min_beta_1 ', 32, num2str(min_beta_1)));
    disp(strcat('max_beta_1 ', 32, num2str(max_beta_1)));
    
    disp(strcat('min_y_2 ', 32, num2str(min_y_2)));
    disp(strcat('max_y_2 ', 32, num2str(max_y_2)));
    disp(strcat('min_kappa_2 ', 32, num2str(min_kappa_2)));
    disp(strcat('max_kappa_2 ', 32, num2str(max_kappa_2)));
    disp(strcat('min_beta_2 ', 32, num2str(min_beta_2)));
    disp(strcat('max_beta_2 ', 32, num2str(max_beta_2)));
    
    overshoot_1 = max_y_1 - 3.75 - 1.275;
    overshoot_2 = max_y_2 - 3.75 - 1.275;
    
    overshoot_1_per = overshoot_1 / 1.275 * 100;
    overshoot_2_per = overshoot_2 / 1.275 * 100;
    disp(strcat('overshoot_1 = ', 32, num2str(overshoot_1)));
    disp(strcat('overshoot_2 = ', 32, num2str(overshoot_2)));
    disp(strcat('overshoot_1_per = ', 32, num2str(overshoot_1_per)));
    disp(strcat('overshoot_2_per = ', 32, num2str(overshoot_2_per)));
    
    function [min_kappa, max_kappa] = KappaAnalyse(path)
        kappa = [];
        for pt = path
            kappa = [kappa, pt.kappa];
        end
        min_kappa = min(kappa);
        max_kappa = max(kappa);
    end

    function [min_beta, max_beta] = BetaAnalyse(path)
        beta = [];
        for pt = path
            beta = [beta, pt.beta];
        end
        min_beta = min(beta);
        max_beta = max(beta);
    end
 

    function [min_y, max_y] = LateralAnalyse(path)
        y = [];
        params = GetTruckParams();
        tractor = params.tractor;
        for pt = path
            tractor_coners = CalculateConersFromRearPoint(pt, tractor);
            y = [y, tractor_coners(1).y, tractor_coners(2).y, tractor_coners(3).y, tractor_coners(4).y];
        end
        min_y = min(y);
        max_y = max(y);
    end
    

end