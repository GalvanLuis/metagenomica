cat ./data.txt | while read line; do
   spades.py -s $line".fastq.gz" -o ~/camda2024/gut/results/assembly_$line/
done


