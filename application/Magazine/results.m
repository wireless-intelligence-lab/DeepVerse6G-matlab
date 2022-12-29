%%
set(0,'defaultLineLineWidth', 2)
set(0,'defaultAxesFontSize',11)
set(0,'defaultAxesFontName','Arial')
set(0,'defaultAxesLineWidth', 1)

%%
barcolors = validatecolor({'#0072BD', '#D95319', '#EDB120'}, 'multiple');

r = [0.4437, 0.4609, 0.4951];
l = categorical(["Position Baseline", "Position DL", "Position+Image DL"]);
for i = 1:3
    bar1 = bar(l(i), r(i), 0.5, FaceColor=barcolors(i, :), LineWidth=1);
    hold on
end
grid minor;
ylim([0.3, 0.6])
ylabel('Beam Prediction Accuracy')

% for i = 1:3
%     bar1.CData(i,:) = barcolors(i, :)
%     %set(bar1(i), 'FaceColor', barcolors(i, :), 'LineWidth', 1);
% end