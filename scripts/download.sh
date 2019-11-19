# This script should download the file specified in the first argument ($1), place it in the directory specified in the second argument,
# and *optionally* uncompress the downloaded file with gunzip if the third argument contains the word "yes".

# Name of file in url
file_name=$(basename $1)

# Check if file exists and download it
if [ ! -f "$2/$file_name" ]
then
  echo "Downloading file: "$file_name" in the folder "$2
  echo "---------------------------------------------------------------------"
  echo
  wget  -P $2 $1
else
  echo "The file $file_name have already been downloaded"
  echo
fi

# Check third argument to unzip the file
if  [ "$3" == "yes" ]
then
  if [ -f "$2/$file_name" ]
  then
    echo "Unzipping file: "$file_name
    echo "---------------------------------------------------------------------"
    gunzip -k $2/$file_name
  fi
fi
