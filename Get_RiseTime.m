 function rise_time = Get_RiseTime(output, setpoint, tempo,Instante_habilita_controlador)
    index_habilita_controlador = find(tempo >= Instante_habilita_controlador,1);
    output_real = output(index_habilita_controlador:end);
    rise_index = find(output_real <= setpoint*1.02,1);
    rise_time = tempo(rise_index);
    if isempty(rise_time)
        rise_time = tempo(end);
    end
    
    if ~isscalar(rise_time)
        rise_time = sprintf('%f',rise_time);
    end

    
 end