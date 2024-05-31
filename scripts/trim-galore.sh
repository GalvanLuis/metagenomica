#!/bin/bash

# Function to remove the third file (without suffix)
remove_third_file() {
  local folder_path="$1"  # Capture the folder path passed as argument

  for filename in "$folder_path"/*; do
    # Skip directories
    [[ -d "$filename" ]] && continue

    # Extract base name and extension
    base_name="${filename%.*}"
    ext="${filename##*.}"

    # Check if extension matches (adjust if needed)
    if [[ "$ext" == "fastq.gz" ]]; then
      # Find matching files with the same base name (excluding itself)
      matching_files=("$folder_path/"{${base_name}_*,$folder_path/"$base_name"})  # Include base name without extension with path

      # Check if there are exactly 3 matching files
      if [[ ${#matching_files[@]} -eq 3 ]]; then
        # Find the third file (without extension or trailing underscore)
        third_file="${matching_files[@]##*/}"  # Double colon for parameter expansion, remove path
        third_file="${third_file%%_*}"  # Remove trailing underscore

        # Remove the unwanted file if it doesn't have an underscore and number
        if [[ ! "$third_file" =~ _[0-9]+ ]]; then
          rm -f "$folder_path/$third_file.fastq.gz"  # Rebuild full path with extension
        fi
      fi
    fi
  done
}

# Get the folder path (modify as needed)
folder_path="~/camda2024/gut/data/"

# Call the function
remove_third_file "$folder_path"

echo "Third files (without underscore and number) removed for groups with differing suffixes in '$folder_path'."


#eliminar archivos

#for infile in *_1.fastq.qz
#do
#base=$(basename ${infile}_1.fastq.gz)
#echo trimmomatic PE ${infile} ${base}_2.fastq.gz \
#${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz \
#${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz \
#SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
#done

