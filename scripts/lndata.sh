cat data.txt | while read line
do
ln -s /files/camda2024/gut/scripts/*.gz ~/camda2024/gut/data/
done

cd ~/camda2024/gut/data/
mkdir nopareados/ pareados/

mv S*.fastq.gz ./pareados/
mv *.fastq.gz ./nopareados/

cd ./pareados/
mkdir tmp/
mv *_*.fastq.gz ./tmp/
rm *.fastq.gz
cd tmp/
mv ./* ../
rm -rf tmp/

conda activate metagenomics

cd ~/camda2024/gut/data/

fastqc ./nopareados/*
fastqc ./pareados/*

mkdir -p ~/camda2024/gut/results/fastqc_untrimmed_reads
mkdir -p ~/camda2024/gut/results/fastqc_untrimmed_reads/pareados
mkdir -p ~/camda2024/gut/results/fastqc_untrimmed_reads/nopareados
mv ./nopareados/*.zip ~/camda2024/gut/results/fastqc_untrimmed_reads/nopareados/
mv ./pareados/*.zip ~/camda2024/gut/results/fastqc_untrimmed_reads/pareados/

mv ./nopareados/*.html ~/camda2024/gut/results/fastqc_untrimmed_reads/nopareados/
mv ./pareados/*.html ~/camda2024/gut/results/fastqc_untrimmed_reads/pareados/

cd ~/camda2024/gut/results/fastqc_untrimmed_reads/pareados/
for filename in *.zip
do
unzip $filename
done

cd ~/camda2024/gut/results/fastqc_untrimmed_reads/nopareados/
for filename in *.zip
do
unzip $filename

mkdir -p ~/camda2024/gut/docs/
cat ./*/summary.txt > ~/camda2024/gut/docs/fastqc_summaries.txt
cat ../pareados/*/summary.txt >> ~/camda2024/gut/docs/fastqc_summaries.txt
