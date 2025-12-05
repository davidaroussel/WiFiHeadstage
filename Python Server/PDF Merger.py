from PyPDF2 import PdfMerger

def merge_pdfs(pdf1, pdf2, output_filename=r"C:\Users\david\Desktop\GAB_MERGED.pdf"):
    print("Merging PDFs...")

    merger = PdfMerger()
    merger.append(pdf1)
    merger.append(pdf2)

    merger.write(output_filename)
    merger.close()

    print(f"Done! Merged file saved as: {output_filename}")


if __name__ == "__main__":
    pdf1 = r"C:\Users\david\Desktop\GAB1.pdf"
    pdf2 = r"C:\Users\david\Desktop\GAB2.pdf"

    merge_pdfs(pdf1, pdf2)
