import requests

session1 = requests.Session()
talist = []
taplays = []
nearlist = []
k=0
m=0

user = [] #removed for anonymity - enter your last.fm username here (or someone elses)

otheruser = [] #removed for anonymity - enter the last.fm usernames of other people using fmbot on the server here


limit = 600

for i in user:
    #requires API key in below line to function
    ta = session1.get(f"https://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user={i}&api_key={API KEY}&format=json&limit={limit}").json()

    for j in ta['topartists']['artist']:
        if int(j['playcount']) > 29:
            talist.append(j['name'])
            taplays.append(j['playcount'])
        else:
            print(i, j['@attr']['rank'])
            break

for i in otheruser:
    #requires API key in below line to function
    ta = session1.get(f"https://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user={i}&api_key={API KEY}&format=json&limit={limit}").json()

    for j in ta['topartists']['artist']:
        if int(j['playcount']) > 29:
            if j['name'] in talist:
                temp = talist.index(j['name'])
                if int(j['playcount']) > int(taplays[temp]):
                    if int(j['playcount']) - int(taplays[temp]) < 3:
                        nearlist.append(j['name'])
                    talist.remove(j['name'])
                    taplays.remove(taplays[temp])
        else:
            print(i, j['@attr']['rank'])
            break

talist = sorted(talist)
print(talist)
print("Maybe Near: ", nearlist)

checked = []

for i in talist:
    if i in checked:
        pass
    else:
        print('.w', i)

