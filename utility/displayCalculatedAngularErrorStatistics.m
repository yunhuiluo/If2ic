function displayCalculatedAngularErrorStatistics(minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle)
    
    fprintf('\n\n');
    disp('ANGULAR ERROR STATISTICS');
    disp('========================');
    
    fprintf('Minimum:   %7.2f\n', minAngle);
    fprintf('Mean:      %7.2f\n', meanAngle);
    fprintf('Median:    %7.2f\n', medianAngle);
    fprintf('Trimean:   %7.2f\n', trimeanAngle);
    fprintf('Best 25%%:  %7.2f\n', best25);
    fprintf('Worst 25%%: %7.2f\n', worst25);
    fprintf('Average:   %7.2f\n', average);
    fprintf('Maximum:   %7.2f\n', maxAngle);
    
end
