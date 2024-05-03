#!/bin/bash

# Считывание входной и выходной директорий
read -p "Введите входную директорию: " input_dir
read -p "Введите выходную директорию: " output_dir

# Поиск всех файлов во входной директории и ее поддиректориях
find "$input_dir" -type f -follow | while read file; do
    # Получение имени файла, расширения файла и базового имени файла
    file_name=$(basename "$file")
    file_ext="${file_name##*.}"
    file_base="${file_name%.*}"
    # Получение списка файлов в выходной директории
    output_files=( "$output_dir"/* )
    # Создание пустого списка, в котором будут храниться файлы с совпадающим базовым именем и расширением
    matching_files=()
    # Проверка каждого файла в списке output_files
    for output_file in "${output_files[@]}"; do
        # Получение имени файла, расширения файла и базового имени файла из списка output_files
        output_file_name=$(basename "$output_file")
        output_file_ext="${output_file_name##*.}"
        output_file_base="${output_file_name%.*}"
        # Проверка, совпадает ли базовое имя и расширение файла из входной директории с базовым именем и расширением файла из выходной директории
        if [[ "$output_file_base" == "$file_base" && "$output_file_ext" == "$file_ext" ]]; then
            matching_files+=("$output_file") # Добавление файла в список matching_files
        fi
    done
    # Проверка, если количество совпадающих файлов больше 0
    if [[ ${#matching_files[@]} -gt 0 ]]; then
        # Нахождение максимального номера файла
        max_number=0
        for matching_file in "${matching_files[@]}"; do
            matching_file_base=$(basename "$matching_file")
            matching_file_number="${matching_file_base#*.}"
            if [[ "$matching_file_number" =~ ^[0-9]+$ ]]; then
                max_number=$(( max_number < matching_file_number ? matching_file_number : max_number ))
            fi
        done
        # Формирование нового имени файла с увеличенным номером
        file_name="${file_base}.$(( max_number + 1 )).$file_ext"
    fi
    # Копирование файла из входной директории в выходную директорию с новым именем
    cp "$file" "$output_dir/$file_name"
done
# Вывод сообщения о завершении процесса переноса
echo "Процесс переноса завершён!"
