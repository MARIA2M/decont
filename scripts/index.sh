# This script should index the genome file specified in the first argument,
# creating the index in a directory specified by the second argument.

# The STAR command is provided for you. You should replace the parts surrounded by "<>" and uncomment it.

#Crear el archivo de salida dentro de res
mkdir -p $WD/$2

if [[-f "res/contaminants.fasta"]]
then
  # Indexado
  echo "si"
  STAR --runThreadN 4 --runMode genomeGenerate --genomeDir $2 --genomeFastaFiles $1 --genomeSAindexNbases 9
fi
