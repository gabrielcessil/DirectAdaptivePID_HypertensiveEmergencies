function [os,us,pt,ess] = Metricas(tempo,saida,setpoint_final,Instante_habilita_controlador)
    pt = Get_RiseTime(saida, setpoint_final, tempo,Instante_habilita_controlador);
    [us,os] = Get_Undershoot_Overshoot(saida, setpoint_final, tempo, pt);
    ess = Get_ESS(saida,setpoint_final,tempo,pt);
end