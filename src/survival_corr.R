#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(survival))

readmat=function(mat) as.matrix(read.table(mat, sep='\t', header=T, check.names=F, quote=NULL))

commands=commandArgs(trailingOnly=T)

mat=t(readmat(commands[1])) # expression matrix
survivalin = readmat(commands[2]) # clinical information

# remove negative survival values
survival = survivalin[survivalin[,1] > 0,]

output = commands[3]

common = Reduce(intersect, list(rownames(mat),rownames(survival)))
print(paste(length(common), "samples"))

# stop at low sample numbers
if(length(common) < 20) stop("two few samples")

mat = mat[common,,drop=F]
survival = survival[common,,drop=F]

# split up survival and background
surv = Surv(survival[,1], survival[,2])

if(dim(survival)[2] > 2){
  B = survival[,3:dim(survival)[2], drop=F]
}else{
  B = survival[,c(), drop=F]
}

# build up regression data space

genes=colnames(mat)
N = length(genes)

result_pz = matrix(nrow=N, ncol=2, dimnames=list(genes, c('z','p')))

for (i in 1:N)
{
  title = genes[i]
  expg = mat[,i]
  pivot=rep(0,length(expg))
  pivot[which(expg>median(expg))]=1
  B1 = cbind(B, pivot)
  B1 = as.data.frame(B1)
  errflag = F
  coxph.fit = tryCatch(coxph(surv~., data=B1),
                       error = function(e) errflag <<- T,
                       warning = function(w) errflag <<- T)
  
  if(!errflag)
  {
    reg.summary = summary(coxph.fit)$coef
    result_pz[i,] = reg.summary["pivot", c("z", "Pr(>|z|)")]
  }
}

write.table(result_pz, paste0(output, ".txt"),sep='\t',quote=F)
