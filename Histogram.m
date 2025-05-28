paciente = 8;


% Create a new figure
figure;
plotHist(OS_amostras_1(paciente,:),'Estimator I - Overshot Error (mmHg)',3,3,1,[0 0 0],false)
plotHist(OS_amostras_2(paciente,:),'Estimator II - Overshot Error (mmHg)',3,3,2,[0 0 0],false)
plotHist(OS_amostras_3(paciente,:),'Estimator III - Overshot Error (mmHg)',3,3,3,[0 0 0],false)
plotHist(ESS_amostras_1(paciente,:),'Estimator I - Steady State Error (mmHg)',3,3,7,[0 0 0],false)
plotHist(ESS_amostras_2(paciente,:),'Estimator II - Steady State Error (mmHg)',3,3,8,[0 0 0],false)
plotHist(ESS_amostras_3(paciente,:),'Estimator III - Steady State Error (mmHg)',3,3,9,[0 0 0],false)
plotHist(TA_amostras_1(paciente,:),'Estimator I - Settling time (s)',3,3,4,[0 0 0],true)
plotHist(TA_amostras_2(paciente,:),'Estimator II - Settling time (s)',3,3,5,[0 0 0],true)
plotHist(TA_amostras_3(paciente,:),'Estimator III - Settling time (s)',3,3,6,[0 0 0],true)

%leg = legend({'occurences','average', 'average + double dev','average - double dev'}, 'Location','northeastoutside','orientation','horizontal');

function plotHist(samples,str_title,nRow,nColumns,pos,color,plotInf)
    num_bins = 50;

    samples = reshape(samples.',1,[]);
    
    subplot(nRow,nColumns,pos);
    histogram(samples, num_bins, 'DisplayStyle', 'bar', 'FaceColor', 	color, 'LineWidth',1.3);
    xlabel('Value');
    ylabel('Occurences');
    title(str_title);
    
    hold on
    hax=gca;
    m = mean(samples);
    stdev = std(samples);
    limS = m+2*stdev;
    limI =  m-2*stdev;
    line([m m],get(hax,'YLim'), 'Color','blue', 'LineWidth',1.35)
    line([limS limS],get(hax,'YLim'), 'Color','red', 'LineWidth',1.35)
    
    if plotInf
        line([limI limI],get(hax,'YLim'), 'Color','red', 'LineWidth',1.35, 'LineStyle','--')
    end 
    
    xlim([0,m+5*stdev]);
    hold off;
end