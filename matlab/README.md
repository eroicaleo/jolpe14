README for using the matlab code
================================

1. The structure of the source directory
----------------------------------------

### 1.1 The \*.m files

* **_loadmatrix.m_**:
The top level entry

* **_ldt\_matrix.m_**:
Returns the partial thermal resistance matrix and constant term.
They are the matrix _[g<sub>ij</sub>]_ and vector _D_ in equation (2)

* **_leakage.m_**: Function to compute the leakage power

**_lp\_optimum.m_**: The relaxed linear programming algorithm

**_lsap1\_optimum.m_**: The LSAP1 algorithm

**_lsap2\_optimum.m_**: The LSAP2 algorithm

**_migration\_distance.m_**: Compute the migration distance

### 1.2 The input data (under ./data/ sub directory)

### 1.3 The hotspot thermal model (under ./hotspot\_input/ sub directory)

* matrix\_b.txt
* matrix6by6.txt

These two files are actually the same. They are thermal conductance matrix
generated based on the configuration described in section 6 of this paper.

2. How to produce the results in the paper
------------------------------------------

### 2.1 Table 4
