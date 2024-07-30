import csv

def print_specific_line(csv_file, line_number, encoding):
    try:
        with open(csv_file, 'r', encoding=encoding, newline='') as file:
            reader = csv.reader(file)
            lines = list(reader)
            
            if 1 <= line_number <= len(lines):
                print(f"Line {line_number}: {lines[line_number - 1]}")
            else:
                print(f"Line number {line_number} is out of range.")
    except FileNotFoundError as e:
        print(f"File '{csv_file}' not found.")
        print(e)
    except UnicodeDecodeError as e:
        print(f"Unable to decode the file using {encoding} encoding. Please check the file's encoding.")
        print(e)

if __name__ == "__main__":
    csv_file = input("Enter the path to the CSV file: ")
    line_number = int(input("Enter the line number to print: "))
    encoding = input("Enter the file encoding (default is utf-8)") or "UTF-8"

    
    
    print_specific_line(csv_file, line_number, encoding)

