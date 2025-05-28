%---------------- CONFIGURACOES
WorkspaceFile = 'VariablesSAVE_div100_23032024';
ArquivoResultados = 'Analise_Transitorio_2step.xlsx';

% Configuracoes gerais da simulacao
simuTime = 6*60*60; % Tempo de simulação
T = 15; % Tempo de amostragem do controlador
Instante_habilita_controlador = 30; % Instante apos transitorio do modelo
Amplitude_perturbacao = 0; % Valor somado ao offset
Instante_habilita_perturbacao = 3*60*60;
setpoint_inicial = 131; % Referencia inicial
setpoint_final = 116; % Referencia final 140 ~ 100
Criterio_Acomodacao = 15; % Criterio para definir momento de acomodacao
n_amostras = 1; % Configuracoes de afericao estatistica


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

OS_amostras_1 = zeros(length(Pacientes),n_amostras);
OS_amostras_2 = zeros(length(Pacientes),n_amostras);
OS_amostras_3 = zeros(length(Pacientes),n_amostras);

US_amostras_1 = zeros(length(Pacientes),n_amostras);
US_amostras_2 = zeros(length(Pacientes),n_amostras);
US_amostras_3 = zeros(length(Pacientes),n_amostras);

TA_amostras_1 = zeros(length(Pacientes),n_amostras);
TA_amostras_2 = zeros(length(Pacientes),n_amostras);
TA_amostras_3 = zeros(length(Pacientes),n_amostras);

ESS_amostras_1 = zeros(length(Pacientes),n_amostras);
ESS_amostras_2 = zeros(length(Pacientes),n_amostras);
ESS_amostras_3 = zeros(length(Pacientes),n_amostras);

Resultados_Por_Perfil = zeros(length(Pacientes),12);

OS_maximo = zeros(length(Pacientes),3); %1-3
TA_maximo = zeros(length(Pacientes),3); %4-6
ESS_maximo = zeros(length(Pacientes),3); %7-9
TA_minimo = zeros(length(Pacientes),3); %10-12
US_maximo = zeros(length(Pacientes),3); %13-15

n_failures_1 = zeros(length(Pacientes),1); 
n_failures_2 = zeros(length(Pacientes),1); 
n_failures_3 = zeros(length(Pacientes),1); 

Kc_estimations_2 = {};
Ki_estimations_2 = {};
Kd_estimations_2 = {};

