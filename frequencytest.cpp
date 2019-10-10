#include <vector>
#include <iostream>
#include <utility>
#include <algorithm>

using std::cout;
using std::endl;
using std::vector;
using std::pair;
using std::make_pair;

int main() {

	double min_delay = -1;
	vector<int> min_delays(4);

	// E W S N
	vector<int> freqs = {180,180,240,240};
	vector<int> t0 = {180,220,105,95};

	for(int delay1 = 0; delay1 < 240; delay1 += 5) {
		for(int delay2 = 0; delay2 < 240; delay2 += 5) {
			for(int delay3 = 0; delay3 < 180; delay3 += 5) {
				for(int delay4 = 0; delay4 < 180; delay4 += 5) {

					int simtime = 1200;

					vector<int> delays = {delay1,delay2,delay3,delay4};

					vector<vector<int>> arrivals(4);

					for(int i = 0; i < 4; i++) {
						int arrival = t0[i] + delays[i];
						while(arrival <= simtime) {
							arrivals[i].push_back(arrival);
							arrival += freqs[i];
						}
					}

					double time_waiting = 0;
					double people_waiting = 0;

					for(int train = 0; train < 4; train++) {
						int t2,t3,t2w,t3w;
						switch(train) {
							case 0:
								t2 = 2; t2w = 1;
								t3 = 3; t3w = 2;
								break;
							case 1:
								t2 = 2; t2w = 1;
								t3 = 3; t3w = 2;
								break;
							case 2:
								t2 = 0; t2w = 2;
								t3 = 1; t3w = 1;
								break;
							case 3:
								t2 = 0; t2w = 2;
								t3 = 1; t3w = 1;
								break;
						}
						// Investigate train 
						for(int i = 0; i < arrivals[train].size(); i++) {
							int next_train_2 = -1;
							int next_train_3 = -1;
							for(int j = 0; j < arrivals[t2].size(); j++) {
								if(arrivals[t2][j] <= arrivals[train][i] + 20) continue;
								next_train_2 = arrivals[t2][j] - arrivals[train][i];
								break;
							}
							for(int j = 0; j < arrivals[t3].size(); j++) {
								if(arrivals[t3][j] <= arrivals[train][i] + 20) continue;
								next_train_3 = arrivals[t3][j] - arrivals[train][i];
								break;
							}
							if(next_train_2 != -1) {
								time_waiting += t2w*next_train_2;
								//people_waiting++;
							}
							if(next_train_3 != -1) {
								time_waiting += t3w*next_train_3;
								//people_waiting++;
							}
						}
					}
					//double mean_waiting = time_waiting/people_waiting;
					double mean_waiting = time_waiting;

					if(min_delay == -1 || mean_waiting < min_delay && mean_waiting > 20) {
						min_delay = mean_waiting;
						min_delays = {delay1,delay2,delay3,delay4};
					}
				}
			}
		}	
	}
	cout << "Delay East: " << min_delays[0] << " Delay West: " << min_delays[1] << " Delay South: " << min_delays[2] << " Delay North: " << min_delays[3] << " Wait: " << min_delay << endl;
}
