function [train_frequencies, door_opening, lambda, P, travel_times, train_offsets, train_cap] = get_parameters(scenario)
    if scenario == 1
        
        train_cap = 1200;
        
        % OPTIMIZATION PARAMETERS
        train_frequencies = struct;
            train_frequencies.N = 240;
            train_frequencies.S = 240;
            train_frequencies.E = 180;
            train_frequencies.W = 180;
            
        train_offsets = struct;
            train_offsets.N = 0;
            train_offsets.S = 0;
            train_offsets.E = 0;
            train_offsets.W = 0;

        % Train delays

        door_opening = [15 15 15 15 15 15 15];

        % frequency arrivals to station
        lambda = 1./[0.29+3.89 0.2222 1.6111 0.6944 0.2+1.11 0.15+3.33 0.22+2.08];

        %End Station Probabilities (different scenarios)
        %    1     2     3     4     5     6     7
        P = [0.00  0.02  0.10  0.10  0.50  0.20  0.08;
             0.05  0.00  0.10  0.09  0.50  0.18  0.08;
             0.05  0.01  0.00  0.02  0.64  0.20  0.08;
             0.05  0.01  0.02  0.00  0.67  0.20  0.05;
             0.20  0.02  0.20  0.23  0.00  0.20  0.15;
             0.04  0.01  0.08  0.07  0.35  0.00  0.45;
             0.10  0.01  0.09  0.10  0.20  0.50  0.00];
         
         for row = 1:size(P,1)
             rowsum = sum(P(row,:));
             assert(rowsum - 1 < 1e-3, sprintf("Rowsum of P must be 1 (row %d wrong sum %f)", row, rowsum));
         end

        travel_times = [ 0       60    0      0      0     0        0;
                         60      0     90     0      0     0        0;
                         0       90    0      70     0     90       80;
                         0       0     70     0      120   0        0;
                         0       0     0      120    0     0        0;
                         0       0     90     0      0     0        0;
                         0       0     80     0      0     0        0];
    end
end
