% Configuracoes gerais da simulacao
simuTime = 14000; % Tempo de simulação
T = 15; % Tempo de amostragem do controlador
Instante_habilita_controlador = 30; % Instante apos transitorio do modelo
Amplitude_perturbacao = 0; % Valor somado ao offset
Instante_habilita_perturbacao = 3*60*60;
setpoint_inicial = 131; % Referencia inicial
setpoint_final = 116; % Referencia final 140 ~ 100
Criterio_Acomodacao = 15; % Criterio para definir momento de acomodacao


% Configuracoes do controlador DIRAC
Constante_tempo_referencia = 75*4; % Constante de tempo da malha de     referencia (Tau_max*3)
Tempo_de_acomodacao = Constante_tempo_referencia*4; % Tempo de acomodacao do modelo de referencia
Tempo_Segundo_Step = 30*60; % Referencia de controle - Settling time minimo
ar = exp(-T/Constante_tempo_referencia); % Parametro de velocidade da malha de referencia
d = 5; % Parametro de atraso da malha de referencia, superestimado em 1(multiplo de h nominal);
saida_inicial_maxima = 0; % Estimacao de saida maxima inicial da planta
comando_inicial = 0; % Comando inicial do controlador

% Configuracoes do estimador
P_inicial = [0.01 0 0; 0 0.001 0 ; 0 0 1]; % Matriz Covariancia inicial
T_forgetting = Tempo_de_acomodacao; % Horizonte de tempo de memoria (Estimador 1 2)
forgetting_factor = exp(-T/T_forgetting); % Fator de esquecimento (Estimador 1 2)

% Lambda Tuning para
K_lambdaTuning = 9; % K = 0.25 ~ 9
L_lambdaTuning = 60; % L = 20 ~60
Tau_lambdaTuning = 75; % Tau = 30 ~ 75
Tcl_lambdaTuning = Constante_tempo_referencia;

Kp_inicial =  -0.001*Tau_lambdaTuning/(K_lambdaTuning*(Tau_lambdaTuning+Tcl_lambdaTuning));
Ti_inicial =  0.001*Tau_lambdaTuning;
Td_inicial =  0;

% Calculo de configuracoes dos algoritmos de controle
c0_inicial = Kp_inicial*(1+T/Ti_inicial+Td_inicial/T);
c1_inicial = -Kp_inicial*(1+2*(Td_inicial/T));
c2_inicial = Kp_inicial*(Td_inicial/T);
theta_inicial = [c0_inicial; c1_inicial; c2_inicial];

%---------------- DEFINE PACIENTE 
% Configuracoes do modelo
Parametros_Paciente = {...
    'ID',... % Identificador do paciente
    'K',... % Ganho de pressao em resposta ao medicamento
    'Tau',... % Constante de tempo 
    'Tau_i',...  % Constante de atraso para transporte do medicamento  
    'Tau_c',... % Constante de atraso por recirculação 
    'alpha',... % Fracao de recirculacao 
    'ba_frequencia_seno',... % Frequencia da senoide de background
    'ba_offset',... % Pressão arterial de offset
    'ba_amplitude_seno',... % Amplitude da senoidal de background
    'ba_ganho_estocastico',... % Ganho da atividade estocastica 
    'ba_limiar_reflexo' % Pressao limiar para atividade de reflexo
    };
Pacientes = Get_Pacientes(Parametros_Paciente); 
Pacientes = {Pacientes{1},Pacientes{4},Pacientes{8}};
semente_ruido = 2;


% DIRAC c/ ESTIMADOR 2:
%{
win_1 = figure(1); % Saida
set(win_1, 'WindowState', 'maximized'); % Maximize the figure window
set(win_1, 'Units', 'inches', 'Position', [0, 0, figure_width, figure_height])
win_1(1) = subplot(3, 1, 1); %Estimador 1
win_1(2) = subplot(3, 1, 2); %Estimador 2
win_1(3) = subplot(3, 1, 3); %Estimador 3
set(win_1,'Nextplot','add');

win_2 = figure(2); % Entrada
set(win_2, 'WindowState', 'maximized'); % Maximize the figure window
set(win_2, 'Units', 'inches', 'Position', [0, 0, figure_width, figure_height])
win_2(1) = subplot(3, 1, 1); %Estimador 1
win_2(2) = subplot(3, 1, 2); %Estimador 2
win_2(3) = subplot(3, 1, 3); %Estimador 3
set(win_2,'Nextplot','add');

j =1;
%}
for i=1:length(Pacientes)

    K = Pacientes{i}('K'); % Ganho de pressao em resposta ao medicamento
    Tau = Pacientes{i}('Tau'); % Constante de tempo 
    Tau_i = Pacientes{i}('Tau_i');5; % Constante de atraso para transporte do medicamento  
    Tau_c = Pacientes{i}('Tau_c'); % Constante de atraso por recirculação 
    alpha = Pacientes{i}('alpha'); % Fracao de recirculacao 
    ba_frequencia_seno = Pacientes{i}('ba_frequencia_seno'); % Frequencia da senoide de background
    ba_offset = Pacientes{i}('ba_offset'); % Pressão arterial de offset
    ba_amplitude_seno = Pacientes{i}('ba_amplitude_seno'); % Amplitude da senoidal de background
    ba_ganho_estocastico = Pacientes{i}('ba_ganho_estocastico'); % Ganho da atividade estocastica
    ba_limiar_reflexo = Pacientes{i}('ba_limiar_reflexo'); % Pressao limiar para atividade de reflexo

    simu_Controlador_1 = sim('Verificacao_Controle_Pressao_1','StopTime', sprintf('%.6f',simuTime));
    saida_planta_1 = simu_Controlador_1.saida;
    entrada_planta_1 = simu_Controlador_1.entrada_planta;
    saida_referencia_1 = simu_Controlador_1.saida_referencia;
    theta_1 = simu_Controlador_1.theta;
    referencia_1  = simu_Controlador_1.referencia;
    
    simu_Controlador_2 = sim('Verificacao_Controle_Pressao_2','StopTime', sprintf('%.6f',simuTime));
    saida_planta_2 = simu_Controlador_2.saida;
    entrada_planta_2 = simu_Controlador_2.entrada_planta;
    saida_referencia_2 = simu_Controlador_2.saida_referencia;
    theta_2 = simu_Controlador_2.theta;
    referencia_2  = simu_Controlador_2.referencia;
    
    simu_Controlador_3 = sim('Verificacao_Controle_Pressao_3','StopTime', sprintf('%.6f',simuTime));
    saida_planta_3 = simu_Controlador_3.saida;
    entrada_planta_3 = simu_Controlador_3.entrada_planta;
    saida_referencia_3 = simu_Controlador_3.saida_referencia;
    theta_3 = simu_Controlador_3.theta;
    referencia_3  = simu_Controlador_3.referencia;
    
    
    plot(win_1(1),saida_planta_1.time, saida_planta_1.data,'LineWidth',1.25);
    plot(win_1(2),saida_planta_2.time, saida_planta_2.data,'LineWidth',1.25);
    plot(win_1(3),saida_planta_3.time, saida_planta_3.data,'LineWidth',1.25);
        
    
    plot(win_2(1),entrada_planta_1.time, entrada_planta_1.data,'LineWidth',1.75);
    plot(win_2(2),entrada_planta_2.time, entrada_planta_2.data,'LineWidth',1.75);
    plot(win_2(3),entrada_planta_3.time, entrada_planta_3.data,'LineWidth',1.75);
    
