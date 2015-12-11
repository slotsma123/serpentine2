#!/usr/bin/env Rscript
# This script is to make boxplot for hotspot coverage - this script is modfied from Rajesh's boxplot.R 

## example: 
# circosPlot.R -f "SUBJECT/32/32T/ucsc.hg19.bwamem/qc/32T.final.bam.hotspot.depth SUBJECT/32/32N/ucsc.hg19.bwamem/qc/32N.final.bam.hotspot.depth" -o  SUBJECT/32/ucsc.hg19.bwamem/32_clin.ex.v1.circosPlot.png
# opt=NULL
# opt$hotspotFiles="SUBJECT/32/32T/ucsc.hg19.bwamem/qc/32T.final.bam.hotspot.depth SUBJECT/32/32N/ucsc.hg19.bwamem/qc/32N.final.bam.hotspot.depth"
# opt$outName = 'SUBJECT/32/ucsc.hg19.bwamem/32_clin.ex.v1.hotspot_coverage.png'

suppressPackageStartupMessages(library("optparse"))
option_list <- list( 
	make_option(c("-f", "--hotspotFiles"), help="hotspotFiles, required"),
	make_option(c("-o", "--outName"), default='circosPlot.png', help="output name. [default: %default]"),
	make_option(c("-v", "--verbose"), action="store_true", default=TRUE,
	help="to output some information about a job.  [default: %default]")		
    )

# get command line options, if help option encountered print help and exit,
opt <- parse_args(OptionParser(option_list=option_list))
if( ! is.element('hotspotFiles', names(opt)) ) stop("Option for hotspotFiles is required. ")

library(RColorBrewer)

files <- strsplit(opt$hotspotFiles, split="[\\s,;]", perl=TRUE)[[1]]
labs <- basename( gsub(".final.bamhotspot.depth", "", files, perl=TRUE) )
cols <- brewer.pal(length(files)+1, "Dark2")

## y max
y_max =0 
for (i in 1:length(files)){
    cov.data   <-read.table(files[i], sep="\t", quote="", head=F);
    cov.data <-cov.data[,6]
    if (max(cov.data) > y_max){ 
            y_max = max(cov.data)}
}
##

png(opt$outName,width = 1000, height = 1000, res=100);
par(mar = c(18, 5, 4, 2) + 0.1)
plot(10,10,  xlim=c(1,length(files)+1), ylim=c(0,y_max+1), xaxt='n', yaxt="n", xlab='', ylab='Coverage', main="Hotspot Coverage")

for (i in 1:length(files)){
    cov.data   <-read.table(files[i], sep="\t", quote="", head=F);
    cov.data <-cov.data[,6]

    axis(1, labels=labs[i], at=i+0.5, las = 2, col=c(cols[i]), col.ticks =cols[i])
    boxplot(cov.data, add=T, at=i+0.5, las = 2, border=cols[i])
}
dev.off()
