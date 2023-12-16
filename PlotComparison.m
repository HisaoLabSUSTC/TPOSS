clc,clear,close all
addpath(genpath(pwd));
tasks = ["HSS", "SR", "FS"]; 
algs = ["POSS", "PORSS-O", "PORSS-U", "SPESS", "TPOSS"];

for task = tasks
    if task == "HSS" % hypervolume subset selection
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
        % extract the relevant portion of the file name for the title
        % assuming the file format is consistent
        if task == "HSS"
            fileParts = strsplit(file, '_');
            titleString = fileParts{3} + " " + fileParts{4};
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
        else
            h = plot(result(:,2:end)','LineWidth',2);
        end
        set(h,{'LineStyle'},{'-';'--';'-.';':';'-'})
        legend("POSS","PORSS$_o$","PORSS$_u$","SPESS","TPOSS",'Location','best','Interpreter','latex');
        set(gca,'FontSize',20,'YScale','log');
        
        % set the title of the plot to the extracted titleString
        title(titleString);
    
        % set the labels for the X and Y axes using xlabel and ylabel
        if task == "HSS"
            ylabel('HV', 'Interpreter', 'latex');
        elseif task == "SR"
            ylabel('$R^2$', 'Interpreter', 'latex');
        elseif task == "FS"
            ylabel('Error Ratio', 'Interpreter', 'latex');
        end
        xlabel('Runtime in $kn$', 'Interpreter', 'latex');
        % save the figure
        exportgraphics(gca,"./result/figure/Comparison/"+file+".pdf", "Resolution",300);
    end
    
end