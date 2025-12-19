#!/bin/bash

# Скрипт очистки старых логов
# Использование: ./clean_old_logs.sh /path/to/logs N

# Проверка наличия аргументов
if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <путь_к_логим> <количество_дней>"
    echo "Пример: $0 /var/log/app 7"
    exit 1
fi

LOG_DIR=$1
DAYS=$2

# Проверка существования директории
if [ ! -d "$LOG_DIR" ]; then
    echo "Ошибка: Директория $LOG_DIR не найдена."
    exit 1
fi

echo "Поиск файлов .log в $LOG_DIR старше $DAYS дней..."

# Поиск файлов (используем mtime +DAYS)
# Сохраняем список во временный файл или переменную
FILES_TO_DELETE=$(find "$LOG_DIR" -name "*.log" -type f -mtime +$DAYS)

if [ -z "$FILES_TO_DELETE" ]; then
    echo "Файлов для удаления не найдено."
    exit 0
fi

echo "Найдены следующие файлы:"
echo "$FILES_TO_DELETE"
echo ""

# Запрос подтверждения
read -p "Удалить эти файлы? (y/n): " CONFIRM

if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
    # Удаляем файлы
    # Используем xargs для обработки списка файлов
    echo "$FILES_TO_DELETE" | xargs rm -v
    echo "Очистка завершена."
else
    echo "Операция отменена."
    exit 0
fi
