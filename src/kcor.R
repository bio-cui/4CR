#!/usr/bin/env Rscript

commands=commandArgs(trailingOnly=T)

readnet=function(network) as.matrix(read.table(network, sep='\t', header=F))

network=readnet(commands[1]) #
Nedges=dim(network)[1]

nodes=union(network[,1],network[,2])  #node

net_matrix=matrix(0,length(nodes),length(nodes))
for(m in 1:Nedges){
	net_matrix[match(network[m,1],nodes),match(network[m,2],nodes)]=1
	net_matrix[match(network[m,2],nodes),match(network[m,1],nodes)]=1
}

k_cors=rep(0,length(nodes))
for(m in 1:length(k_cors)){
	l=1;
    while(l==1){
    	inter=which(k_cors==0);
        net_temp=net_matrix[inter,inter];
        x=colSums(net_temp);
        y=which(x<=m);
        if(length(y)>0 & length(inter)>0){
            k_cors[inter[y]]=m;
            l=1;
        } else{
        	l=0;
        }
    }
}
write.table(cbind(nodes,k_cors),file=paste0(output,".txt"),sep='\t',quote=F)
