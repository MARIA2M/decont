
export WD=$(pwd)

#Download all the files specified in data/filenames
for url in $(cat $WD/data/urls) #TODO
do
    #bash scripts/download.sh $url data
    echo "hola"
done

# Download the contaminants fasta file, and uncompress it
#bash scripts/download.sh "https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz" res yes #TODO

# Index the contaminants file
#bash scripts/index.sh $WD/res/contaminants.fasta $WD/res/contaminants_idx

# Merge the samples into a single file
for sid in $(ls data/*.fastq.gz | cut -d "-" -f1 | sed 's:data/::' | sort | uniq) #TODO
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done

# TODO: run cutadapt for all merged files
echo "Running cutadapt..."
mkdir -p log/cutadapt
mkdir -p out/cutadapt
for sampleid in $(ls out/merged/*.fastq.gz | cut -d "-" -f1 | sed 's:out/merged/::' | sort | uniq) #TODO
do
  cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed -o out/cutadapt/${sampleid}.trimmed.fastq.gz out/merged/${sampleid}-12.5dpp_sRNA_merged.fastq.gz > log/cutadapt/${sampleid}.log
done

#TODO: run STAR for all trimmed files
#for fname in out/trimmed/*.fastq.gz
#do
    # you will need to obtain the sample ID from the filename
#    sid=#TODO
    # mkdir -p out/star/$sid
    # STAR --runThreadN 4 --genomeDir res/contaminants_idx --outReadsUnmapped Fastx --readFilesIn <input_file> --readFilesCommand zcat --outFileNamePrefix <output_directory>
#done

# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
