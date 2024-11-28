import os
import shutil
from datetime import datetime
from PyPDF2 import PdfMerger


def merge_pdfs(folder_path, timestamp):
    # Initialize PdfMerger object
    merger = PdfMerger()
    original_folder = os.path.join(folder_path, "Documents Originaux")
    target_folder = os.path.join(folder_path, "Documents Joints")

    # List and sort all PDF files in the specified folder
    pdf_files = [f for f in os.listdir(original_folder) if f.endswith('.pdf')]

    # Check if there are any PDF files to merge
    if not pdf_files:
        print("No PDF files to merge. Exiting...")
        return False

    pdf_files.sort()  # Optional: sort alphabetically or by any other logic

    # Add each PDF file to the merger
    for pdf_file in pdf_files:
        file_path = os.path.join(original_folder, pdf_file)
        merger.append(file_path)

    # Define the output file path
    output_path = os.path.join(target_folder, f"{timestamp}.pdf")

    # Write the merged PDF to file
    with open(output_path, "wb") as output_pdf:
        merger.write(output_pdf)

    # Close the merger
    merger.close()
    print(f"Merged PDF saved as: {output_path}")
    return True


def archive_files(folder_path, timestamp):
    original_folder = os.path.join(folder_path, "Documents Originaux")

    # Create a new folder with current datetime as name (formatted as YYYYMMDD_HHMMSS)
    archive_folder = os.path.join(folder_path, "Archives", timestamp)
    os.makedirs(archive_folder, exist_ok=True)

    # Move each PDF file to the archive folder
    for file_name in os.listdir(original_folder):
        file_path = os.path.join(original_folder, file_name)
        if os.path.isfile(file_path) and file_name.endswith('.pdf'):
            shutil.move(file_path, archive_folder)

    print(f"Archive created at: {archive_folder}")


if __name__ == "__main__":
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    # Automatically find the Desktop path for the current user
    desktop_path = os.path.expandvars(os.path.join("%USERPROFILE%", "Desktop", "Merge PDF"))

    # Perform the PDF merging
    if merge_pdfs(desktop_path, timestamp):
        # Archive the files only if merging was successful
        archive_files(desktop_path, timestamp)
