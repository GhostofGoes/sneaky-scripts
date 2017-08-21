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

    def install_apps(self):
        # Download our apps
        for app in self.apps:
            self._log.info("Starting download of %s." % app["name"])
            download = requests.get(app["url"], stream=True)
            # exe = os.path.basename(app["url"])
            # TODO: do these in sub-processes

            # Source: https://stackoverflow.com/a/37573701/2214380
            total_size = int(download.headers.get('content-length', 0))
            with open(app["name"], "wb") as handle:
                for data in tqdm(download.iter_content(), total=total_size,
                                 unit='B', unit_scale=True):
                    handle.write(data)
            self._log.info("Finished downloading %s" % app["name"])

        # Install our apps
        for app in self.apps:
            self._log.info("Installing %s..." % app["name"])
            os.execl(os.getcwd() + app["name"])
            self._log.info("Installed %s!" % app["name"])

    def build_ninite_installer(self):
        # TODO: use pywinauto to interact with Ninite
        base_url = "https://ninite.com/"
