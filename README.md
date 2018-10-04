# randomized-networks-pajek

How to create randomized matrices for analyzing in Pajek

Ecological Synthesis Lab (SintECO): https://marcomellolab.wordpress.com

Author: Gabriel Félix

E-mail: gabriel.felixf@hotmail.com 

How to cite: Félix G.M. 2016. How to create randomized matrices for analyzing in Pajek. Ecological Synthesis Lab at the University
of São Paulo, Brazil.

Published in April 25th, 2017 (English version).

Run in R 3.3.3 (2017-03-06) -- "Another Canoe"

Disclaimer: You may use this script freely for non-comercial purposes at your own risk. We assume no responsibility or liability for the use of this software, convey no license or title under any patent, copyright, or mask work right to the product. We reserve the right to make changes in the software without notification. We also make no representation or warranty that such application will be suitable for the specified use without further testing or modification. If this script helps you carry out any academic work (paper, book, chapter, dissertation etc.), please acknowledge the authors and cite the source.


####################


(A) How to run the script:

1. Save both files (“nullmodels.R” and "randomized matrices.R") in the folder where you will run the analysis. In the same folder, save the TXT file with the matrix you want to randomize. Set the working directory and create the object:

setwd(“path to folder“)

data<-read.table(“yourmatrix.txt", head=TRUE)

2. As this script was written for binary networks, binarize your matrix before running the randomization:

matrix<- ifelse(data==0,0,1)

3. Load the function with the null models:

source("random_inputs_to_pajek.R")

4. Set the parameters and run the script:

random_inputs_to_pajek(matrix, methods, n_permutations = , burnin = );

matrix = object with the binary matrix created in step 2.

methods = null model to be used "r00" = Erdos Reny, "degreeprob" = Bascompte 2, or "quasiswap" and "swap" from the package vegan. To use two or more models, concatenate their names (for instance, methods = c("r00", "quasiswap"). To use all models, write "all".

n_permutations = how many randomized matrices will be created.

burnin = number of randomized matrices to be discarded. Use only when [methods = "swap”] 

5. Open the package with randomized matrices in Pajek:

> File > Pajek Project Files > Read
 
6. After opening the package, go to the tab Networks and open matrix 1.

7. Run your analysis of choice.

8. In Pajek, click on:

> Macro > Repeat Last Command

9. Do not mark any option in this window. Just click on Repeat Last Command.

10. When you see the window Input number of repetitions, write the total number of randomized matrices -1, so it repeats the analysis for all matrices but the first. Click on Yes.

11. Ready! The analysis was repeated for all matrices and the results are available on the tab Vectors.

12. The VEC file may be exported and read in any other software, such as excel.

13. If you want to run a Monte Carlo analysis to estimate a P-value in R, take the following steps:

	i. Import the vector created in Pajek:

	montecarlo=read.table(“vector.vec”, head=TRUE)

	ii. Create a new object with the observed value calculated for the original matrix:

	obs=0.40 (for instance)

	iii. Calculate the P-value as the proportion of randomized values above the observed value:

	pvalue <- sum(montecarlo>obs) / nrow(montecarlo)

	ifelse(praw > 0.5, 1-pvalue, pvalue)    # P-value


----------------------------------------------------------------------------------------


(B) Further info for advanced users.

The output of the function are random matrices saved in ".paj" format (Pajek project format). An OUTPUT folder will be created and these arrays will be saved to files separated by null model type. All arrays of the same null model are saved together.

The script will attempt to create an OUTPUT folder. If a folder with this name already exists in the working directory, it will save the files inside it. If there are files inside this folder with the names: "r00.paj", "degreeprob.paj", "quasiswap.paj", "swap.paj”;,they will be overwritten!

The structure of the first matrices randomized by the swap model has a great dependence on the structure of the original matrix. This dependency only disappears after several randomizations. I suggest using a very high burnin,> 500 or even> 1000! For more details see the instructions given in the vegan package. 
