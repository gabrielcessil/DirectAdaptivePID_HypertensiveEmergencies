
%---------------- CONFIGURACOES

ArquivoResultados = 'Analise_Robustez.xlsx';

% Configuracoes gerais da simulacao
simuTime = 6*60*60; % Tempo de simulação
T = 15; % Tempo de amostragem do controlador
Instante_habilita_controlador = 30; % Instante apos transitorio do modelo
Amplitude_perturbacao = 25; % Valor somado ao offset 
Instante_habilita_perturbacao = 3*60*60; 
setpoint_inicial = 150; % Referencia inicial
setpoint_final = 120; % Referencia final 140 ~ 100
Criterio_Acomodacao = 15; % Criterio para definir momento de acomodacao
n_amostras = 1000; % Configuracoes de afericao estatistica
Instante_habilita_analise = 20000;

% Configuracoes do controlador DIRAC
Constante_tempo_referencia = 50*3; % Constante de tempo da malha de referencia (Tau_max*3)
Tempo_de_acomodacao = Constante_tempo_referencia*4; %Tempo de acomodacao do modelo de referencia
Tempo_Segundo_Step = 30*60; % Referencia de controle 
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

Kp_inicial =  -Tau_lambdaTuning*0.001/(K_lambdaTuning*(Tau_lambdaTuning+Tcl_lambdaTuning));
Ti_inicial =  Tau_lambdaTuning*0.001;
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

Estd_amostras_1 = zeros(length(Pacientes),n_amostras);
Estd_amostras_2 = zeros(length(Pacientes),n_amostras);
Estd_amostras_3 = zeros(length(Pacientes),n_amostras);

TR_amostras_1 = zeros(length(Pacientes),n_amostras);
TR_amostras_2 = zeros(length(Pacientes),n_amostras);
TR_amostras_3 = zeros(length(Pacientes),n_amostras);

SM_amostras_1 = zeros(length(Pacientes),n_amostras);
SM_amostras_2 = zeros(length(Pacientes),n_amostras);
SM_amostras_3 = zeros(length(Pacientes),n_amostras);

Resultados_Por_Perfil = zeros(length(Pacientes),9);

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
        referencia_1  = simu_Controlador_1.referencia;
        atividade_background_1 = simu_Controlador_1.atividade_background;
        
        simu_Controlador_2 = sim('Verificacao_Controle_Pressao_2','StopTime', sprintf('%.6f',simuTime));
        saida_planta_2 = simu_Controlador_2.saida;
        entrada_planta_2 = simu_Controlador_2.entrada_planta;
        saida_referencia_2 = simu_Controlador_2.saida_referencia;
        theta_2 = simu_Controlador_2.theta;
        referencia_2  = simu_Controlador_2.referencia;
        atividade_background_2 = simu_Controlador_2.atividade_background;
        
        simu_Controlador_3 = sim('Verificacao_Controle_Pressao_3','StopTime', sprintf('%.6f',simuTime));
        saida_planta_3 = simu_Controlador_3.saida;
        entrada_planta_3 = simu_Controlador_3.entrada_planta;
        saida_referencia_3 = simu_Controlador_3.saida_referencia;
        theta_3 = simu_Controlador_3.theta;
        referencia_3  = simu_Controlador_3.referencia;
        atividade_background_3 = simu_Controlador_3.atividade_background;
                      
        %---------------- AVALIA DESEMPENHO
        
         [Estd_1, TR_1, SM_1] = Metricas(saida_planta_1.time,...
                                    saida_planta_1.data,...
                                    entrada_planta_1.data,...
                                    setpoint_final,...
                                    Criterio_Acomodacao,...
                                    Amplitude_perturbacao,...
                                    Instante_habilita_perturbacao,...
                                    Instante_habilita_analise);

         [Estd_2, TR_2, SM_2] = Metricas(saida_planta_2.time,...
                                    saida_planta_2.data,...
                                    entrada_planta_2.data,...
                                    setpoint_final,...
                                    Criterio_Acomodacao,...
                                    Amplitude_perturbacao,...
                                    Instante_habilita_perturbacao,...
                                    Instante_habilita_analise);
         [Estd_3, TR_3, SM_3] = Metricas(saida_planta_3.time,...
                                    saida_planta_3.data,...
                                    entrada_planta_3.data,...
                                    setpoint_final,...
                                    Criterio_Acomodacao,...
                                    Amplitude_perturbacao,...
                                    Instante_habilita_perturbacao,...
                                    Instante_habilita_analise);

        %---------------- REGISTRA DESEMPENHO DA AMOSTRA
        Estd_amostras_1(i,j) = Estd_1;
        Estd_amostras_2(i,j) = Estd_2;
        Estd_amostras_3(i,j) = Estd_3;
        
        TR_amostras_1(i,j) = TR_1;
        TR_amostras_2(i,j) = TR_2;
        TR_amostras_3(i,j) = TR_3;
        
        SM_amostras_1(i,j) = SM_1;
        SM_amostras_2(i,j) = SM_2;
        SM_amostras_3(i,j) = SM_3;
        
    end
    
    %---------------- AVALIA DESEMPENHO DOS CONTROLADORES PARA O PERFIL DE PACIENTE
    Resultados_Por_Perfil(i,1) = mean(Estd_amostras_1(i,:));
    Resultados_Por_Perfil(i,2) = mean(Estd_amostras_2(i,:));
    Resultados_Por_Perfil(i,3) = mean(Estd_amostras_3(i,:));
    Resultados_Por_Perfil(i,4) = mean(TR_amostras_1(i,:));
    Resultados_Por_Perfil(i,5) = mean(TR_amostras_2(i,:));
    Resultados_Por_Perfil(i,6) = mean(TR_amostras_3(i,:));
    Resultados_Por_Perfil(i,7) = mean(SM_amostras_1(i,:));
    Resultados_Por_Perfil(i,8) = mean(SM_amostras_2(i,:));
    Resultados_Por_Perfil(i,9) = mean(SM_amostras_3(i,:));
 end

