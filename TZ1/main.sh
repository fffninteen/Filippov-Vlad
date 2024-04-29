#!/bin/bash

read -p "Введите входную директорию: " input_dir
read -p "Введите выходную директорию: " output_dir


find "$input_dir" -type f -follow | while read file; do

    file_name=$(basename "$file")
    file_ext="${file_name##*.}"
    file_base="${file_name%.*}"

    output_files=( "$output_dir"/* )
    matching_files=()
    for output_file in "${output_files[@]}"; do
        output_file_name=$(basename "$output_file")
        output_file_ext="${output_file_name##*.}"
        output_file_base="${output_file_name%.*}"

        if [[ "$output_file_base" == "$file_base" && "$output_file_ext" == "$file_ext" ]]; then
            matching_files+=("$output_file")
        fi
    done

    if [[ ${#matching_files[@]} -gt 0 ]]; then
        max_number=0
        for matching_file in "${matching_files[@]}"; do
            matching_file_base=$(basename "$matching_file")
            matching_file_number="${matching_file_base#*.}"
            if [[ "$matching_file_number" =~ ^[0-9]+$ ]]; then
                max_number=$(( max_number < matching_file_number ? matching_file_number : max_number ))
            fi
        done

        file_name="${file_base}.$(( max_number + 1 )).$file_ext"
    fi
    cp "$file" "$output_dir/$file_name"
done

echo "Процесс переноса завершён!"