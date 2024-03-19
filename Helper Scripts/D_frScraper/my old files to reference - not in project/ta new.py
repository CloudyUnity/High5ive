import requests

session1 = requests.Session()
talist = []
taplays = []
nearlist = []
k=0
m=0

user = ['Cajmo_']

otheruser = ['abysmalglimmer', 'AK1089-', 'AndrewAlamNist',
             'ARK9704', 'broglicious', 'DeelishousFly', 'Dobwok', 'DOK1903',
             'elektra_makris', 'epicmusicguy', 'furederikkuu', 'GeorgeAB',
             'M-D157', 'martin-larsen', 'Maya556z', 'ooniko88oo', 'Pqrky',
             'profavi', 't0wamats', 'taiRE123', 'tobster66', 'TreasonMay',
             'tyrolegen']

limit = 600

for i in user:
    ta = session1.get(f"https://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user={i}&api_key=6bcb1280ff6fb5663cea8da203775f42&format=json&limit={limit}").json()

    for j in ta['topartists']['artist']:
        if int(j['playcount']) > 29:
            talist.append(j['name'])
            taplays.append(j['playcount'])
        else:
            print(i, j['@attr']['rank'])
            break


for i in otheruser:
    ta = session1.get(f"https://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user={i}&api_key=6bcb1280ff6fb5663cea8da203775f42&format=json&limit={limit}").json()

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

