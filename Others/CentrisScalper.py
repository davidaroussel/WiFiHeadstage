import requests
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime


def get_listings(start_date, end_date):
    """
    Scrape house listings on Centris within the specified date range.
    """
    base_url = "https://www.centris.ca/en/properties~for-sale"
    listings = []
    page = 1

    while True:
        print(f"Scraping page {page}...")
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
        }

        response = requests.get(base_url, headers=headers)
        print(response.status_code)

        if response.status_code != 200:
            print("Failed to fetch data.")
            break

        soup = BeautifulSoup(response.text, 'html.parser')

        # Example selector, customize as needed
        items = soup.select(".property-thumbnail")
        if not items:
            break  # No more listings to process

            # List to store extracted data
            properties = []

        for item in items:
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
                properties.append({
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

                # Print all extracted properties
            for property_data in properties:
                print(property_data)

            else:
                print(f"Failed to retrieve the page. Status code: {response.status_code}")


def check_availability(listings_df):
    """
    Check if the saved listings are still accessible.
    """
    unavailable = []

    for _, row in listings_df.iterrows():
        try:
            response = requests.get(row['URL'])
            if response.status_code == 404:
                unavailable.append(row)
        except Exception as e:
            print(f"Error checking {row['URL']}: {e}")

    return pd.DataFrame(unavailable)


def main():
    # Example date range
    start_date = datetime(2024, 11, 1)
    end_date = datetime(2024, 11, 27)

    print("Step 1: Scraping listings...")
    listings = get_listings(start_date, end_date)

    if not listings.empty:
        print(f"Found {len(listings)} listings.")
        print("Step 2: Checking availability...")
        unavailable_listings = check_availability(listings)

        if not unavailable_listings.empty:
            print(f"Found {len(unavailable_listings)} unavailable listings.")
            unavailable_listings.to_csv("unavailable_listings.csv", index=False)
            print("Unavailable listings saved to 'unavailable_listings.csv'.")
        else:
            print("No unavailable listings found.")
    else:
        print("No listings found in the specified date range.")


if __name__ == "__main__":
    main()
