#include <vector> 
#include <cmath>
#include <iostream>
#include <random>

#include <omp.h> 



int betSize(double currChips, double BR) {
    int size = currChips * BR;
    if (size == 0) {
        return 1;
    } else {
        return size;
    }
}


int play(double BR) {

    double currChips = 2000;
    double cumBets = 0;
                
    std::random_device rd;
    std::mt19937 gen(rd());   
    std::discrete_distribution<> dis({60, 40});

    while (currChips != 0) {

        int bet = betSize(currChips,BR);
        cumBets += bet;
        if (cumBets >= 10000) {
            return 1;
        }

        int turn = (2*dis(gen)) - 1;

        currChips += turn * bet;

    }

    return 0;
}

double simPlays(int N,double BR) {
    double wins = 0;

    #pragma omp parallel for reduction(+:wins)
    for (int n = 0; n < N; n++) {
        wins += play(BR);
    }

    return wins / N;
}

int main() {

    int N = 10000;
    std::vector<double> BRs = {0.00005};

    for (int i = 0; i < BRs.size(); i++) {
        std::cout << simPlays(N, BRs[i]) << "\n";
    }
}
