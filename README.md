[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=emilbjornson/mimobook)


Introduction to Multiple Antenna Communications and Reconfigurable Surfaces
==================

This repository contains the free authors' version and the accompanying code package of the textbook :

Emil Björnson and Özlem Tuğfe Demir (2024) “[Introduction to Multiple Antenna Communications and Reconfigurable Surfaces]([https://www.nowpublishers.com](https://nowpublishers.com/Article/BookDetails/9781638283140))”. Boston–Delft: Now Publishers, http://dx.doi.org/10.1561/9781638283157

The code package contains a simulation environment, based on Matlab, that can be used to reproduce all the simulation results in the book. We hope that the code will support you in the learning of the Multiple Antenna Communications and Reconfigurable Surfaces topics and also serve as a baseline for further research endeavors. *We encourage you to also perform reproducible research!*

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

This code package contains 138 Matlab scripts and 1 Matlab function.

Each script is used to reproduce a particular simulation-generated figure in the book. The scripts are named using the convention chapterX_figureY, which is interpreted as the script that reproduces Figure X.Y. A few scripts are named chapterX_figureY_Z and will then generate Figures X.Y and X.Z. 

The function "functionWaterfilling.m" is used by several scripts to carry out waterfilling power allocation.

See each script and function for further documentation. 

## Acknowledgements

First and foremost, we would like to thank our families for supporting us
throughout the seemingly neverending journey of writing this book.

The know-how that we share has been developed through scientific conversations
and collaborations with Erik G. Larsson, Thomas Marzetta, Luca
Sanguinetti, Jakob Hoydis, Björn Ottersten, Mats Bengtsson, Petar Popovski,
Merouane Debbah, and many other excellent researchers. A special thanks
go to Daniel Verenzuela, Marcus Karlsson, Giovanni Interdonato, Özgecan
Özdogan, and Nikolaos Kolomvakis, who have influenced the material by being
great teaching assistants in the course “Multiple Antenna Communications”.
Many colleagues and students have read drafts of the book and provided
detailed feedback, which enables us to polish off the rough edges and improve
the technical rigor. Some of these are Alva Kosasih, Amna Irshad, Eren Berk
Kama, Mert Alıcıoğlu, Morteza Tavana, Parisa Ramezani, Salih Gümüşbuğa,
Sarvendranath Rimalapudi, Unnikrishnan Kunnath Ganesan, Yasaman Khorsandmanesh,
and Zakir Hussain Shaik. We apologize to everyone we have
forgotten since we did not make notes of contributors until recently. We would
also like to thank Daniel Aronsson for helping us resolve MATLAB issues and
everyone who has asked questions related to our videos and blog posts, which
guided us in what concepts to explain in the book.

Finally, we would like to thank KTH Royal Institute of Technology,
Linköping University, and TOBB University of Economics and Technology for
giving us the time to write this book, as well as the Swedish Research Council,
Swedish Foundation for Strategic Research, Knut and Alice Wallenberg Foundation,
VINNOVA, and the Scientific and Technological Research Council of
Türkiye that have funded our research efforts in these areas in recent years.

The authors, November 2023

## License and Referencing

This code package is licensed under the GPLv2 license. If you in any way use this code for research that results in publications, please cite our textbook as described above. We also recommend that you mention the existence of this code package in your manuscript, to spread the word about its existence and to ensure that you will not be accused of plagiarism by the reviewers of your manuscript.