end 

[OS_1,US_1,TA_1,ESS_1] = Metricas(saida_planta_1.time,saida_planta_1.data,setpoint_final,Instante_habilita_controlador); 
[OS_2,US_2,TA_2,ESS_2] = Metricas(saida_planta_2.time,saida_planta_2.data,setpoint_final,Instante_habilita_controlador); 
[OS_3,US_3,TA_3,ESS_3] = Metricas(saida_planta_3.time,saida_planta_3.data,setpoint_final,Instante_habilita_controlador); 


        
ymax = 155;

plot(win_1(1),referencia_1.time, referencia_1.data,'k--','LineWidth',1.5);
plot(win_1(1),saida_referencia_1.time, saida_referencia_1.data,'k','LineWidth',1);
legend(win_1(1),{...
    "P.1 output",...
    "P.4 output",...
    "P.8 output",...
    "Reference", "Model reference output"});
title(win_1(1),"DIRAC with Estimator III");
xlabel(win_1(1),'time (s)');
ylabel(win_1(1),'output');
grid(win_1(1),'on');
grid(win_1(1),'minor');
ylim(win_1(1),[100 ymax]);
xlim(win_1(1),[0 simuTime]);

plot(win_1(2),referencia_2.time, referencia_2.data,'k--','LineWidth',1.5);
plot(win_1(2),saida_referencia_2.time, saida_referencia_2.data,'k','LineWidth',1);
legend(win_1(2),{...
    "P.1 output",...
    "P.4 output",...
    "P.8 output",...
    "Reference", "Model reference output"});
title(win_1(2),"DIRAC with Estimator III");
xlabel(win_1(2),'time (s)');
ylabel(win_1(2),'output');
grid(win_1(2),'on');
grid(win_1(2),'minor');
ylim(win_1(2),[100 ymax]);
xlim(win_1(2),[0 simuTime]);

plot(win_1(3),referencia_3.time, referencia_3.data,'k--','LineWidth',1.5);
plot(win_1(3),saida_referencia_3.time, saida_referencia_3.data,'k','LineWidth',1);
legend(win_1(3),{...
    "P.1 output",...
    "P.4 output",...
    "P.8 output",...
    "Reference", "Model reference output"});
title(win_1(3),"DIRAC with Estimator III");
xlabel(win_1(3),'time (s)');
ylabel(win_1(3),'output');
grid(win_1(3),'on');
grid(win_1(3),'minor');
ylim(win_1(3),[100 ymax]);
xlim(win_1(3),[0 simuTime]);

print('output_figure', '-dpng', '-r600');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

legend(win_2(1),{...
    "P.1 output",...
    "P.4 output",...
    "P.8 output",...
    });
title(win_2(1),"DIRAC with Estimator III");
xlabel(win_2(1),'time (s)');
ylabel(win_2(1),'infusion rate');
grid(win_2(1),'on');
grid(win_2(1),'minor');
ylim(win_2(1),[0 100]);
xlim(win_2(1),[0 simuTime]);


legend(win_2(2),{...
    "P.1 output",...
    "P.4 output",...
    "P.8 output",...
    });
title(win_2(2),"DIRAC with Estimator III");
xlabel(win_2(2),'time (s)');
ylabel(win_2(2),'infusion rate');
grid(win_2(2),'on');
grid(win_2(2),'minor');
ylim(win_2(2),[0 100]);
xlim(win_2(2),[0 simuTime]);


legend(win_2(3),{...
    "P.1 output",...
    "P.4 output",...
    "P.8 output",...
    });
title(win_2(3),"DIRAC with Estimator III");
xlabel(win_2(3),'time (s)');
ylabel(win_2(3),'infusion rate');
grid(win_2(3),'on');
grid(win_2(3),'minor');
ylim(win_2(3),[0 100]);
xlim(win_2(3),[0 simuTime]);

print('input_figure', '-dpng', '-r600');
