import scipy.io as sio
import pyperclip
from configparser import ConfigParser

clip = pyperclip.paste()

my_struct = sio.loadmat(clip)
my_struct.keys()
data = my_struct["ThisStructure"]
comments = my_struct["Comments"]
notes = comments[0,0]["Notes"][:,0]

history = ""
for x in notes:
    history += str(x)

facets = data[0,0]["Facets"]
ftype = data[0,0]["Facets"][:,0]["Type"]

ftypelist = list(ftype)
roof = ftypelist.count(512)
pens = ftypelist.count(672)
iapens = ftypelist.count(8864)
wall = ftypelist.count(1024)
footprint = ftypelist.count(2048)
soffits = ftypelist.count(9344)
stamps = ftypelist.count(1184)
som = ftypelist.count(17408)

config = ConfigParser()
config.add_section('FileInfo')
config['FileInfo']['clip'] = str(clip)
config['FileInfo']['roof'] = str(roof)
config['FileInfo']['pens'] = str(pens)
config['FileInfo']['iapens'] = str(iapens)
config['FileInfo']['wall'] = str(wall)
config['FileInfo']['footprint'] = str(footprint)
config['FileInfo']['soffits'] = str(soffits)
config['FileInfo']['stamps'] = str(stamps)
config['FileInfo']['som'] = str(som)
config['FileInfo']['history'] = str(history)

with open('fileinfo.ini', 'w') as configfile:
    config.write(configfile)