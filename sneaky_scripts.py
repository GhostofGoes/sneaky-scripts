#!/usr/bin/env python3
"""

Usage:
    sneaky_scripts.py --version

Options:
    -h --help   Show this screen.
    --version   Show version.

"""

import os
import platform
from docopt import docopt
import logging
from json import load
from tqdm import tqdm
import requests
# from subprocess import Popen

system = platform.system()
version = platform.release()
bits = platform.architecture()[0]  # Architecture


def windows(apps):

    # TODO: exception handling
    # Download our apps
    for app in apps:
        print("Starting download of %s." % app["name"])
        download = requests.get(app["url"], stream=True)
        # exe = os.path.basename(app["url"])
        # TODO: do these in sub-processes
        with open(app["name"], "wb") as handle:
            for data in tqdm(download.iter_content()):
                handle.write(data)
        print("Finished downloading %s!" % app["name"])

    # Install our apps
    for app in apps:
        print("Installing %s..." % app["name"])
        os.execl(os.getcwd() + app["name"])
        print("Installed %s!" % app["name"])


# TODO: linux setup
# TODO: handle different linux distros using their package managers
def linux(apps):
    pass


def darwin(apps):
    pass


# TODO: proxy configuration
# TODO: system configuration
def main():
    args = docopt(__doc__, version='Sneaky Scripts 1.0')
    logging.basicConfig(filename='sneaky_scripts.log', level=logging.DEBUG)
    print("System: %s\nVersion: %s\nArch: %s" % (system, version, bits))

    with open('apps.json') as app_file:
        all_apps = load(app_file)

    if system == "Windows":
        windows(all_apps["windows"])
    elif system == "Linux":
        linux(all_apps["linux"])
    elif system == "Darwin":
        darwin(all_apps["darwin"])
    else:
        print("System '%s' not valid!" % system)

if __name__ == '__main__':
    main()
