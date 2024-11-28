import requests

def get_archived_urls(base_url, timestamp="20210101"):
    """
    Get archived URLs for a specific base URL and timestamp from Wayback Machine.
    """
    wayback_url = f"http://web.archive.org/cdx/search/cdx?url={base_url}&output=json&from={timestamp}&to=20211231"
    response = requests.get(wayback_url)

    if response.status_code == 200:
        data = response.json()
        # The second item in each entry is the archived URL
        archived_urls = [f"http://web.archive.org/web/{entry[1]}/{entry[2]}" for entry in data[1:]]
        return archived_urls
    else:
        print("Failed to retrieve archived URLs")
        return []

# Example: Get archived URLs for Centris
archived_urls = get_archived_urls("https://www.centris.ca/en/properties~for-sale")
print(archived_urls)
