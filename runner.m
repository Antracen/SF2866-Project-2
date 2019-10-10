%% Run simulations
close all;

output_file = fopen(sprintf("Results/%s.txt", datetime), "w");

for j = 1:7
    eval(sprintf("lifetimes_%d = [];", j));
end

[train_frequencies, door_opening, lambda, P, travel_times,train_offsets,train_cap] = get_parameters(1);

train_offsets.E = 95;
train_offsets.W = 235;
train_offsets.S = 145;
train_offsets.N = 150;

fprintf(output_file, "DELAYS:\nNorth: %d\nEast: %d\n", train_offsets.N, train_offsets.E);

tic;
    simulation = sim('train_network');
simtime = toc;

fprintf(output_file, "Simulation took %f seconds\n", simtime);

log_measurements = simulation.logsout;


% Naming conventions:
%   n_<a>-<b>               number of people travelling from station <a> to <b>
%   lifetimes_<a>           lifetime of entities departing at station <a> and which
%                           station they came from
%   PeopleStation<n>        Number of people on station <n>
%
%

% for i = 1:size(travels,1)
%     subplot(4,3,i);
%     data = get(log_measurements, sprintf("n_%d-%d", travels(i,1), travels(i,2)));
%     plot(data.Values);
%     title(sprintf("People travelling station %d to %d", travels(i,1), travels(i,2)));
%     xlabel("Time (s)");
%     ylabel("# People");
% end

% PLATFORM NUMBERS

% TRAVEL TIMES
travels = {[1 2],[1 2 3],[1 2 3 4],[1 2 3 4 5],[1 2 3 6],[1 2 3 7],[2 3],[2 3 4],[2 3 4 5],[2 3 6],[2 3 7],[3 4],[3 4 5],[3 6],[3 7],[4 5], [6 3 7], [6 3 4], [6 3 4 5], [7 3 4], [7 3 4 5]};

max_wait = 0;
max_travel = 0;
min_wait = inf;
min_travel = 0;

total_time = 0; % Total waiting time for all entities
total_people = 0;

for travelcell = travels
    for l = 1:2
        travel = travelcell{1};
        if l == 2
            travel = flip(travel);
        end
        time = eval(sprintf("mean(lifetimes_%d(1, lifetimes_%d(2,:) == %d))", travel(end), travel(end), travel(1)));
        travel_time = 0;
        for j = 1:length(travel)-1
           travel_time = travel_time + travel_times(travel(j), travel(j+1)); 
        end

        waiting_time = time-travel_time;
        total_time = total_time + eval(sprintf("sum(lifetimes_%d(1, lifetimes_%d(2,:) == %d)-travel_time)", travel(end), travel(end), travel(1)));
        total_people = total_people + eval(sprintf("length(lifetimes_%d(1, lifetimes_%d(2,:) == %d))", travel(end), travel(end), travel(1)));

        if waiting_time > max_wait
            max_wait = waiting_time;
            max_travel = travel;
        elseif waiting_time < min_wait
            min_wait = waiting_time;
            min_travel = travel;
        end
        fprintf(output_file, "Travel from station %d to station %d has mean total time %f and mean waiting time %f\n", travel(1), travel(end), time, waiting_time);
    end
end

% Calculate mean waiting for all entities
fprintf(output_file, "MEAN WAIT: %f\n", total_time/total_people);
fprintf(output_file, "Max wait: %f on travel %d to %d\n", max_wait, max_travel(1), max_travel(end));
fprintf(output_file, "Min wait: %f on travel %d to %d\n", min_wait, min_travel(1), min_travel(end));