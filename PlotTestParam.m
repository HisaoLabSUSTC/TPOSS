clc,clear,close all
addpath(genpath(pwd));
tasks = ["HSS","SR","FS"];  
epsilon = 0:8;
delta = 1:5; 
finalRank = zeros(length(epsilon), length(delta));

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
         files = ["triazines", "clean1", "svmguide3","scene","usps","protein"];
    else % unsupervised feature selection
         files = ["sonar","Hill-Valley","musk","phishing","mediamill","CT-slices"];
    end
    for file = files
        result = zeros(length(epsilon), length(delta));        
        % extract the relevant portion of the file name for the title
        % assuming the file format is consistent
        if task == "HSS"
            fileParts = strsplit(file, '_');
            titleString = fileParts{3} + " " + fileParts{4}; 
        else 
            titleString = file;
        end
    
        for k = 1:length(epsilon)
            for j = 1:length(delta) 
                filename = file + "_" + num2str(epsilon(k)) + "_" + num2str(delta(j));
                load(filename, "finalResult");
                result(k, j) = mean(finalResult(:, end));
            end
        end

        if task == "FS"
            [~,ranked_indices] = sort(result(:), "ascend");
        else
            [~,ranked_indices] = sort(result(:), "descend");
        end
        [~, rank] = sort(ranked_indices);
        finalRank = finalRank + reshape(rank,size(result));
        finalRank
        
        zmax = max(result, [], "all");
        zmin = min(result, [], "all");
        % create a new figure
        figure;
        % create the bar3 plot
        b = bar3(result, 0.5);
        
        % set the color 
        clim([zmin, zmax]);
        colorbar
        colormap(jet)
        for n = 1:numel(b)
            cdata = get(b(n),'zdata');
            cdata = repmat(max(cdata,[],2),1,4);
            set(b(n),'cdata',cdata,'facecolor','flat')
        end 
        
        % set the properties for the figure
        set(gca, ...
            'Box', 'off', ...
            'ZLim', [zmin * 0.995, zmax * 1.005], ...
            'XTick', 1:length(delta), ...
            'YTick', 1:length(epsilon), ...
            'XTickLabel', delta, ...
            'YTickLabel', epsilon,...
            'FontSize',15);
    
        % set the title of the plot to the extracted titleString
        title(titleString);
    
        % set the labels for the X and Y axes using xlabel and ylabel
        xlabel('$\delta$', 'Interpreter', 'latex','FontSize',20);
        ylabel('$\epsilon$', 'Interpreter', 'latex','FontSize',20);

        % set the labels for Z axes
        if task == "HSS"
            zlabel('HV', 'Interpreter', 'latex');
        elseif task == "SR"
            zlabel('$R^2$', 'Interpreter', 'latex');
        elseif task == "FS"
            zlabel('Error Ratio', 'Interpreter', 'latex');
        end
        
        % save the figure
        exportgraphics(gca,"./result/figure/TestParam/"+file+".pdf", "Resolution",300);
    end
end