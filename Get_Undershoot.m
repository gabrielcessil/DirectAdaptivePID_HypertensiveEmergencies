 function us = Get_Undershoot(output, setpoint_final, tempo, instante_habilitacao)
    
    sz = length(output);
    us = 0;
    cruzou = 0;
    for i = 2:sz
      
      if(setpoint_final > output(i) && setpoint_final <= output(i-1))
          cruzou = 1;
      end
      
      erro = setpoint_final - output(i);
      if(cruzou==1 && erro>=0 && abs(erro) > us && tempo(i) >= instante_habilitacao)
          us = abs(setpoint_final - output(i));
      end
    end
    
 end
 