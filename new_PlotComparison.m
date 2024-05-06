clc,clear,close all
addpath(genpath(pwd));
tasks = ["HSS","SR","FS"]; 
% algs = ["POSS", "PORSS-O", "PORSS-U", "SPESS", "TPOSS"];
algs = ["TPOSS","TPOSS_crossover","TPOSS_uoffspring_u5","TPOSS_uoffspring_u10"];
% finalRank = zeros(length(epsilon), length(delta));

for task = ["HSS","SR","FS"]
    if task == "HSS" %hypervolume subset selection
        files = [
            "data_set_concave_invertedtriangular_M3_100000",...
            "data_set_concave_triangular_M3_100000",...
            "data_set_convex_invertedtriangular_M3_100000",...
            "data_set_convex_triangular_M3_100000",...
            "data_set_linear_invertedtriangular_M3_100000",...
            "data_set_linear_triangular_M3_100000"];   
    elseif task == "SR" % sparse regression
         files = ["triazines","clean1","usps","svmguide3","scene","protein"];
    else % unsupervised feature selection
         files = ["sonar","Hill-Valley","musk","phishing","mediamill","CT-slices"];
    end
    for file = files
        result = zeros(5,44);
        % Extract the relevant portion of the file name for the title
        % Assuming the file format is consistent
        if task == "HSS"
            fileParts = strsplit(file, '_');
            titleString = fileParts{3} + " " + fileParts{4}; % Extract "dataset_concave_invertedtriangular"
        else 
            titleString = file;
        end
    
        for k = 1:length(algs)
                filename = "./result/Comparison/" + file + "_" + algs(k);
                load(filename, "finalResult");
                result(k,:) = mean(finalResult,1);
        end
        
        % plot the result
        figure
        if file == "triazines"
            h = plot(result(:,4:end)','LineWidth',2);
        elseif file == "sonar"
            h = plot(result(:,3:end)','LineWidth',2);
        elseif file == "protein"
            h = plot(result(:,6:end)','LineWidth',2);
        else
            h = plot(result(:,2:end)','LineWidth',2);
        end
        set(h,{'LineStyle'},{'-';'--';'-.';':';'-'})
        legend("TPOSS","TPOSS-crossover","TPOSS-uoffspring-u5","TPOSS-uoffspring-u10",'Location','best');
        set(gca,'FontSize',20,'YScale','log');
%         set(gca, 'YLim', [0, 1.01*max(result,[],'all')])
        
        % Set the title of the plot to the extracted titleString
        title(titleString);
    
        % Set the labels for the X and Y axes using xlabel and ylabel
        if task == "HSS"
            ylabel('HV', 'Interpreter', 'latex');
        elseif task == "SR"
            ylabel('$R^2$', 'Interpreter', 'latex');
        elseif task == "FS"
            ylabel('Error Ratio', 'Interpreter', 'latex');
        end
        xlabel('Runtime in $kn$', 'Interpreter', 'latex');
        % save the figure
        exportgraphics(gca,"./result/figure/Comparison/new_"+file+".png", "Resolution",300);
    end
    
end