import requests, json, time, string, random

#setting up the webpage cookies and shit
headers1 = {
    #"Host": "www.brtimes.com",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:90.0) Gecko/20100101 Firefox/90.0",
    "Accept": "application/json, text/javascript, */*; q=0.01",
    "Accept-Language": "en-GB,en;q=0.5",
    "Accept-Encoding": "gzip, deflate, br",
    "X-Requested-With": "XMLHttpRequest",
    "DNT": "1",
    "Connection": "keep-alive",
    "Cookie": "consent=yes",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",

}

session1 = requests.Session()
session1.headers = headers1

abcs = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
stationcodes = []

for i in abcs:
    for j in abcs:
        for k in abcs:
            temp = session1.get(f"https://www.brtimes.com/ac_loc?term={i}{j}{k}").json()
            if len(temp) > 0:
                if [temp[0]['code'], temp[0]['value']] not in stationcodes:
                    stationcodes.append([temp[0]['code'], temp[0]['value']])

stationcodes = sorted(stationcodes)
print(stationcodes)