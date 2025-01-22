import os
import csv

# Directory containing the CSV files
directory = os.getcwd()  # Replace with your folder path
# Output file
output_file = "combined_output.csv"

# Function to write blank lines
def write_blank_lines(writer, count=10):
    for _ in range(count):
        writer.writerow([])

try:
    with open(output_file, mode='w', newline='', encoding='utf-8') as output:
        writer = csv.writer(output)

        # Loop through all files in the directory
        for filename in sorted(os.listdir(directory)):
            filepath = os.path.join(directory, filename)

            # Process only CSV files
            if os.path.isfile(filepath) and filename.endswith(".csv"):
                
                # Write the filename as a header
                writer.writerow([f"Filename: {filename}"])

                # Open the current CSV file and write its contents
                with open(filepath, mode='r', encoding='utf-8') as input_file:
                    reader = csv.reader(input_file)
                    for row in reader:
                        writer.writerow(row)

                # Add 10 blank lines after each file's content
                write_blank_lines(writer)

    print(f"All CSV files have been combined into {output_file}.")

except Exception as e:
    print(f"An error occurred: {e}")
