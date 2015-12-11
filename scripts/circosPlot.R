#!/usr/bin/env Rscript
# This script is to make circosPlot - this script is modfied from Rajesh's circos.R 

## example: 
# circosPlot.R -f "SUBJECT/32/32T/ucsc.hg19.bwamem/genotyping/32T.loh SUBJECT/32/32N/ucsc.hg19.bwamem/genotyping/32N.loh" -o  SUBJECT/32/ucsc.hg19.bwamem/32_clin.ex.v1.circosPlot.png
# opt=NULL
# opt$lohFiles="SUBJECT/32/32T/ucsc.hg19.bwamem/genotyping/32T.loh SUBJECT/32/32N/ucsc.hg19.bwamem/genotyping/32N.loh"
# opt$outName = 'SUBJECT/32/ucsc.hg19.bwamem/32_clin.ex.v1.circosPlot.png'

suppressPackageStartupMessages(library("optparse"))
option_list <- list( 
	make_option(c("-f", "--lohFiles"), help="lohFile, required"),
	make_option(c("-o", "--outName"), default='circosPlot.png', help="output name. [default: %default]"),
	make_option(c("-v", "--verbose"), action="store_true", default=TRUE,
	help="to output some information about a job.  [default: %default]")		
    )

# get command line options, if help option encountered print help and exit,
opt <- parse_args(OptionParser(option_list=option_list))

if( ! is.element('lohFiles', names(opt)) ) stop("Option for lohFiles is required. ")

suppressPackageStartupMessages(library(OmicCircos))
library(stringr)
library(RColorBrewer)
    
files <- strsplit(opt$lohFiles, split="[\\s,;]", perl=TRUE)[[1]]
labs <- basename( gsub(".loh", "", files, perl=TRUE) )
cols <- brewer.pal(length(files)+1, "Dark2")

#color<-c("salmon2","palevioletred1","rosybrown","red2","dodgerblue1","dodgerblue3");

options(stringsAsFactors = FALSE);
set.seed(1234);
png(opt$outName, width = 1000, height = 1000, res=100);
par(mar=c(2, 2, 2, 2));
plot(c(1,800), c(1,800), type="n", axes=FALSE, xlab="", ylab="", main="");

circos(R=400, cir="hg19", type="chr", mapping=UCSC.hg19.chr, print.chr.lab=TRUE, W=10, lwd=5);

r=350
for (i in 1:length(files)){
        LOH.data   <-read.table(files[i], sep="\t", quote="", head=T);
        circos(cir="hg19", R=r, W=50, type="s", mapping=LOH.data, col.v=3, col=cols[i], B=TRUE, cex=0.0001, lwd=1);
        r=r-45;
}
legend("topright", legend=labs, col=cols, lty=1, lwd=4)
dev.off()
