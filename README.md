# Evolutionary Simulations of Interspecific Competition and Environmental Change

---

## Reference

Johansson, J. 2008. Evolutionary responses to environmental changes: How does competition affect adaptation? Evolution 62: 421–435. 
Open access. doi:10.1111/j.1558-5646.2007.00301. 

## Purpose
This code demonstrates simulation methods used in the Johansson 2008 paper, exploring how interspecific competition impacts evolutionary adaptation to environmental changes.

---

## Abstract
The role and importance of ecological interactions for evolutionary responses to environmental changes is to a large extent unknown. Here it is shown that interspecific competition may slow down rates of adaptation substantially and fundamentally change patterns of adaptation to long-term environmental changes. 

In the model investigated, species compete for resources distributed along an ecological niche space. Environmental change is represented by a slowly moving resource maximum, and evolutionary responses of single species are compared with responses of coalitions of two and three competing species. The study reveals that weaker selection pressure and reduced population size caused by competition significantly slow down the evolutionary rate of disfavored species, increasing their extinction risk in fluctuating environments.

---

## Model Description
The model depicts populations competing for resources defined along a single trait axis \( u \). Key elements include:
- **Resource Landscape**: Modeled as a Gaussian function with parameters:
  - `sigma_k`: Width of the resource landscape.
  - `Kopt`: Position of the resource maximum.
  - `K`: Carrying capacity at the maximum.
- **Competition**: Intensity \($\alpha$) depends on niche overlap, with higher overlap leading to stronger competition.
- **Species and Reproduction**:
  - Species are reproductively isolated, hermaphroditic, and modeled with a 10-loci diploid genome.
  - Mutation effects are drawn from a normal distribution with standard deviation `sigma_mu`.

The code simulates evolution using an individual-based approach, where:
1. Fitness is computed based on the Lotka–Volterra model.
2. Offspring survival is probabilistic, depending on fitness values and a uniform random variable.
3. Fitness calculations are optimized using linear interpolation.

---

## Main Functions

| Function                  | Description                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| `main.m`                  | Sets parameters and runs an example simulation of a single species adapting to a moving optimum. |
| `simulate_moving_optimum.m` | Core simulation function. Models population dynamics and evolution over time. |
| `offspring_fcn.m`         | Generates a new generation of individuals from the parent generation.       |
| `mutate_offspring_fcn.m`  | Models mutations in offspring genomes.                                      |
| `fitness_fcn.m`           | Calculates individual fitness based on resource availability and competition. |
| `plot_simulation.m`       | Produces plots of population size, trait dynamics, and resource landscapes. |

---

## Usage Instructions

1. **Basic Example**:
   - Open MATLAB or Octave and run:
     ```
     main
     ```
   - This runs a single species simulation adapting to a gradually moving resource maximum.

2. **Additional Examples**:
   - Modify the parameters in `main.m` to explore:
     - **Example 2**: A single species responding to a randomly moving optimum (autoregressive process).
     - **Example 3**: A coalition of two species responding to a gradually moving optimum.

3. **Notes**:
   - For longer simulations, use MATLAB with the `interp1q` function in `fitness_fcn.m` for better performance.
   - To speed up simulations, this demo uses a larger mutation standard deviation (`sigma_mu`) and faster environmental changes.

---

## Simulation Outputs

1. **Plots**:
   - **First Plot**:
     - Population size over time.
     - Trait dynamics over generations.
   - **Second Plot**:
     - Snapshot of fitness, resource availability, and trait distribution at the current generation.

2. **Output Data**:
   - Results are displayed in runtime plots and can be analyzed further by modifying the code.

---

## Installation

1. **System Requirements**:
   - MATLAB (preferred for longer simulations).
   - Octave (tested with version 6.30 on Ubuntu Linux 2024).

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/evolvej2/evolution_and_environmental_change.git
   cd your-repo-name
