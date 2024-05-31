cat data.txt | while read line
do
kraken2 --db /files/db_kraken2 --threads 8 --paired $line.trim.1.val.1.fq.gz $line.trim.2.val.2.fq.gz --output ~/camda2024/gut/taxonomy/kraken/$line.kraken --report ~/camda2024/gut/taxonomy/kraken/$line.report
done
