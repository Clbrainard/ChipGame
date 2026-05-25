#include <iostream>
#include <cuda_runtime.h>
#include <curand_kernel.h>
#include <vector>

#include <fstream>
#include <string>

void writeToCSV(const std::string& filename, double val1, double val2) {
    std::ofstream file(filename, std::ios::app);
    if (file.is_open()) {
        file << val1 << "," << val2 << "\n";
        file.close();
    }
}



__global__ void simulation(int* results, int s) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;

    double chips = 2000;
    double totalBets = 0;

    curandState state;
    curand_init(1234 + id, 0, 0, &state);

    int bet = s;

    while (chips > 0) {
        bet = s;
        if (bet <= 0) {
            bet = 1;
        }
        if (bet > chips) {
            bet = chips;
        }

        totalBets += bet;

        if (totalBets >= 10000) {
            results[id] = 1;
            return;
        }

        float random = curand_uniform(&state);
        if (random < 0.4f) {
            chips += bet;
        } else {
            chips -= bet;
        }

    }

    results[id] = 0;
}

double winRate(int s, int N) {

    int* gpu_results;
    cudaMalloc(&gpu_results, N * sizeof(int));

    int* cpu_results = new int[N];

    simulation<<<(N+255)/256, 256>>>(gpu_results, s);

    cudaDeviceSynchronize();

    cudaMemcpy(cpu_results, gpu_results, N * sizeof(int), cudaMemcpyDeviceToHost);

    int wins = 0;
    for (int i = 0; i < N; i++) {
        wins += cpu_results[i];
    }

    cudaFree(gpu_results);
    delete[] cpu_results;

    return (double)wins / N;
}

int main() {
    int N;
    std::cin >> N;
    
    std::vector<int> sizes = {1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,45,50,60,70,80,90,100,125,150,175,200,250,300,350,400,450,500,600,700,800,900,1000,1250,1500,1750,2000};

    for (int i = 0; i < sizes.size(); i++) {
            writeToCSV("staticResults.csv",sizes[i],winRate(sizes[i],N));
    }

    
}
