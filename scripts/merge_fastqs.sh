# This script should merge all files from a given sample (the sample id is provided in the third argument)
# into a single file, which should be stored in the output directory specified by the second argument.
# The directory containing the samples is indicated by the first argument.

# Crear ruta de salida
mkdir -p $WD/$2

# Merge archivos del mismo tipo según su sample_id
cat $WD/$1/$3-12.5dpp.1.1s_sRNA.fastq.gz $WD/$1/$3-12.5dpp.1.2s_sRNA.fastq.gz  > $WD/$2/$3-12.5dpp_sRNA_merged.fastq.gz
