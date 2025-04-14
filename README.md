DeepVerse 6G: MATLAB Data Generator
===========================================================================
Welcome to the MATLAB data generator repository for the **DeepVerse 6G** dataset. DeepVerse 6G is a framework designed to generate synthetic yet high-fidelity multi-modal sensing and communication datasets, tailored for 6G research and development involving digital twins.

This repository specifically contains the MATLAB scripts used to generate the multi-modal data using the scenario files presented in the main project website.

**Main Dataset Website:** [`https://deepverse6g.net/`](https://deepverse6g.net/)

Features of DeepVerse 6G Framework
----------------------------------
* **High-Fidelity:** Leverages ray-tracing (via Remcom Wireless InSite) for realistic channel modeling.
* **Multi-Modal:** Integrates communication channel data with sensing modalities (e.g., lidar, vision).
* **Synthetic & Controllable:** Enables generation of diverse datasets tailored to specific research needs.
* **Digital Twin Focused:** Designed to support research in digital twin applications for wireless systems.

Dataset Access
--------------
The datasets using DeepVerse 6G dataset scenarios are generated with these scripts (including channel data, sensor data, etc.). The scenarios can be explored from the main website under the scenarios tab:

**Main Dataset Website:** [`https://deepverse6g.net/`](https://deepverse6g.net/)

**Example Scenarios:**
- Outdoor 1: https://deepverse6g.net/scenario/O1
- Indoor 1: https://deepverse6g.net/scenario/I1
- Carla Town 1: https://deepverse6g.net/scenario/Carla-Town1
- Carla Town 5: https://deepverse6g.net/scenario/Carla-Town5
- Digital Twin 1: https://deepverse6g.net/scenario/DT1
  - Digital Twin to real world dataset: [DeepSense Scenario 1](https://www.deepsense6g.net/scenarios/scenario-1/)
- Digital Twin 31: https://deepverse6g.net/scenario/DT31
  - Digital Twin to real world dataset: [DeepSense Scenario 31](https://www.deepsense6g.net/scenarios/scenario-31/)

Generator Code (This Repository)
--------------------------------
This repository provides the MATLAB scripts to reproduce or generate the DeepVerse 6G datasets.

**Usage:**
* Clone/download this repository
* Select a scenario and download its files from the webpages provided above
* Extract scenario files into `./scenarios` folder under the repository main directory
* Configure the parameters for the scenario under `./param/config.m`
* Run `deepverse_example.m`

License & Citation
------------------
The code in this repository is licensed under the [`Attribution-NonCommercial-ShareAlike 4.0 International`](https://creativecommons.org/licenses/by-nc-sa/4.0/).

If you use the DeepVerse 6G dataset, the generation framework, or these scripts (or any modified part of them) in your research or work, please cite the following:

1.  **The DeepVerse 6G Paper:**
    U. Demirhan, A. Taha, S. Jiang, and A. Alkhateeb "DeepVerse 6G: A Dataset Generation Framework for Multi-Modal Sensing and Communication Digital Twins," *preprint*, Feb. 2025.

    *BibTeX:*

        @article{DeepVerse,
          author  = {Demirhan, U. and Taha, A. and Jiang, S. and Alkhateeb, A.},
          title   = {{DeepVerse 6G}: A Dataset Generation Framework for Multi-Modal Sensing and Communication Digital Twins},
          journal = {preprint},
          year    = {2025},
          month   = {Feb}
        }

2.  **The Ray-Tracing Software Used:**
    Remcom, Wireless InSite. `<https://www.remcom.com/wireless-insite>`_.

    *BibTeX:*

        @article{Remcom,
          author = {Remcom},
          title  = {{Wireless InSite}},
          note   = {\url{https://www.remcom.com/wireless-insite}}
        }
