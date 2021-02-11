import subprocess
import gpsd
import time
import requests
import os


def run():
    key = os.environ.get("RTIRL_PUSH_KEY")
    if not key:
        return
    # Start gpsd
    subprocess.Popen(["/usr/sbin/gpsd", "-N", "-n", "-G", "${*}"])

    gpsd.connect()

    while True:
        packet = gpsd.get_current()
        requests.post(
            "https://rtirl.com/api/push?key=" + key,
            data={
                "latitude": packet.lat,
                "longitude": packet.lon,
                "altitude": packet.alt,
            },
        )
        time.sleep(1)


if __name__ == "__main__":
    run()