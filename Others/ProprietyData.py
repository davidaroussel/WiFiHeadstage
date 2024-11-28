import requests
from bs4 import BeautifulSoup

# Function to scrape Centris listings for multiple pages
def scrape_cetris_listings(num_pages):
    # Base URL for Centris search results (adjust as needed)
    base_url = "https://www.centris.ca/en/properties~for-sale"

    # Headers to mimic a browser
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
    }

    # List to store all property data
    all_properties = []

    # Iterate over the defined number of pages
    for page in range(1, num_pages + 1):
        # Construct the URL for the current page
        url = f"{base_url}?page={page}"

        # Send a GET request
        response = requests.get(url, headers=headers)

        if response.status_code == 200:
            # Parse the HTML content
            soup = BeautifulSoup(response.text, "html.parser")

            # Find all property items on the page
            property_items = soup.find_all("div", class_="property-thumbnail-item")

            for item in property_items:
                try:
                    # Extract thumbnail image URL
                    thumbnail_url = item.find("img", itemprop="image")["src"]

                    # Extract property name
                    property_name = item.find("meta", itemprop="name")["content"]

                    # Extract MLS number (SKU)
                    mls_number = item.find("meta", itemprop="sku")["content"]

                    # Extract price
                    price = item.find("div", class_="price").find("span").text.strip()

                    # Extract address
                    address_divs = item.find("div", class_="address").find_all("div")
                    address = ", ".join(div.text.strip() for div in address_divs)

                    # Extract property category
                    category = item.find("div", class_="category").text.strip()

                    # Append the extracted data to the list
                    all_properties.append({
                        "Thumbnail URL": thumbnail_url,
                        "Property Name": property_name,
                        "MLS Number": mls_number,
                        "Price": price,
                        "Address": address,
                        "Category": category,
                    })
                except AttributeError:
                    # Skip items with missing data
                    continue
        else:
            print(f"Failed to retrieve page {page}. Status code: {response.status_code}")
            break

    # Print all extracted properties
    for property_data in all_properties:
        print(property_data)

# Run the scraper
if __name__ == "__main__":
    # Define the number of pages to scrape
    num_pages_to_scrape = 5  # Change this to scrape more pages
    scrape_cetris_listings(num_pages_to_scrape)
