#!/usr/bin/env python
# -*- coding: utf-8 -*-

# http://multivax.com/last_question.html

"""Sneaky Sneaky Scripts.

Usage:
    sneaky_scripts.py [options]

Options:
    -f, --apps FILE     App file to use [default: apps.json]
    -v, --verbose       Debugging output [default: false]
    -h, --help          Show this screen
    --version           Show version

"""

import os
import sys
import platform
import logging
import json
import datetime
import subprocess
import shlex

from docopt import docopt
from tqdm import tqdm
import requests


__version__ = "0.1.0"


class Cannon:
    """Boom."""

    def __init__(self, apps):
        self.apps = apps
        self.system = platform.system()
        self.version = platform.release()
        self.bits = platform.architecture()[0]  # Architecture
        logging.info("System: %s\nVersion: %s\nArch: %s", self.system, self.version, self.bits)
        logging.debug("Date: %s", str(datetime.date.today()))
        self.dir_path = os.path.dirname(os.path.realpath(__file__))
        logging.debug("dir_path: %s", str(self.dir_path))
        if self.system == "Windows":
            self.script_path = 'scripts/windows'
        else:
            self.dist = platform.linux_distribution()[0].lower()
            self.script_path = "linux/" + self.dist

    def ignite(self):
        """Hisssssss."""
        if self.system == "Windows":
            self.windows(self.apps["windows"])
        elif self.system == "Linux":
            self.linux(self.apps["linux"])
        elif self.system == "Darwin":
            self.darwin(self.apps["darwin"])
        else:
            logging.error("System '%s' not valid!" % self.system)

    def windows(self, apps):
        is_win10 = bool(self.version[0:1] == "10")
        if is_win10:
            logging.info("Windows 10 detected, running de-crapifying script...")
            with subprocess.Popen(shlex.split(
                            "powershell " + self.get_os_script("Win10.ps1"))) as proc:
                logging.debug(proc.stdout.read())
        from pywinauto import application
        auto = application.Application()
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

    def build_ninite_installer(self, apps):
        # TODO: use pywinauto to interact with Ninite
        base_url = "https://ninite.com/"

    def linux(self, apps):
        """Call the proper scripts for each distro."""
        # TODO: select package manager from here pass to scripts
        # Deprecated-schmeprecated
        if self.dist == 'redhat':
            self.run_script("rhel_setup.sh")
        elif self.dist == 'debian':
            self.run_script("debian_setup.sh")
        else:
            logging.error("Unknown Linux distribution: %s", self.dist)

    def darwin(self, apps):
        raise NotImplementedError("I don't use OSX, submit a pull request or something.")

    # Source: https://github.com/pminkov/kubeutils/
    def resolve_file(self, script_name):
        return os.path.join(self.dir_path, "scripts/%s" % script_name)

    def get_os_script(self, script_name):
        return self.resolve_file(self.dist + "/" + script_name)

    def run_script(self, script, args=""):
        command_line = self.get_os_script(script) + " " + args
        with subprocess.Popen(shlex.split(command_line)) as proc:
            logging.debug(proc.stdout.read())


def setup_logging(verbose=False, log_file='sneaky_scripts.log'):
    """
    :param verbose:
    :param log_file:
    """
    # Prepend spaces to separate logs from previous runs
    with open(log_file, 'a') as logfile:
        logfile.write(2 * '\n')

    # Format log output so it's human readable yet verbose
    base_format = "%(asctime)s %(levelname)-8s %(name)-7s %(message)s"
    time_format = "%H:%M:%S"  # %Y-%m-%d
    formatter = logging.Formatter(fmt=base_format, datefmt=time_format)

    # Configures the base logger to append to a file
    logging.basicConfig(level=logging.DEBUG, format=base_format,
                        datefmt=time_format, filename=log_file, filemode='a')

    # Get the global root logger
    logger = logging.root

    # Configure console output
    console = logging.StreamHandler(stream=sys.stdout)
    try:
        # noinspection PyUnresolvedReferences
        from colorlog import ColoredFormatter
        formatter = ColoredFormatter(fmt="%(log_color)s" + base_format,
                                     datefmt=time_format, reset=True)
        logging.debug("Configured COLORED console logging output")
    except ImportError:
        logging.error("Colorlog is not installed. "
                      "Using STANDARD console output...")
    console.setFormatter(formatter)
    console.setLevel((logging.DEBUG if verbose else logging.INFO))
    logger.addHandler(console)  # Add to the root


# TODO: proxy configuration
# TODO: system configuration
# Logging code stolen from this awesome person: https://github.com/GhostofGoes/ADLES
def main():
    args = docopt(__doc__, version='Sneaky Scripts ' + __version__)
    print(args)
    setup_logging(verbose=bool(args["--verbose"]))

    with open(args['--apps']) as app_file:
        apps = json.load(app_file)

    # If you need comments for these two lines, you might want to see a specialist
    cannon = Cannon(apps)
    cannon.ignite()


if __name__ == '__main__':
    main()
