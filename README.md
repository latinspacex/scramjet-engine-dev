# SCRAMJET-ENGINE-DEV  
## Scramjet Subsystem – Propulsion Final Project

This repository documents the development of a conceptual scramjet engine for a hypersonic vehicle as part of the AE4321 propulsion design project. It includes performance modeling, thermodynamic cycle analysis, flow‐path development, and system‐level optimization.

---

## 🚀 Project Objective

Design and analyze a scramjet propulsion stage capable of sustaining hypersonic cruise (Mach 5–8) under ideal and quasi‐realistic assumptions. Deliverables include:

- Inlet total‐pressure recovery design and optimization  
- Combustor fuel–air ratio and exit temperature analysis  
- Nozzle sizing via NPR→Ae/At interpolation  
- Cycle performance at Mach 6–8 (Isp, thrust per mass‐flow)  
- Dynamic‐pressure corridor verification (q ≈ 1000–1500 psf)  
- System integration notes for two‑stage to orbit

---

## 📁 Repository Structure

├── README.md ← (this file)
├── TO-DO.md ← Live task tracker
├── docs/
│ └── 02_Scramjet_Analysis.md ← Written report for scramjet section
├── analysis/
│ ├── test_functions/ ← Sanity‐check scripts
│ │ ├ test_cycle_performance.m
│ │ ├ test_dynamic_pressure.m
│ │ ├ test_inlet_recovery.m
│ │ └ test_oblique.m
│ ├── find_cruise_altitude.m ← Altitude scan for q ≈ 1200 psf at Mach 6
│ ├── inlet_3shock.m ← 3‑shock inlet total‐pressure recovery
│ ├── nozzle_data.m ← Digitized NPR vs Ae/At data + save .mat
│ ├── nozzle_data.mat ← Binary data for nozzle interpolation
│ ├── optimize_inlet.m ← Practical 3‑shock inlet optimizer
│ ├── plot_inlet_recovery.m ← Plot inlet recovery vs Mach
│ └── scram_cycle.m ← Ideal Farokhi‐style scramjet cycle
├── analysis/utils/ ← Helper functions
│ ├── atmos_isa.m ← ISA atmosphere up to 85 km
│ ├── M_from_AR.m ← Solve supersonic Mach from area ratio
│ ├── obliqueShock.m ← Θ–β–M + normal‑shock total‐pressure ratio
│ └── (optional) inlet_obj.m ← Standalone objective (can be removed)
├── figures/ ← Generated plots
└── reference/ ← Supporting papers & data

---

## 🧪 Key Analyses

- **Inlet**: 3‑oblique‑shock recovery, optimized for Mach 6–8  
- **Combustor**: static exit T₄ = 4000 °R (2220 K), η_b = 0.95 → f  
- **Nozzle**: γ=1.3 NPR→Ae/At interpolation & exit Mach solve  
- **Performance**: Isp, thrust per mass‐flow at Mach 6, 7, 8  
- **Dynamic Pressure**: verify q in 1000–1500 psf corridor  
- **Optimization**: bulk deflection distribution for max worst‑case recovery  

---

## 🔧 How to Run

1. **Open MATLAB**, add paths:
   ```matlab
   addpath('analysis','analysis/utils');
