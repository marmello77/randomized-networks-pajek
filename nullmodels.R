
nullmodels=function(matrix, model, nsimulations) {
  
  randomizations=NULL
  
  nullmodel_ff=function (MATRIX, nsim) {
    
    r<-dim(MATRIX)[1]
    c<-dim(MATRIX)[2]
    ROW <- rep(0,c)
    
    ff_randomization=NULL
    
    
    for(aa in 1:nsim) {#for each null matrix
      
      TEST <- MATRIX; #start with the input matrix
      
      for(rep in 1:(5*r)) {
        
        AB <- sample(1:r,2) #choose two rows
        A <- TEST[AB[1],] #vector of elements in row 1
        J <- A - TEST[AB[2],]# difference between row 1 and row 2
        
        if((max(J) - min(J)) == 2) { #if uniques(a column with 1 in one row, 0 in other) in both rows can perform a swap.
          tot <- which(abs(J)==1)  #all unique indices
          l_tot <- length(tot) #num uniques
          tot <- sample(tot,l_tot)  #shuffled uniques
          both <- which(J==0 & A==1)  #things that appear (precenses) in both rows
          L <- sum(J==1) #sum of uniques in row 1. ( 1-0 )
          ROW1 <- c(both, tot[1:L])  #row1 presences
          ROW2 <- c(both, tot[(L+1):l_tot]) #new row 2 presences
          
          
          I <- ROW
          I[ROW1] <- 1
          K <- ROW
          K[ROW2] <- 1
          TEST[AB,] <- rbind(I,K)
          
        }
      }
      ff_randomization[[aa]]=TEST
    }
    return(ff_randomization)
  }
  
  nullmodel_r00 = function(MATRIX, nsim) {
    
    r <- dim(MATRIX)[1]
    c <- dim(MATRIX)[2]	#Sizes of rows and columns
    
    r00_randomization=NULL
    
    for (aa in 1:nsim) {
      TEST<-0*MATRIX
      LENr<-1:r #vector of rows
      LENc<-1:c #vector of cols
      count1<-r 
      count2<-c
      FILL<-sum(MATRIX>0) #Filled positions
      
      
      #stage1a - fill in 1 element for each row&col such that dimensions will be
      #preserved (i.e. no chance of getting empty rows/cols and changing matrix
      #dimensions).
      
      while (count1>0 && count2>0) {
        
        randa<-sample(count1, 1)
        randb<-sample(count2, 1)
        
        TEST[LENr[randa],LENc[randb]]=1
        
        LENr<-LENr[-randa]
        LENc<-LENc[-randb]
        
        count1<-count1-1
        count2<-count2-1
        FILL<-FILL-1
      }
      
      
      #stage1b - once all rows(cols) have something in, need to fill in cols
      #(rows) with completely random rows(cols)
      
      if (count1>0) {
        while (count1>0) {
          randa<-1
          randb<-sample(c,1)
          
          TEST[LENr[randa],randb]<-1
          LENr<-LENr[-randa]
          FILL<-FILL-1    
          count1<-count1-1
        }
      } 
      else if (count2>0) {
        while (count2>0) {
          randb<-1
          randa<-sample(r,1)
          
          TEST[randa,LENc[randb]]<-1
          LENc<-LENc[-randb]
          FILL<-FILL-1  
          count2<-count2-1
        }
      }
      
      #stage2 - Once dimensions are conserved, need to add extra elements to
      #preserve original matrix fill.
      
      for (d in 1:FILL) {
        
        flag<-0;
        while (flag==0) {
          randa<-sample(r, 1)
          randb<-sample(c, 1)
          
          if (TEST[randa,randb]==0) {
            TEST[randa,randb]<-1
            flag<-1
          }
        }
      }
      
      r00_randomization[[aa]]=TEST
      
    }
    
    return(r00_randomization)
    
  }
  
  nullmodel_degreeprob=function(MATRIX, nsim) {
    
    r<-dim(MATRIX)[1]
    c<-dim(MATRIX)[2]
    
    coldegreesprop<-(colSums(MATRIX>0))/r
    rowdegreesprop<-(rowSums(MATRIX>0))/c
    
    degreeprob_randomization=NULL
    for (aa in 1:nsim) {
      flag=0
      while (flag == 0) {
        
        
        #Fill up each matrix element probabilistically depending on the matrix dimensions and
        #degree distribution
        
        
        TEST<- 1* ( array(runif(r*c), dim=c(r,c)) < 0.5* (array(rep(coldegreesprop,rep(r,c)), dim=c(r,c)) + array(rep(rowdegreesprop,c),dim=c(r,c))) ) 
        
        flag=1
        if (length(dim(TEST)) < 2) {flag=0}
      }
      
      subset1=which(rowSums(TEST)>0)
      subset2=which(colSums(TEST)>0)
      TEST=TEST[subset1,subset2]
      
      degreeprob_randomization[[aa]]=TEST
    }
    return(degreeprob_randomization)
  }
  
  if ("all" %in% model && length(model)==1) {
    r00_matrices=nullmodel_r00(MATRIX = matrix, nsim = nsimulations) 
    ff_matrices=nullmodel_ff(MATRIX = matrix, nsim = nsimulations) 
    degreeprob_matrices=nullmodel_degreeprob(MATRIX = matrix, nsim = nsimulations)
    
    randomizations$r00=r00_matrices
    randomizations$ff=ff_matrices
    randomizations$degreeprob=degreeprob_matrices
    
  }
  
  else { 
    
    if ("r00" %in% model) { r00_matrices=nullmodel_r00(MATRIX = matrix, nsim = nsimulations); randomizations$r00=r00_matrices }
    if ("ff" %in% model) { ff_matrices=nullmodel_ff(MATRIX = matrix, nsim = nsimulations); randomizations$ff=ff_matrices }
    if ("degreeprob" %in% model) { degreeprob_matrices=nullmodel_degreeprob(MATRIX = matrix, nsim = nsimulations); randomizations$degreeprob=degreeprob_matrices }
  
  
  }

  return(randomizations)
}

