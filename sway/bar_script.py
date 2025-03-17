#!/usr/bin/python3

from time import sleep
from datetime import datetime
import subprocess
def time():
    now = datetime.now()
    return now.strftime("%m/%d/%Y - %I:%M:%S %p")

def ram():
    output = subprocess.check_output(['free', '-h'])
    output = output.split(b'\n')
    parts = output[1][4:].strip().split()
    parts = [p.decode() for p in parts]
    return f"<Used: {parts[1]}> <Free: {parts[2]}> <Avail: {parts[5]}>"

def bat(): 
    with open("/sys/class/power_supply/BAT0/charge_now") as now:
        with open("/sys/class/power_supply/BAT0/charge_full") as max:
            charge_now = float(now.readline())
            charge_max = float(max.readline())
            return f"{round((charge_now/charge_max)*100,1)}%"

while True:
    print(f"{ram()} | {bat()} | {time()}")
