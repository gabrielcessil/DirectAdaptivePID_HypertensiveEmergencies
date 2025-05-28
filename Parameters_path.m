win_3 = figure(3);  
win_3(1) = subplot(1, 3, 1); % Kc-Ki
win_3(2) = subplot(1, 3, 2); % Kc-Kd
win_3(3) = subplot(1, 3, 3); % Kd-Ki
set(win_3,'Nextplot','add');

win_2 = figure(2);  
win_2(1) = subplot(1, 3, 1); % c0-c1
win_2(2) = subplot(1, 3, 2); % c0-c2
win_2(3) = subplot(1, 3, 3); % c1-c2
set(win_2,'Nextplot','add');

for i=1:length(Kc_estimations_2)
    plot(win_3(1),Kc_estimations_2{i}.data,Ki_estimations_2{i}.data, 'Color',[1, 0, 0, 0.2]);
    plot(win_3(2),Kc_estimations_2{i}.data,Kd_estimations_2{i}.data, 'Color',[1, 0, 0, 0.2]);
    plot(win_3(3),Ki_estimations_2{i}.data,Kd_estimations_2{i}.data, 'Color',[1, 0, 0, 0.2]);
    
    plot(win_3(1),Kc_estimations_2{i}.data(end),Ki_estimations_2{i}.data(end),"o");
    plot(win_3(2),Kc_estimations_2{i}.data(end),Kd_estimations_2{i}.data(end),"o");
    plot(win_3(3),Ki_estimations_2{i}.data(end),Kd_estimations_2{i}.data(end),"o");
    
    plot(win_2(1),c0_2{i}.data,c1_2{i}.data, 'Color',[1, 0, 0, 0.2]);
    plot(win_2(2),c0_2{i}.data,c2_2{i}.data, 'Color',[1, 0, 0, 0.2]);
    plot(win_2(3),c2_2{i}.data,c1_2{i}.data, 'Color',[1, 0, 0, 0.2]);
    
    plot(win_2(1),c0_2{i}.data(end),c1_2{i}.data(end),"o");
    plot(win_2(2),c0_2{i}.data(end),c2_2{i}.data(end),"o");
    plot(win_2(3),c2_2{i}.data(end),c1_2{i}.data(end),"o");
end
%{
legend(win_2(1),"K_{p}");
title(win_2(1),"Estimações para Perfil P.1");
xlabel(win_2(1),'time (s)');
ylabel(win_2(1),'output');
grid(win_2(1),'on');
grid(win_2(1),'minor');
xlim(win_2(1),[0 simuTime]);
%}