# This script should index the genome file specified in the first argument,
# creating the index in a directory specified by the second argument.
# The STAR command is provided for you. You should replace the parts surrounded by "<>" and uncomment it.

# Create subfolders in res
mkdir -p $2

# Check if file required exist
if [ -f $1 ]
then
  # Indexing fasta file with contaminants list to be used as "Genome"
  echo "Running STAR index..."
  STAR --runThreadN 4 --runMode genomeGenerate --genomeDir $2 --genomeFastaFiles $1 --genomeSAindexNbases 9
else
    # Print error message and exit from pipeline
  echo "ERROR: file not detected: contaminants.fasta"
  exit 1
fi
