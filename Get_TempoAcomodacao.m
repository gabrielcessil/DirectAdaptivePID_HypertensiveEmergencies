 function ta = Get_TempoAcomodacao(criteria,output, setpoint_final, tempo, instante_habilitacao)
    sz = length(output);
    ta = tempo(end);
    for i = 1:sz
        if(abs(setpoint_final - output(i)) > criteria && tempo(i) >= instante_habilitacao)
            ta = tempo(i);
        end
    end
 end
  % Registra ultimo instante fora da faixa percentual definida pelo criterio