fprintf('%2.3f %2.3f %2.3f | %6.3f %6.3f %6.3f | %3.3f %3.3f %3.3f\n', Resultados_Por_Perfil.')

figure(1);
plot(saida_planta_1.time,saida_planta_1.data);
figure(2);
plot(theta_1.time,theta_1.data);
figure(3);
plot(atividade_background_1.time, atividade_background_1.data);



function [Residual_medio, Tempo_Resposta, Entrada_Media_Estacionaria] = Metricas(tempo,...
    saida,...
    entrada_planta,...
    setpoint,...
    Criterio_Acomodacao,...
    amplitude_perturbacao,...
    Instante_habilita_perturbacao,...
    Instante_habilita_analise)
    
    i_start = find(tempo>Instante_habilita_analise,1,'first');
    referencia = setpoint.* ones(length(saida(i_start:end)),1);
    saida_media = mean(saida(i_start:end));
    Residual = abs(saida_media - referencia)*100/(amplitude_perturbacao);
    Residual_medio = mean(Residual);
    Tempo_Resposta = Get_TempoAcomodacao(Criterio_Acomodacao,saida, setpoint, tempo, Instante_habilita_perturbacao) - Instante_habilita_perturbacao;
    
    
    j_start = round((length(entrada_planta)-i_start)*0.9)+i_start;
    Entrada_Media_Estacionaria = mean(entrada_planta(j_start:end));
end 

function ta = Get_TempoAcomodacao(criteria,output, setpoint, tempo, instante_habilitacao)
    sz = length(output);
    ta = tempo(end);
    for i = 1:sz
        if(abs((setpoint - output(i))/setpoint)*100 > criteria && tempo(i) >= instante_habilitacao)
            ta = tempo(i);
        end
    end
 end
 
function pacientes = Get_Pacientes(Parametros_Paciente)
    % Pacientes sem acao de perturbacao
    
    Paciente_1 = containers.Map(Parametros_Paciente,[1 -0.25 30 20 30 0.4 1.25663706 180 2 10 70]);
    Paciente_2 = containers.Map(Parametros_Paciente,[2 -0.5  34 25 35 0.2 1.25663706 180 2 10 70]);
    Paciente_3 = containers.Map(Parametros_Paciente,[3 -0.75 37 30 40 0.4 1.25663706 180 2 10 70]);
    Paciente_4 = containers.Map(Parametros_Paciente,[4 -1    40 40 45 0.2 1.25663706 180 2 10 70]);
    Paciente_5 = containers.Map(Parametros_Paciente,[5 -2    45 45 55 0.4 1.25663706 180 2 10 70]);
    Paciente_6 = containers.Map(Parametros_Paciente,[6 -4    55 50 60 0.2 1.25663706 180 2 10 70]);
    Paciente_7 = containers.Map(Parametros_Paciente,[7 -6    65 55 65 0.4 1.25663706 180 2 10 70]);
    Paciente_8 = containers.Map(Parametros_Paciente,[8 -8    75 60 75 0.2 1.25663706 180 2 10 70]); 
    pacientes = {Paciente_1, Paciente_2,Paciente_3,Paciente_4,Paciente_5,Paciente_6,Paciente_7,Paciente_8};
    %pacientes = {Paciente_7,Paciente_1};
end