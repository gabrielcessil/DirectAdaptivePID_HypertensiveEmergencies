function ess = Get_ESS(output, setpoint_final, time, settling_time)

    % Find the index where time first exceeds settling_time
    settling_index = find(time >= settling_time, 1);
    
    
    % Extract the steady-state output from settling_index to the end
    ss_output = output(settling_index:end);
    
    % Create a setpoint array of the same length as ss_output
    setpoint = setpoint_final * ones(length(ss_output), 1);
    
    % Calculate the error between ss_output and setpoint
    erro = setpoint - ss_output;
    
    % Calculate the steady-state error (ess) as the standard deviation of the absolute error
    ess = std(abs(erro));
end