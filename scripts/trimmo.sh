for infile in *.fastq.gz
do
base=$(basename ${infile} .fastq.gz)
trimmomatic SE ${infile} ${base}.trim.fastq.gz \
SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
done
