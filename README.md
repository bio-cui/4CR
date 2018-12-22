# 4CR
Clinico-pathological characteristics correlation analysis

Usage:
./survival_corr.R variables_input Clinical_outcome Output

variables_input:
Matrix of gene expression values, with columns as samples and rows as genes. 

Clinical_outcome:
Response variables of survival and other clinical information. The first two columns should always be survival length and event status (death=1, alive=0). Other clinical information (e.g., age, gender, stage) could be included as later columns. The survival length could be either overall survival (OS) or progression-free survival (PFS).

Output: Output file contains the z-score and p-value for each gene tested.

Examples:
In the current folder, try the following command.

./src/survival_corr.R ./example/expression.txt ./example/OS.txt /output



K-core calculation

Usage:
./kcor.R Network Output

Network:
Network, with two columns as interacted nodes.

Output:
Two columns as Nodes and its k-core values.

Examples:
In the current folder, try the following command.

./src/kcor.R ./example/network kcors

Please contact: Xiuliang Cui (wafyai@163.com) if you have any questions or find some problems.
