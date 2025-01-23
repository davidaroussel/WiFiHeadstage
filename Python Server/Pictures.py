import os
import requests
from bs4 import BeautifulSoup

# Path to your .txt file containing the HTML
html_file_path = "webpage.html.txt"

# Directory where images will be saved
output_directory = "downloaded_images"

# Function to extract image URLs and download them
def extract_and_download_images(html_file, output_dir):
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Read HTML content from the file
    with open(html_file, "r", encoding="utf-8") as file:
        html_content = file.read()

    # Parse HTML using BeautifulSoup
    soup = BeautifulSoup(html_content, "html.parser")

    # Find all image tags with a specific class
    image_tags = soup.find_all("img", {"class": "collage-photo-item__image"})
    image_urls = [img["data-src"] for img in image_tags if "data-src" in img.attrs]

    # Download each image
    for i, url in enumerate(image_urls, start=1):
        try:
            response = requests.get(url, timeout=10)
            if response.status_code == 200:
                file_name = f"image_{i}.jpg"
                file_path = os.path.join(output_dir, file_name)
                with open(file_path, "wb") as img_file:
                    img_file.write(response.content)
                print(f"Downloaded: {file_name}")
            else:
                print(f"Failed to download: {url} (Status code: {response.status_code})")
        except requests.RequestException as e:
            print(f"Error downloading {url}: {e}")

# Call the function
extract_and_download_images(html_file_path, output_directory)
