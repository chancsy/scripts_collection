# Script selector

scripts = [
  "LM317_Rfb_E24.py",
  "LM317_Rfb_E48.py",
  "Vdivider_E24.py",
  "Vdivider_E24_with_Ilimit.py",
  "Vdivider_E48.py",
  "Vdivider_E48_with_Ilimit.py",
]

for i in range(0, len(scripts)):
    with open(scripts[i], encoding="utf8") as file:
        firstline = file.readlines()[0].rstrip()
    file.close()
    print(str(i+1) + " - " + scripts[i] + " " + firstline)

selection = int(input("Select script: "))-1

import os
os.system('python '+scripts[selection])
