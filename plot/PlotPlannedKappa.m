function PlotPlannedKappa(path1, path2)

num_of_pts1 = length(path1);
num_of_pts2 = length(path2);

s1 = zeros(1, num_of_pts1);
beta1 = zeros(1, num_of_pts1);
kappa1 = zeros(1, num_of_pts1);

s2 = zeros(1, num_of_pts2);
beta2 = zeros(1, num_of_pts2);
kappa2 = zeros(1, num_of_pts2);

for i = 1 : 1 : num_of_pts1
    pt = path1(i);
    
    s1(1, i) = pt.s;
    beta1(1, i) = pt.beta;
    kappa1(1, i) = pt.kappa;
end

for i = 1 : 1 : num_of_pts2
    pt = path2(i);
    
    s2(1, i) = pt.s;
    beta2(1, i) = pt.beta;
    kappa2(1, i) = pt.kappa;
end

subplot(2, 1, 1);
plot(s1, kappa1, 'k-', 'LineWidth', 1.0);
hold on
plot(s2, kappa2, 'r-', 'LineWidth', 1.0);
xlabel('s(m)');
ylabel('\kappa');
legend('Traditional Methond', 'Tractrix Method');

subplot(2, 1, 2);
plot(s1, beta1, 'k-', 'LineWidth', 1.0);
hold on
plot(s2, beta2, 'r-', 'LineWidth', 1.0);
xlabel('s(m)');
ylabel('\beta');
legend('Traditional Methond', 'Tractrix Method');

end