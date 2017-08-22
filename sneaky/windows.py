# -*- coding: utf-8 -*-

import os
import sys
import logging
import subprocess
import shlex
import tempfile

from sneaky.base_platform import BasePlatform
import sneaky.utils as utils


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

        # Create temporary directory for downloading and running installers
        current_dir = os.getcwd()  # Save current directory
        temp_dir = tempfile.mkdtemp(suffix='sneaky-')
        os.chdir(temp_dir)  # Change to the temporary directory

        # Download our apps
        for app in self.apps:
            # TODO: do these in sub-processes
            self._log.info("Starting download of %s", app["name"])
            utils.download_file(url=app["url"], filename=app["name"], extension=".exe")
            self._log.info("Finished downloading %s", app["name"])

        # Install our apps
        for app in self.apps:
            self._log.info("Installing %s...", app["name"])
            os.execl(os.getcwd() + app["name"])
            self._log.info("Installed %s!", app["name"])

        # Cleanup our apps
        for app in self.apps:
            self._log.debug("Deleting downloaded installer for app %s...", app["name"])
            os.remove(app["name"] + ".exe")
            self._log.debug("Deleted downloaded installer for app %s", app["name"])

        # Reset
        os.chdir(current_dir)  # Jump back to where we were originally
        os.rmdir(temp_dir)  # Cleanup the temp dir

    def build_ninite_installer(self):
        # TODO: use pywinauto to interact with Ninite
        base_url = "https://ninite.com/"

    def configure_proxy(self):
        pass  # TODO: implement
