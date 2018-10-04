#################################################################
#                                                               # 
#   SCRIPT FOR RANDOMIZING MATRICES USING NULL MODELS IN R      #
#                                                               # 
#################################################################

##### Ecological Synthesis Lab (SintECO)
##### www.marcomello.org
##### Author: Gabriel Félix
##### E-mail: gabriel.felixf@hotmail.com 
##### How to cite: Félix G.M. 2016. How to create randomized matrices for
##### analyzing in Pajek. Ecological Synthesis Lab at the University
##### of São Paulo, Brazil.
##### Published in April 25th, 2017 (English version).
##### Run in R 3.3.3 (2017-03-06) -- "Another Canoe"

##### Disclaimer: You may use this script freely for non-comercial purposes
##### at your own risk. We assume no responsibility or liability
##### for the use of this software, convey no license or title under
##### any patent, copyright, or mask work right to the product. We
##### reserve the right to make changes in the software without notification. 
##### We also make no representation or warranty that such application will 
##### be suitable for the specified use without further testing or modification.
##### If this script helps you carry out any academic work
##### (paper, book, chapter, dissertation etc.), please acknowledge
##### the authors and cite the source.



#Call the function with the null models
source("nullmodels.R")

random_input_to_pajek=function(matrix, methods, n_permutations, burnin) {
  
  dir.create("OUTPUT", showWarnings = F)
  
  
#Load the packages
  library("reshape2")
  library("vegan")

  permutations=NULL
  

#Run the randomizations using the null models equiprobable and degree-probable using the function "nullmodels.R"

  if ("r00" %in% methods | "all" %in% methods) {r00=nullmodels(matrix, model = "r00", nsimulations = n_permutations); permutations$r00=r00$r00}
  
  if ("degreeprob" %in% methods | "all" %in% methods) {degreeprob=nullmodels(matrix, model = c("degreeprob"), nsimulations = n_permutations); permutations$degreeprob=degreeprob$degreeprob}

   
#Run the randomizations using the null models  quasiswap e FF in the package vegan
  
  if ("quasiswap" %in% methods | "all" %in% methods) {quasiswap=permatfull(matrix, fixedmar = "both", mtype = "prab", times = n_permutations); permutations$quasiswap=quasiswap$perm}
  
  if ("ff" %in% methods | "all" %in% methods) {ff=permatswap(matrix, method = "swap", fixedmar = "both", mtype = "prab", times = n_permutations, burnin = burnin); permutations$ff=ff$perm}

  
#Save the randomized matrices in Pajek format    

  nn=names(permutations)

  for (mm in 1:length(permutations)) {
  
    for (ii in 1:length(permutations[[mm]])) {
      rows=nrow(permutations[[mm]][[ii]])
      col=ncol(permutations[[mm]][[ii]])
      tot=rows+col
      linhas=1:tot
      nomes=1:tot
      x=rep(0.000,tot)
      y=x
      z=rep(0.5,tot)
      primeiro=cbind.data.frame(linhas, nomes, x, y, z)
      rownames(primeiro)=primeiro[,2]
  
      matrix_random=permutations[[mm]][[ii]]
      matrix_random[matrix_random==0]=NA
      matrix_random=as.matrix(matrix_random)
      rownames(matrix_random)=1:rows
      colnames(matrix_random)=(1:col)+rows
      lista=melt(matrix_random, na.rm =T)
  
      net=paste("*Network", ii, sep = " ")
      vert=paste("*Vertices",tot, rows, sep=" ")
      edge="*Edges"
      if (ii==1) { 
        cat(net,vert, file=paste("OUTPUT/",nn[mm], ".paj", sep = ""), sep = "\n")
        write.table(primeiro, file=paste("OUTPUT/",nn[mm], ".paj", sep = ""), row.names = F, col.names = F, append = T)
        cat(edge, file=paste("OUTPUT/",nn[mm], ".paj", sep = ""), append = T, sep = "\n")
        write.table(lista, file=paste("OUTPUT/",nn[mm], ".paj", sep = ""), row.names = F, col.names = F, append = T )
      }
      else if (ii!=1) {
        cat(net,vert, file=paste("OUTPUT/",nn[mm], ".paj", sep = ""), sep = "\n", append = T)
        write.table(primeiro, file=paste("OUTPUT/",nn[mm], ".paj", sep = ""), row.names = F, col.names = F, append = T)
        cat(edge, file=paste("OUTPUT/",nn[mm], ".paj", sep = ""), append = T, sep = "\n")
        write.table(lista, file=paste("OUTPUT/",nn[mm], ".paj", sep = ""), row.names = F, col.names = F, append = T )
      }
    }
  }
  return(permutations = permutations)
}