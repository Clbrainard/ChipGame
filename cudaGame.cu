#include <iostream>
#include <cuda_runtime.h>
#include <curand_kernel.h>

__global__ void simulation(int* results, double R, double dR) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;

    double chips = 2000;
    double totalBets = 0;

    curandState state;
    curand_init(1234 + id, 0, 0, &state);

    int t = 0;

    while (chips > 0) {
        int bet = (int)(chips * (R + (dR * t)));
        if (bet == 0) bet = 1;

        totalBets += bet;

        if (totalBets >= 10000) {
            results[id] = 1;
            return;
        }

        float random = curand_uniform(&state);
        if (random < 0.6f) {
            chips += bet;
        } else {
            chips -= bet;
        }

        t += 1;
    }

    results[id] = 0;
}

double winRate(double dR, double R, int N) {

    int* gpu_results;
    cudaMalloc(&gpu_results, N * sizeof(int));

    int* cpu_results = new int[N];

    simulation<<<(N+255)/256, 256>>>(gpu_results, R, dR);

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
    
    std::vector<double> Rs = {0.0005,0.001,0.005,0.01,0.05,0.1};
    std::vector<double> dRs = {0};

    for (int i = 0; i < Rs.size(); i++) {
        for (int k = 0; k < dRs.size(); k++) {
            std::cout << winRate(dRs[k],Rs[i],N) << "\n"
        }
    }

    
}
