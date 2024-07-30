import csv
import os
import chardet
import re

def check_csv(file_path):
    try:
        # Get file metadata
        file_info = os.stat(file_path)
        file_size = file_info.st_size
        creation_time = file_info.st_ctime

        # Detect file encoding
        with open(file_path, 'rb') as file:
            encoding = chardet.detect(file.read())['encoding']

        with open(file_path, newline='', encoding=encoding) as csvfile:
            reader = csv.reader(csvfile)
            data = list(reader)

            num_rows = len(data)
            num_columns = len(data[0]) if num_rows > 0 else 0
            column_names = data[0] if num_rows > 0 else []

            print(f"CSV File Information:")
            print(f"File Path: {file_path}")
            print(f"File Size (bytes): {file_size}")
            print(f"Creation Time: {creation_time}")
            print(f"Encoding Type: {encoding}")
            print(f"Number of Rows: {num_rows}")
            print(f"Number of Columns: {num_columns}")
            print(f"Column Names: {', '.join(column_names)}")
            print(f" ---- ")


            # print("\nSample Data (first 5 rows):")
            # for row in data[1:6]:  # Display the first 5 rows of data
            #     print(row)

            # Check for potential issues
            for i, row in enumerate(data):
                for j, field in enumerate(row):
                    # Check for quote marks within fields
                    # if '"' in field:
                    #     print(f"Warning: Quote marks within field detected at row {i+1}, column {j+1}: {field}")

                    # Check for mismatched quotes
                    if re.search(r'(?<!")"([^"]*)"([^"]*)"(?![^,])', field):
                        print(f"Warning: Mismatched quotes detected at row {i+1}, column {j+1}: {field}")

                    if field.count('"') % 2 != 0:
                        print(f"Warning: Odd number of double-quote characters detected at row {i+1}, column {j+1}: {field}")
                        print(field)

                    # Check for incomplete rows
                    if len(row) != num_columns:
                        print(f"Warning: Incomplete row detected at row {i+1}. Expected {num_columns} columns, found {len(row)}.")

                    # Check for special characters or line endings
                    if re.search(r'[\x00-\x08\x0B\x0C\x0E-\x1F]', field):
                        print(f"Warning: Special characters or line endings detected at row {i+1}, column {j+1}: {field}")

        print("\nCSV File analysis completed.")

    except FileNotFoundError:
        print(f"The file '{file_path}' was not found.")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

if __name__ == "__main__":
    fileName = input("Enter the file name:  ")
    check_csv(fileName)

