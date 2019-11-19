# This script should download the file specified in the first argument ($1), place it in the directory specified in the second argument,
# and *optionally* uncompress the downloaded file with gunzip if the third argument contains the word "yes".

# Nombre del archivo que queremos descargar
fasta_file=$(basename $1)

echo "Descargango archivo: "$fasta_file" en la carpeta "$2
echo "-----------------------------------------------------"
wget  -P $2 $1


if  [ "$3" == "yes" ]
then
  echo "Descomprimiendo archivo"$fasta_file
  echo "-----------------------------------------------------"
  gunzip $2/$fasta_file
fi


# Ejercicio extra: Opción alternativa
# wget -P $2 -i $2/urls
