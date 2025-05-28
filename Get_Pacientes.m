
function pacientes = Get_Pacientes(Parametros_Paciente)
    % Pacientes sem acao de perturbacao
    
    Paciente_1 = containers.Map(Parametros_Paciente,[1 -0.25 30 20 30 0.4 1.25663706 146 4 5 70]);
    Paciente_2 = containers.Map(Parametros_Paciente,[2 -0.5  34 25 35 0.2 1.25663706 146 4 5 70]);
    Paciente_3 = containers.Map(Parametros_Paciente,[3 -0.75 37 30 40 0.4 1.25663706 146 4 5 70]);
    Paciente_4 = containers.Map(Parametros_Paciente,[4 -1    40 40 45 0.2 1.25663706 146 4 5 70]);
    Paciente_5 = containers.Map(Parametros_Paciente,[5 -2    45 45 55 0.4 1.25663706 146 4 5 70]);
    Paciente_6 = containers.Map(Parametros_Paciente,[6 -4    55 50 60 0.2 1.25663706 146 4 5 70]);
    Paciente_7 = containers.Map(Parametros_Paciente,[7 -6    65 55 65 0.4 1.25663706 146 4 5 70]);
    Paciente_8 = containers.Map(Parametros_Paciente,[8 -8    75 60 75 0.2 1.25663706 146 4 5 70]); 
    pacientes = {Paciente_1,Paciente_2,Paciente_3,Paciente_4,Paciente_5,Paciente_6,Paciente_7,Paciente_8};
end