c0_2 = {};
c1_2 = {};
c2_2 = {};
% Graficos para cada paciente
 for i=1:length(Pacientes)
    
    %---------------- DEFINE PACIENTE 
    
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
    
    for j=1:n_amostras
    
        %---------------- SIMULA PACIENTE E COLETA SINAIS
        semente_ruido = j;

        simu_Controlador_1 = sim('Verificacao_Controle_Pressao_1','StopTime', sprintf('%.6f',simuTime));
        saida_planta_1 = simu_Controlador_1.saida;
        entrada_planta_1 = simu_Controlador_1.entrada_planta;
        saida_referencia_1 = simu_Controlador_1.saida_referencia;
        theta_1 = simu_Controlador_1.theta;
        perturbacao_1 = simu_Controlador_1.perturbacao;
        referencia_1  = simu_Controlador_1.referencia;
        
        simu_Controlador_2 = sim('Verificacao_Controle_Pressao_2','StopTime', sprintf('%.6f',simuTime));
        saida_planta_2 = simu_Controlador_2.saida;
        entrada_planta_2 = simu_Controlador_2.entrada_planta;
        saida_referencia_2 = simu_Controlador_2.saida_referencia;
        theta_2 = simu_Controlador_2.theta;
        perturbacao_2 = simu_Controlador_2.perturbacao;
        referencia_2  = simu_Controlador_2.referencia;
        
        simu_Controlador_3 = sim('Verificacao_Controle_Pressao_3','StopTime', sprintf('%.6f',simuTime));
        saida_planta_3 = simu_Controlador_3.saida;
        entrada_planta_3 = simu_Controlador_3.entrada_planta;
        saida_referencia_3 = simu_Controlador_3.saida_referencia;
        theta_3 = simu_Controlador_3.theta;
        perturbacao_3 = simu_Controlador_3.perturbacao;
        referencia_3  = simu_Controlador_3.referencia;
                      
        Kc_estimations_2{end+1} = simu_Controlador_3.Kc;
        Ki_estimations_2{end+1} = simu_Controlador_3.Ki;
        Kd_estimations_2{end+1} = simu_Controlador_3.Kd;
        c0_2{end+1} = simu_Controlador_3.c0;
        c1_2{end+1} = simu_Controlador_3.c1;
        c2_2{end+1} = simu_Controlador_3.c2;
        %---------------- AVALIA DESEMPENHO
        [OS_1,US_1,TA_1,ESS_1] = Metricas(saida_planta_1.time,saida_planta_1.data,setpoint_final,Instante_habilita_controlador); 
        [OS_2,US_2,TA_2,ESS_2] = Metricas(saida_planta_2.time,saida_planta_2.data,setpoint_final,Instante_habilita_controlador); 
        [OS_3,US_3,TA_3,ESS_3] = Metricas(saida_planta_3.time,saida_planta_3.data,setpoint_final,Instante_habilita_controlador); 
        
        
        %---------------- REGISTRA DESEMPENHO DA AMOSTRA
        OS_amostras_1(i,j) = OS_1;
        US_amostras_1(i,j) = US_1;
        TA_amostras_1(i,j) = TA_1;
        ESS_amostras_1(i,j) = ESS_1;
        
        
        OS_amostras_2(i,j) = OS_2;
        US_amostras_2(i,j) = US_2;
        TA_amostras_2(i,j) = TA_2;
        ESS_amostras_2(i,j) = ESS_2;
        
        OS_amostras_3(i,j) = OS_3;
        US_amostras_3(i,j) = US_3;
        TA_amostras_3(i,j) =  TA_3;
        ESS_amostras_3(i,j) = ESS_3;
        
        %{
        if (OS_1 > 10 || TA_1 > 7200 || TA_1 < 900)  
            n_failures_1(i,1) = n_failures_1(i,1)+1;
            fprintf(1,"Estimador 1: Paciente %d (amostra %d) falhou: %f %f\n", i,j, OS_1, TA_1);    
        end 
        
        if (OS_2 > 10 || TA_2 > 7200 || TA_2 < 900)  
            n_failures_2(i,1) = n_failures_2(i,1)+1;
            fprintf(1,"Estimador 2: Paciente %d (amostra %d) falhou:  %f %f\n", i,j, OS_2, TA_2);  
        end 
        
        if (OS_3 > 10 || TA_3 > 7200 || TA_3 < 900)  
            n_failures_3(i,1) = n_failures_3(i,1)+1;
            fprintf(1,"Estimador 3: Paciente %d (amostra %d) falhou:  %f %f\n", i,j, OS_3, TA_3); 
        end 
        %}
    end
    
    %---------------- AVALIA DESEMPENHO DOS CONTROLADORES PARA O PERFIL DE PACIENTE
    
    OS_maximo(i,1) = mean(OS_amostras_1(i,:)) + 2.*std(OS_amostras_1(i,:));
    OS_maximo(i,2) = mean(OS_amostras_2(i,:)) + 2.*std(OS_amostras_2(i,:));
    OS_maximo(i,3) = mean(OS_amostras_3(i,:)) + 2.*std(OS_amostras_3(i,:));
    
    US_maximo(i,1) = mean(US_amostras_1(i,:)) + 2.*std(US_amostras_1(i,:));
    US_maximo(i,2) = mean(US_amostras_2(i,:)) + 2.*std(US_amostras_2(i,:));
    US_maximo(i,3) = mean(US_amostras_3(i,:)) + 2.*std(US_amostras_3(i,:));
    
    TA_maximo(i,1) = mean(TA_amostras_1(i,:)) + 2.*std(TA_amostras_1(i,:));
    TA_maximo(i,2) = mean(TA_amostras_2(i,:)) + 2.*std(TA_amostras_2(i,:));
    TA_maximo(i,3) = mean(TA_amostras_3(i,:)) + 2.*std(TA_amostras_3(i,:));
    
    TA_minimo(i,1) = mean(TA_amostras_1(i,:)) - 2.*std(TA_amostras_1(i,:));
    TA_minimo(i,2) = mean(TA_amostras_2(i,:)) - 2.*std(TA_amostras_2(i,:));
    TA_minimo(i,3) = mean(TA_amostras_3(i,:)) - 2.*std(TA_amostras_3(i,:));
    
    ESS_maximo(i,1) = mean(ESS_amostras_1(i,:)) + 2.*std(ESS_amostras_1(i,:));
    ESS_maximo(i,2) = mean(ESS_amostras_2(i,:)) + 2.*std(ESS_amostras_2(i,:));
    ESS_maximo(i,3) = mean(ESS_amostras_3(i,:)) + 2.*std(ESS_amostras_3(i,:));
    
    Resultados_Por_Perfil(i,1) = OS_maximo(i,1);
    Resultados_Por_Perfil(i,2) = OS_maximo(i,2);
    Resultados_Por_Perfil(i,3) = OS_maximo(i,3);
    Resultados_Por_Perfil(i,4) = TA_maximo(i,1);
    Resultados_Por_Perfil(i,5) = TA_maximo(i,2);
    Resultados_Por_Perfil(i,6) = TA_maximo(i,3);
    Resultados_Por_Perfil(i,7) = ESS_maximo(i,1);
    Resultados_Por_Perfil(i,8) = ESS_maximo(i,2);
    Resultados_Por_Perfil(i,9) = ESS_maximo(i,3);
    Resultados_Por_Perfil(i,10) = TA_minimo(i,1);
    Resultados_Por_Perfil(i,11) = TA_minimo(i,2);
    Resultados_Por_Perfil(i,12) = TA_minimo(i,3);
    Resultados_Por_Perfil(i,13) = US_maximo(i,1);
    Resultados_Por_Perfil(i,14) = US_maximo(i,2);
    Resultados_Por_Perfil(i,15) = US_maximo(i,3);
    
 end

fprintf('%2.3f %2.3f %2.3f | %6.3f %6.3f %6.3f | %2.3f %2.3f %2.3f | %6.3f %6.3f %6.3f | %2.3f %2.3f %2.3f \n', Resultados_Por_Perfil.')
writetable(...
    array2table(Resultados_Por_Perfil,...
    'VariableNames',{'OS_1','OS_2','OS_3','TA_1','TA_2','TA_3','ESS_1','ESS_2','ESS_3','TAmin_1','TAmin_2','TAmin_3','US_1','US_2','US_3'}),...
    ArquivoResultados);
save(WorkspaceFile)



