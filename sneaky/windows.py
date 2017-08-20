# -*- coding: utf-8 -*-

import os
import sys
import platform
import logging
import subprocess
import shlex

from tqdm import tqdm
import requests

from sneaky.base_platform import BasePlatform


class Windows(BasePlatform):
    """Handles Windows platform and app customization."""

    def __init__(self, args):
        BasePlatform.__init__(self, args)
        self.script_path = 'scripts/windows'
        self.dist = "windows"

    def configure(self):
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

    def build_ninite_installer(self):
        # TODO: use pywinauto to interact with Ninite
        base_url = "https://ninite.com/"
