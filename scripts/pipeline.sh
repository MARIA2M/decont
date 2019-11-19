
#Download all the files specified in data/filenames
for url in $(cat data/urls) #TODO
do
    bash scripts/download.sh $url data
done

# Ejercicio extra: Opción alternativa
# wget -P data -i data/urls


# Download the contaminants fasta file, and uncompress it
bash scripts/download.sh "https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz" res yes #TODO


# Index the contaminants file
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx


# Merge the samples into a single file
for sid in $(ls data/*.fastq.gz | cut -d "-" -f1 | sed 's:data/::' | sort | uniq) #TODO
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done


# TODO: run cutadapt for all merged files
# Create subfolders in log and out
mkdir -p log/cutadapt
mkdir -p out/trimmed

# Discard adatpters
for sampleid in $(ls out/merged/*.fastq.gz | cut -d "-" -f1 | sed 's:out/merged/::' | sort | uniq) #TODO
do
  if [ -f out/merged/$sampleid-12.5dpp_sRNA_merged.fastq.gz ]
  then
    # Trimming merged files
    echo "Running cutadapt..."
    cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed -o out/trimmed/$sampleid.trimmed.fastq.gz out/merged/$sampleid-12.5dpp_sRNA_merged.fastq.gz > log/cutadapt/$sampleid.log
  else
    # Print error message and exit from pipeline
    echo "ERROR: file not detected :$sampleid-12.5dpp_sRNA_merged.fastq.gz"
    exit 1
  fi
done


#TODO: run STAR for all trimmed files

# Align trimmed files against indexed contaminants list (fasta)
for fname in out/trimmed/*.fastq.gz
do
  # you will need to obtain the sample ID from the filename TtDO

  # Sample ID
  sid=$(echo $fname  | sed 's:out/trimmed/::' | cut -d "." -f1)

  # Create subfolders in star
  mkdir -p out/star/$sid

  if [ -f $fname ]
  then
    # Star aligment against indexed fasta with contaminants list (as Genome)
    echo "Running STAR alignment..."
    STAR --runThreadN 4 --genomeDir res/contaminants_idx --outReadsUnmapped Fastx --readFilesIn $fname --readFilesCommand zcat --outFileNamePrefix out/star/$sid/
  else
    # Print error message and exit from pipeline
    echo "ERROR: file not detected: $fname or res/contaminants_idx is empty"
    exit 1
  fi
done


# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci

# Sample ID loop
for sid in $(ls data/*.fastq.gz | cut -d "-" -f1 | sed 's:data/::' | sort | uniq) #TODO
do
  # Create pipeline.log with data of interest. Each run append more information.
  echo  "-------------------------------" >> log/pipeline.log
  echo  "Sample: "$sid >> log/pipeline.log
  echo  "-------------------------------" >> log/pipeline.log

  echo  "cutadapt:" >> log/pipeline.log
  echo  $(cat log/cutadapt/$sid.log  | grep -i "Reads with adapters") >> log/pipeline.log
  echo  $(cat log/cutadapt/$sid.log  | grep -i "total basepairs") >> log/pipeline.log
  echo  " " >> log/pipeline.log
  echo  "star:" >> log/pipeline.log
  echo  $(cat out/star/$sid/Log.final.out  | grep -e "Uniquely mapped reads %") >> log/pipeline.log
  echo  $(cat out/star/$sid/Log.final.out  | grep -e "% of reads mapped to multiple loci") >> log/pipeline.log
  echo  $(cat out/star/$sid/Log.final.out  | grep -e "% of reads mapped to too many loci ") >> log/pipeline.log
  echo  " " >> log/pipeline.log
  echo  " " >> log/pipeline.log
done

# Export and save environment file
mkdir envs
conda env export > envs/decont.yaml
