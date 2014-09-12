README for using the matlab code
================================

1. The structure of the source directory
----------------------------------------

### 1.1 The \*.m files

* **_loadmatrix.m_**:

The top level entry. To use the this one, just

* **_ldt\_matrix.m_**:

Returns the partial thermal resistance matrix and constant term.
They are the matrix _G = [g<sub>ij</sub>]_ and vector _D_ in equation (2)
ldt means leakage dependent on temperature

* **_leakage.m_**:

Function to compute the leakage power

* **_lp\_optimum.m_**: The relaxed linear programming algorithm

* **_lsap1\_optimum.m_**: The LSAP1 algorithm

* **_lsap2\_optimum.m_**: The LSAP2 algorithm

* **_migration\_distance.m_**: Compute the migration distance

### 1.2 The input data (under ./data/ sub directory)

### 1.3 The hotspot thermal model (under ./hotspot\_input/ sub directory)

* matrix\_b.txt
* matrix6by6.txt

These two files are actually the same. They are thermal **_conductance_** matrix
generated based on the configuration described in section 6 of this paper.

* DBAmapping.txt

This file is obtained from hotspot simulation. I need to use it to calculate the vector _D_ in equation (2).
This file contains the power consumption of all thermal nodes (core, interface, heat spreader, etc).
It is called DBAmapping.txt, because it is distributed balancing algorithm.

2. How to produce the results in the paper
------------------------------------------

### 2.1 Table 1

Just change the peak temperature *T\_target* and task mapping file as following.
And run the loadmatrix.m script.
Note that the random policy might be a little off, because the random seed
is different.

```matlab
T_target = 273.15+90;
A = load('data/debug_out_uniform.txt');
```

### 2.2 Table 4

