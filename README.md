# task offloading for edge computing: simulation
This repo contains the simulation code used in the following publications.
1. Chang Shu, Zhiwei Zhao*, Yunpeng Han, Geyong Min and Hancong Duan, Multi-User Offloading for Edge Computing Networks: A Dependency-Aware and Latency-Optimal Approach (extended), `IEEE Internet-of-Things Journal`, 2020.
2. Chang Shu, Zhiwei Zhao*, Yunpeng Han and Geyong Min, Dependency-Aware and Latency-Optimal Computation Offloading for Multi-User Edge Computing Networks (extension to IoTJ), `IEEE SECON 2019`, Boston, USA, June 10-13, 2019.
3. Yunpeng Han, Zhiwei Zhao*, Jiwei Mo, Chang Shu and Geyong Min, Efficient Task Offloading with Dependency Guarantees in Ultra-Dense Edge Networks, `IEEE GlobeCom 2019`, HI, USA, Dec 9-13, 2019.

Please copy the following bib info for citations. 
<pre><code>
@article{shu2020IoTJ, 
author={C. {Shu} and Z. {Zhao} and Y. {Han} and G. {Min} and H. {Duan}}, 
journal={IEEE Internet of Things Journal}, 
title={Multi-User Offloading for Edge Computing Networks: A Dependency-Aware and Latency-Optimal Approach}, 
year={2020}, 
volume={7}, 
number={3}, 
pages={1678-1689},
} 
</code></pre>


## 中文描述
这份代码包含分别发表在SECON 2019、GLOBECOM 2019和IoT Journal上的三篇paper的仿真程序，论文原文见/paper文件夹。 <br>
其中DAG调度策略是参照OS调度中比较经典的HEFT算法提出的，我们修改HEFT算法使之适应研究设定的边缘计算卸载场景。<br>
关于HEFT算法，可参照[这里](https://ieeexplore.ieee.org/document/993206)
