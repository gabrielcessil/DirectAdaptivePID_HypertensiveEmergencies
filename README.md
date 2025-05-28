# Development of Adaptive Controllers for Intensive Treatment of Hypertensive Patients

This repository contains the MATLAB implementation of directly adaptive PID controllers (DIRAC), developed to automate the treatment of hypertensive crises. The work was presented as a final graduation thesis by Gabriel César Silveira in the Mechatronics Engineering program at the Federal University of Santa Catarina (UFSC) – Joinville campus.

This project received the highest possible grade as a graduation requirement and was presented at the Brazilian Congress of Automatics (CBA) 2024.

- Congress article (Link): it is the more recent form of the work, correcting the interpretetion of the hypertensions requirements and presenting the results.
- Graduation thesis (Link): more extensive discussion, presenting the theory of adaptive controllers, the adopted algorithm and implementation in detail.
 
## Overview

The project proposes and validates, through numerical simulations, a directly adaptive PID control strategy. The controllers are implemented using a Recursive Least Squares (RLS) algorithm and are designed to adjust their behavior dynamically in response to the physiological characteristics of hypertensive patients.

## Theoretical Background

- **PID Controllers**: Common in industrial applications for their simplicity and effectiveness, but prone to instability in systems with high variability or uncertainty.
- **Direct Adaptive Control**: Updates the controller parameters in real time without requiring an explicit model of the plant.
- **Reference Models**: Specify the desired dynamic behavior that the control system should track.
- **Recursive Least Squares (RLS)**: A real-time estimation algorithm used to adapt the controller parameters by minimizing prediction error.

## Implementation

The simulation environment includes three main components:

### 1. Blood Pressure Simulation

A mathematical model based on literature, accounting for drug response dynamics, transport and recirculation delays, and stochastic physiological variations. Implemented using MATLAB Simulink.

### 2. DIRAC Controller

An adaptive PID controller formulated in discrete-time incremental form. The controller coefficients are adapted online using filtered signals and a direct identification approach. The direct approach is a model-free, so that the plant's model do not govern the control law, instead, it is used just as a initial solution of the controller grains. 

### 3. Estimators

Recursive estimators based on RLS and its variants. These estimate FIR-like PID coefficients used to update the controller in real time.

## Main Files


## Performance Metrics

The controller performance is evaluated using:

- Maximum overshoot  
- Settling time  
- Steady-state error  
- Response to patient variability  
- Robustness to noise and disturbances

## Repository Structure

