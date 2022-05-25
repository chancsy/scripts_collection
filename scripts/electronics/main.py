# # Script selector

import os
dirname = os.path.dirname(__file__)
scripts = [f for f in os.listdir(dirname) if (os.path.isfile(os.path.join(dirname, f)) and (f != os.path.basename(__file__)) and (f != 'constants.py'))]

for i in range(0, len(scripts)):
    script = os.path.join(dirname, scripts[i])
    with open(script, encoding="utf8") as file:
        firstline = file.readlines()[0].rstrip()
    file.close()
    print(str(i+1) + " - " + firstline.replace("# ",""))

selection = int(input("Select script: "))-1

script = os.path.join(dirname, scripts[selection])
os.system('python '+script)
