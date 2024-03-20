import requests, unicodedata
from bs4 import BeautifulSoup

headers1 = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-GB,en;q=0.5",
    "Accept-Encoding": "gzip, deflate",
    "DNT": "1",
    "Upgrade-Insecure-Requests": "1",
    "Sec-gpc": "1",
    "If-Modified-Since": "Tue, 30 Mar 2024 23:34:21 GMT",
    "Connection": "keep-alive"
}

session1 = requests.Session()
session1.headers = headers1

nnumbers = open("aircraft.csv", "r")
output = open("output.csv", "a")
planes = []
for i in nnumbers:
    planes.append(i.strip())
nnumbers.close()

for i in planes:
    try:
        response = session1.get(f"https://www.aircraftone.com/aircraft.asp?hn={i}")
        content = response.content.decode('utf-8', errors='ignore')
        soup = BeautifulSoup(content, 'html.parser')
        trSoup = soup.body.find_all('tr')
        aircraft = str(trSoup[8].find('a').contents)[2:-2].replace("\\xa0", " ")
        age = 2024-int(str(((trSoup[9].find_all('td'))[1]))[4:-5])
        output.write(f"{i},{aircraft},{age}"+"\n")
    except:
        output.write(i+"\n")
    print(i)
