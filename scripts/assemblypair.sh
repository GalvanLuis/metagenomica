cat ./data.txt | while read line; do
   spades.py -1 $line"_1_val_1.fq.gz" -2 $line"_2_val_2.fq.gz" -o ~/camda2024/gut/results/assembly_$line/
done
