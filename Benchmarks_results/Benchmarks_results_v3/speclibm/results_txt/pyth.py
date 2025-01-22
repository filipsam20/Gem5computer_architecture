import os

def process_file(filepath):
    """Reads a .txt file and converts it into a Markdown table."""
    with open(filepath, "r") as file:
        lines = file.readlines()
        
    # Extract headers and rows
    headers = lines[0].strip().split("\t")
    rows = [line.strip().split("\t") for line in lines[1:]]
    
    # Create Markdown table
    markdown_table = "| " + " | ".join(headers) + " |\n"
    markdown_table += "| " + " | ".join(["-" * len(header) for header in headers]) + " |\n"
    for row in rows:
        markdown_table += "| " + " | ".join(row) + " |\n"
    
    return markdown_table

def main(folder_path, output_file):
    """Reads all .txt files in a folder and generates a Markdown file with tables."""
    markdown_content = "# Benchmark Results\n\n"
    
    # Iterate through all files in the folder
    for filename in os.listdir(folder_path):
        if filename.endswith(".txt"):
            filepath = os.path.join(folder_path, filename)
            markdown_content += f"## {filename}\n"
            markdown_content += process_file(filepath)
            markdown_content += "\n\n"
    
    # Save the Markdown content to a file
    with open(output_file, "w") as output:
        output.write(markdown_content)

# Set the folder path containing the .txt files and output Markdown file path
folder_path = os.getcwd() + "/Benchmarks_results/Benchmarks_results_v3/speclibm/results_txt"  # Update this to your folder path
output_file = folder_path + "/benchmark_results.md"

main(folder_path, output_file)