checked = ['100 gecs', '23', '24kGoldn', '3OH!3', '7 Minutes Dead', 'A. G. Cook', 'AC/DC', 'ARTBAT', 'ATIKA PATUM', 'Aaron Daniel Jacob', 'Achille Lauro', 'Add N To (X)', 'Adrianne Lenker', 'Adwaith', 'Aiobahn', 'Aldious', 'Alex Mattson', 'Alexa', 'Alice Glass', 'Aligns', 'Allie X', 'Alvan', 'Andrew Lambrou', 'Anevo', 'Anxhela Peristeri', 'Arca', 'Arielle Dombasle', 'Arion', 'Armin van Buuren', 'Ashnikko', 'Astronaut', 'Atmozfears', 'Au/Ra', 'Au5', 'Avicii', 'Avril Lavigne', 'BEAUZ', 'BTS', 'Bad Computer', 'Bag Raiders', 'Benny Cristo', 'Bensley', 'Bicep', 'Big Black Delta', 'Bigflo & Oli', 'Billie Eilish', 'Bishu', 'Bleu Clair', 'Blind Channel', 'Bloom', 'Bon Jovi', 'Bossfight', 'Braken', 'Bring Me the Horizon', 'Britney Spears', 'Brooke Candy', 'Bryan Aspey', 'Burial', 'Bustre', 'C418', 'CAKE POP', 'Calpurnia', 'Candace', 'Candyland', 'CaptainSparklez', 'Case & Point', 'Cashmere Cat', 'Christine and the Queens', 'Circus Mircus', 'Citi Zēni', 'Clara Rubensson', 'CloudNone', 'Coldplay', 'Conan Gray', 'Conro', 'Corpse', 'Crankdat', 'Crawlers', 'Creed', 'DJ Abdel', 'DROELOE', 'Daft Punk', 'Daktyl', 'Damian Ukeje', 'Danger Mouse', 'Dankmus.', 'Danny L Harle', 'Darren Styles', 'David Bowie', 'Day One', 'Daði Freyr', 'Deadly Avenger', 'Delta Heavy', 'Demi Lovato', 'Deon Custom', 'Deorro', 'Desert Star', 'Dexter King', 'Didrick', 'Dion Timmer', 'Direct', 'Dirty Audio', 'Dirtyphonics', 'Disero', 'Doll Skin', 'Dorian Electra', 'Dougal', 'Downplay', 'Draper', 'Dream', 'Droptek', 'Duumu', 'Dylan Brady', 'Dyssidia', 'EURINGER', 'Ed Sheeran', 'Eden Alene', 'Efendi', 'Elena Tsagrinou', 'Ellis', 'Eminence', 'Emma Muscat', 'End of the World', 'Ephixa', 'Era', 'Eru', 'Eädyth', 'F.O.O.L', 'FINNEAS', 'FKA twigs', 'FWLR', 'Falcon Funk', 'Favright', 'Feed Me', 'Feint', 'Foster the People', 'Fractal', 'Fransis Derelle', 'Fyr og Flamme', 'Gabry Ponte', 'Gammer', 'Gareth Emery', 'Gary Numan', 'Gaspard Augé', 'Gent & Jawns', 'Ghostemane', 'Gims', "Gjon's Tears", 'Glacier', 'Gnarls Barkley', 'Go_A', 'Grabbitz', 'Graham Reznick', 'Grant', 'Grant Bowtie', 'Green Day', 'Grimes', 'Gustaph', 'HEALTH', 'Habstrakt', 'Half An Orange', 'Haliene', 'Halsey', 'Haywyre', 'Heatmiser', 'Hellberg', 'Herve Pagez', 'Hoaprox', 'Holly', 'Hollywood Principle', 'Hooverphonic', 'Horrible Histories', 'Hurricane', 'Hush', 'Hyper Potions', 'I Prevail', 'IZA', 'Illenium', 'In the Nursery', 'Infected Mushroom', 'Insan3lik3', 'Intelligent Music Project', 'Intercom', 'Inverness', 'JVNA', 'James Mc William', 'James Newman', 'Jay Cosmic', 'Jeangu Macrooy', 'JoJo Siwa', 'Josh Pan', 'Julian Calor', 'Just A Gent', 'Justice', 'Justin Oh', 'K/DA', 'KUURO', 'Kage', 'Karen O', 'Karma Fields', 'Kaskade', 'Kavinsky', 'Kayzo', 'Kellen Joseph', 'Kevin Villecco', 'KickRaux', 'Kill Paris', 'Kim Petras', 'Kiriyama Family', 'Knife Party', 'Konrad OldMoney', 'Konstrakta', 'Koven.', 'Kygo', 'Kyle Dixon & Michael Stein', 'LUCAS LEX', 'LUM!X', 'LVTHER', 'Laszlo', 'Le Destroy', 'Leadley', 'Lena Raine', 'Leonz', 'Lil Hank', 'Lingua Ignota', 'Linkin Park', 'Lookas', 'Loosid', 'Lord of the Lost', 'Louis the Child', 'LoveJoy', 'Ludwig Göransson', 'Luke Black', 'M83', 'MEMBA', 'Maazel', 'Machine Gun Kelly', 'Major Lazer', 'Marcin Przybyłowicz', 'Marilyn Manson', 'Marina', 'Marshmello', 'Martin Garrix', 'Massive Attack', 'Matduke', 'Matroda', 'Max Coveri', 'Mazare', 'Maître Gims', 'Meet Me @ The Altar', 'Melano', 'Mellowdrone', 'Men Without Hats', 'Men at Work', 'Mick Gordon', 'Mike Ault', 'Mike Shinoda', 'Mikolai Stroinski', 'Miles McKenna', 'Mitski', 'Mnqn', 'Modestep', 'Mogwai', 'Montaigne', 'Mothica', 'Mr FijiWiji', 'Muzz', 'Myrne', 'M|O|O|N', 'MØ', 'Måneskin', 'NERVO', 'NOAHFINNCE', 'Natalia Gordienko', 'Naughty Boy', 'New Order', 'Nigel Good', 'Nina Kraviz', 'Nitro Fun', 'Noa Kirel', 'Noisestorm', 'Nonsens', 'Notaker', 'O-Zone', 'Oklou', 'Oliver Tree', 'OneRepublic', 'Oneno', 'Orbiter', 'Owl City', 'P.T. Adamczyk', 'PAX Paradise Auxiliary', 'PIXL', 'Pabllo Vittar', 'Pasha Parfeny', 'Paul Leonard-Morgan', 'Pegboard Nerds', 'Phantaboulous', 'Pink Floyd', 'Piqued Jacks', 'Pixel Terror', 'Poppy', 'Porter Robinson', 'Połoz', 'Project 46', 'Protostar', 'Puppet', 'Pylot', 'REACH', 'Rae Sremmurd', 'Rafal', 'Rafał Brzozowski', "Rag'n'Bone Man", 'Rameses B', 'Rammstein', 'Raney Shockne', 'Reaper', 'Reddi', 'Reiley', 'Rezodrone', 'Rezonate', 'Richard Caddock', 'Rogue', 'Rome in Silver', 'Ronela Hajati', 'Rootkit', 'Roxen', 'Rundfunk', 'S10', 'SAINT PUNK', 'SBCR', 'SKIFONIX', 'SLUMBERJACK', 'SMLE', 'Sabai', 'Sam Ryder', 'Sam Smith', 'Samanta Tina', 'San Holo', 'Savoy', 'Sebastian Robertson', 'Senhit', 'Seven Lions', 'Sevish', 'ShockOne', 'Sia', 'Singapore Airlines', 'Slander', 'Slippy', 'Smash Mouth', 'Snavs', 'Soft Cell', 'Solaris', 'Sophie', 'Sophie Powers', 'Soprano', 'Soulero', 'Soulji', 'Stardust', 'Starmaxx', 'Starset', 'Starship', 'Stefan', 'Stefania', 'Stephen', 'Stephen Walking', 'Stereotronique', 'Steve Aoki', 'Steven Richard Davis', 'Stonebank', 'Stromae', 'Subtact', 'Subwoolfer', 'Sullivan King', 'Summer Was Fun', 'System of a Down', 'Sŵnami', 'THE ROOP', 'TIX', 'TVDS', 'Tails', 'Taska Black', 'Televisor', 'Tenacious D', 'Terry Zhong', 'That Poppy', 'The Aubreys', 'The Bloody Beetroots', 'The Burial', 'The Busker', 'The Joy Formidable', 'The Kinks', 'The Night', 'The Offspring', 'The Rasmus', 'The Strokes', 'The White Stripes', 'TheFatRat', 'Theodore Shapiro', 'Throttle', 'Till Lindemann', 'Tokyo Machine', 'Tokyo Rose', 'Tom Morello', 'Tom Scott', 'Tony Romera', 'Topi', 'Tramp Stamps', 'Trent Reznor and Atticus Ross', 'Trevor Jones', 'Trivecta', 'Troye Sivan', 'Tryhardninja', 'Tusse', 'Tut Tut Child', 'TwoThirds', 'Uku Suviste', 'Unlike Pluto', 'Van Halen', 'Varien', 'Vesna', 'Vicetone', 'Voyager', 'WRLD', 'Waterparks', 'We Are Domi', 'Whethan', 'Wild Youth', 'Will Sparks', 'Xilent', 'YOASOBI', 'YTRAM', 'YUNGBLUD', 'Yacht', 'Zac Waters', 'Zero Hero', 'Zeromancer', 'blink-182', 'carolesdaughter', 'girl in red', 'ilan Bluestone', 'laura les', 'lovelytheband', 'mylk', 'namakopuri', 'nanobii', 'rich edwards', 'slushii', 'soupandreas', 'yeule', 'Утро']

for i in talist:
    if i in checked:
        pass
    else:
        print('.w', i)
