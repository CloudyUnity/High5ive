"""
CKM

Code to scrape every flight operating in the next week around the world

// @param iata: list of airports to look for routes from
// return output.csv: a list of every pair of airports with a flight operating from the first to the second in the next week (meaning the average route will appear twice)

"""

import requests, time, string, random
from bs4 import BeautifulSoup

headers1 = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-GB,en;q=0.5",
    "Accept-Encoding": "gzip, deflate",
    "DNT": "1",
    "Upgrade-Insecure-Requests": "1",
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "cross-site",
    "Sec-gpc": "1",
    "If-Modified-Since": "Tue, 19 Mar 2024 12:34:21 GMT",
    "te": "trailers"
}

session1 = requests.Session()
session1.headers = headers1

iata = open("iata only.csv", "r")
output = open("output.csv", "a")
airports = []
for i in iata:
    airports.append(i.strip())
iata.close()

for i in airports:
    response = session1.get(f"https://www.flightradar24.com/data/airports/{i}/routes")
    if response.status_code == 200:
        content = response.content.decode('utf-8', errors='ignore')
        soup = BeautifulSoup(content, 'html.parser')
        soupHS = soup.head.find_all('script')
        if str(soupHS[21])[12:21] == "arrRoutes":
            arrRoutes = str(soupHS[21])[24:-10].split("},{")
            for j in arrRoutes:
                output.write(f",{i}," + j[8:11] + '\n')
            print(f"Found {len(arrRoutes)} routes for {i}")

        else:
            print(f"No routes from {i}")

    else:
        print(f"Error code {response.status_code} for  {i}")

    time.sleep(random.randint(5, 10))

output.close()
