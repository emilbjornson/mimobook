Introduction to Multiple Antenna Communications and Reconfigurable Surfaces
==================

This repository contains the free authors' version and the accompanying code package of the textbook :

Emil Björnson and Özlem Tuğfe Demir (2024) “[Introduction to Multiple Antenna Communications and Reconfigurable Surfaces](https://www.nowpublishers.com)”. Boston–Delft: Now Publishers

The code package contains a simulation environment, based on Matlab, that can be used to reproduce all the simulation results in the book. We hope that the code will support you in the learning of the Multiple Antenna Communications and Reconfigurable Surfaces topics and also serve as a baseline for further research endeavors. We encourage you to also perform reproducible research! *We encourage you to also perform reproducible research!*

## Abstract of the Book

Wireless communication is the backbone of the digitized society, where everything is connected and intelligent.
Access points and devices are nowadays equipped with multiple antennas to achieve higher data rates, better
reliability, and support more users than in the past. This book gives a gentle introduction to multiple antenna
communications with a focus on system modeling, channel capacity theory, algorithms, and practical implications.
The basics of wireless localization, radar sensing, and controllable reflection through reconfigurable surfaces are
also covered. The goal is to provide the reader with a solid understanding of this transformative technology that
changes how wireless networks are designed and operated, today and in the future.

The first three chapters cover the fundamentals of wireless channels, and the main benefits of using multiple
antennas are identified: beamforming, diversity, and spatial multiplexing. The theory and signal processing
algorithms for multiple-input multiple-output (MIMO) communications with antenna arrays at the transmitter and
receiver are progressively developed. The next two chapters utilize these results to study point-to-point MIMO
channels under line-of-sight (LOS) and non-LOS conditions, covering the shape of signal beams, impact of array
geometry, polarization, and ways to achieve reliable communication over fading channels. The book then shifts
focus to multi-user MIMO channels, where interference between devices is managed by spatial processing. The next
chapter extends the theory to multicarrier channels and explains practical digital, analog, and hybrid hardware
implementations. The last two chapters cover the role of multiple antennas in localization and sensing, and how
reconfigurable surfaces can improve both communication and sensing systems.

The text was developed as the textbook for a university course and builds on the reader's previous knowledge of
signals and systems, linear algebra, probability theory, and digital communications. Each chapter contains
numerous examples, exercises, and simulation results that can be reproduced using accompanying code.

## Content of Code Package

This code package contains 30 Matlab scripts and 17 Matlab functions.

Each script is used to reproduce a particular simulation-generated figure in the book. The scripts are named using the convention sectionX_figureY, which is interpreted as the script that reproduces Figure X.Y. A few scripts are instead named as sectionX_figureY_Z and will then generate both Figure X.Y and Figure X.Z.

The functions are used by the scripts to carry out certain tasks, such as initiating a simulation setup, generating channel correlation matrices, generating channel realizations, computing channel estimates, computing SEs, implementing power control algorithms, etc.

See each script and function for further documentation. Note that some of the functions use [CVX](http://cvxr.com/cvx/) with SDPT3 solver, which need to be installed separately.

## Acknowledgements

We would first like to thank our students and collaborators in the areas
related to this monograph. Without the results, encouragements, and
insights obtained through our joint research during the last decade, it
wouldn’t have been possible to write this monograph. We are grateful for
the constructive feedback from the reviewers, which helped us to focus
our final editing efforts at the right places. In particular, we would like
to thank Angel Lozano, Jiayi Zhang, Mahmoud Zaher, and Yasaman
Khorsandmanesh for giving detailed comments.

Özlem Tuğfe Demir and Emil Björnson have been supported by the
Wallenberg AI, Autonomous Systems and Software Program (WASP)
funded by the Knut and Alice Wallenberg Foundation. Emil Björnson
has also been supported by the Excellence Center at Linköping – Lund in
Information Technology (ELLIIT), the Center for Industrial Information
Technology (CENIIT), the Swedish Research Council, and the Swedish
Foundation for Strategic Research. Luca Sanguinetti has been partially
supported by the University of Pisa under the PRA Research Project
CONCEPT, and by the Italian Ministry of Education and Research
(MIUR) in the framework of the CrossLab project (Departments of
Excellence).

## License and Referencing

This code package is licensed under the GPLv2 license. If you in any way use this code for research that results in publications, please cite our textbook as described above. We also recommend that you mention the existence of this code package in your manuscript, to spread the word about its existence and to ensure that you will not be accused of plagiarism by the reviewers of your manuscript.
