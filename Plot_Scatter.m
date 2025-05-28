PSSmax = 50;
TAmax = 8000;
Estimador = 2;

if Estimador == 1
    PSS_amostras = PSS_amostras_1;
    TA_amostras = TA_amostras_1;
elseif Estimador == 2
    PSS_amostras = PSS_amostras_2;
    TA_amostras = TA_amostras_2;
else
    PSS_amostras = PSS_amostras_3;
    TA_amostras = TA_amostras_3;
end

win_1 = figure(1);
win_1(1) = subplot(2, 2, 1);
win_1(2) = subplot(2, 2, 2);
win_1(3) = subplot(2, 2, 3);
win_1(4) = subplot(2, 2, 4);
set(win_1,'Nextplot','add');

win_2 = figure(2);
win_2(1) = subplot(2, 2, 1);
win_2(2) = subplot(2, 2, 2);
win_2(3) = subplot(2, 2, 3);
win_2(4) = subplot(2, 2, 4);
set(win_2,'Nextplot','add');



scatter(win_1(1),PSS_amostras(1,:), TA_amostras(1,:),'filled');
scatter(win_1(1),PSS_maximo(1,Estimador), TA_maximo(1,Estimador),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"y",...
                'LineWidth',1.5)
scatter(win_1(1),mean(PSS_amostras(1,:)), mean(TA_amostras(1,:)),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"r",...
                'LineWidth',1.5)
ylim(win_1(1), [0 TAmax]);
xlim(win_1(1), [0 PSSmax]);
xlabel(win_1(1),'PSS (mmHg)');
ylabel(win_1(1),'TA (s)');
grid(win_1(1),'minor');
title(win_1(1), "Perfil P.1");


scatter(win_1(2),PSS_amostras(2,:), TA_amostras(2,:),'filled');
scatter(win_1(2),PSS_maximo(2,Estimador), TA_maximo(2,Estimador),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"y",...
                'LineWidth',1.5)
scatter(win_1(2),mean(PSS_amostras(2,:)), mean(TA_amostras(2,:)),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"r",...
                'LineWidth',1.5)
ylim(win_1(2), [0 TAmax]);
xlim(win_1(2), [0 PSSmax]);
xlabel(win_1(2),'PSS (mmHg)');
ylabel(win_1(2),'TA (s)');
grid(win_1(2),'minor');
title(win_1(2), "Perfil P.2");


scatter(win_1(3),PSS_amostras(3,:), TA_amostras(3,:),'filled');
scatter(win_1(3),PSS_maximo(3,Estimador), TA_maximo(3,Estimador),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"y",...
                'LineWidth',1.5)
scatter(win_1(3),mean(PSS_amostras(3,:)), mean(TA_amostras(3,:)),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"r",...
                'LineWidth',1.5)
ylim(win_1(3), [0 TAmax]);
xlim(win_1(3), [0 PSSmax]);
xlabel(win_1(3),'PSS (mmHg)');
ylabel(win_1(3),'TA (s)');
grid(win_1(3),'minor');
title(win_1(3), "Perfil P.3");

scatter(win_1(4),PSS_amostras(4,:), TA_amostras(4,:),'filled');
scatter(win_1(4),PSS_maximo(4,Estimador), TA_maximo(4,Estimador),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"y",...
                'LineWidth',1.5)
scatter(win_1(4),mean(PSS_amostras(4,:)), mean(TA_amostras(4,:)),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"r",...
                'LineWidth',1.5)
ylim(win_1(4), [0 TAmax]);
xlim(win_1(4), [0 PSSmax]);
xlabel(win_1(4),'PSS (mmHg)');
ylabel(win_1(4),'TA (s)');
grid(win_1(4),'minor');
title(win_1(4), "Perfil P.4");


scatter(win_2(1),PSS_amostras(5,:), TA_amostras(5,:),'filled');
scatter(win_2(1),PSS_maximo(5,Estimador), TA_maximo(5,Estimador),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"y",...
                'LineWidth',1.5)
scatter(win_2(1),mean(PSS_amostras(5,:)), mean(TA_amostras(5,:)),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"r",...
                'LineWidth',1.5)
ylim(win_2(1), [0 TAmax]);
xlim(win_2(1), [0 PSSmax]);
xlabel(win_2(1),'PSS (mmHg)');
ylabel(win_2(1),'TA (s)');
grid(win_2(1),'minor');
title(win_2(1), "Perfil P.5");


scatter(win_2(2),PSS_amostras(6,:), TA_amostras(6,:),'filled');
scatter(win_2(2),PSS_maximo(6,Estimador), TA_maximo(6,Estimador),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"y",...
                'LineWidth',1.5)
ylim(win_2(2), [0 TAmax]);
xlim(win_2(2), [0 PSSmax]);
xlabel(win_2(2),'PSS (mmHg)');
ylabel(win_2(2),'TA (s)');
grid(win_2(2),'minor');
scatter(win_2(2),mean(PSS_amostras(6,:)), mean(TA_amostras(6,:)),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"r",...
                'LineWidth',1.5)
title(win_2(2), "Perfil P.6");

            
scatter(win_2(3),PSS_amostras(7,:), TA_amostras(7,:),'filled');
scatter(win_2(3),PSS_maximo(7,Estimador), TA_maximo(7,Estimador),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"y",...
                'LineWidth',1.5)
scatter(win_2(3),mean(PSS_amostras(7,:)), mean(TA_amostras(7,:)),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"r",...
                'LineWidth',1.5)
ylim(win_2(3), [0 TAmax]);
xlim(win_2(3), [0 PSSmax]);
xlabel(win_2(3),'PSS (mmHg)');
ylabel(win_2(3),'TA (s)');
grid(win_2(3),'minor');
title(win_2(3), "Perfil P.7");

scatter(win_2(4),PSS_amostras(8,:), TA_amostras(8,:),'filled');
scatter(win_2(4),PSS_maximo(8,Estimador), TA_maximo(8,Estimador),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"y",...
                'LineWidth',1.5)
scatter(win_2(4),mean(PSS_amostras(8,:)), mean(TA_amostras(8,:)),120,...
                'MarkerEdgeColor',"k",...
                'MarkerFaceColor',"r",...
                'LineWidth',1.5)
ylim(win_2(4), [0 TAmax]);
xlim(win_2(4), [0 PSSmax]);
xlabel(win_2(4),'PSS (mmHg)');
ylabel(win_2(4),'TA (s)');
grid(win_2(4),'minor');
title(win_2(4), "Perfil P.8");

legend(win_1(1), 'northwest',{"Amostras","Máximo aferido","Médio"});
legend(win_1(2), 'northwest',{"Amostras","Máximo aferido","Médio"});
legend(win_1(3), 'northwest',{"Amostras","Máximo aferido","Médio"});
legend(win_1(4), 'northwest',{"Amostras","Máximo aferido","Médio"});
legend(win_2(1), 'northwest',{"Amostras","Máximo aferido","Médio"});
legend(win_2(2), 'northwest',{"Amostras","Máximo aferido","Médio"});
legend(win_2(3), 'northwest',{"Amostras","Máximo aferido","Médio"});
legend(win_2(4), 'northwest',{"Amostras","Máximo aferido","Médio"});

disp(PSS_maximo);
disp(TA_maximo);
