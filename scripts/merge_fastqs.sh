# This script should merge all files from a given sample (the sample id is provided in the third argument)
# into a single file, which should be stored in the output directory specified by the second argument.
# The directory containing the samples is indicated by the first argument.

# Create subfolders in out
mkdir -p $2

# Check if file required exist
if [ -f $1 ]
then
  echo "Mergin files..."
# Merge file with the same Sample ID
cat $1/$3-12.5dpp.1.1s_sRNA.fastq.gz $1/$3-12.5dpp.1.2s_sRNA.fastq.gz  > $2/$3-12.5dpp_sRNA_merged.fastq.gz
else
  # Print error message and exit from pipeline
  echo "ERROR: file not detected from sample: $3"
  exit 1
fi
