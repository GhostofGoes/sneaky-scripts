# -*- coding: utf-8 -*-

import os
import sys
import platform
import logging
import subprocess
import shlex
import shutil

from sneaky.base_platform import BasePlatform


class Linux(BasePlatform):
    """Handles Linux platform and app customization."""

    def __init__(self, args):
        BasePlatform.__init__(self, args)
        self.dist = platform.linux_distribution()[0].lower()  # Why is this deprecated in 3.5...
        self.script_path = "linux/" + self.dist

    def configure(self):
        """Call the proper scripts for each distro."""
        if self.dist == 'redhat':
            self.run_script("rhel_setup.sh")
        elif self.dist == 'debian':
            self.run_script("debian_setup.sh")
        else:
            logging.error("Unknown Linux distribution: %s", self.dist)
            sys.exit(1)

        if "packages" in self.config:
            self.install_packages()

    def install_packages(self):
        if self.dist == 'redhat':
            self.run_command("sudo yum -y update")
        else:
            self.run_command("sudo apt-get -y update")

        # TODO: version number specification for packages (using a version key in "value")
        for key, value in self.config["packages"].values():
            if self.dist == 'redhat':
                self.run_command("sudo yum -y install " + key)
            else:
                self.run_command("sudo apt-get -y install " + key)

    def install_dotfiles(self):
        self._log.info("Installing dotfiles...")
        for key, value in self.config["dotfiles"].values():
            self.place_dotfile(name=key, config=value)
        self._log.info("Finished installing dotfiles")

    def place_dotfile(self, name, config):
        # TODO: allow configuration of special permissions, if needed
        source_loc = self.resolve_dotfile(name)
        install_loc = config["location"]  # Directory to install in

        # Check if the dotfile already exists
        if os.path.exists(os.path.join(install_loc, name)):
            if "action_if_exists" in config:
                action = config["action_if_exists"]  # "append" | "overwrite"
            else:  # If not configured, then prompt user
                action = input("Dotfile %s already exists. Do you want to append or overwrite?: ")

            if action == "append":
                self._log.info("Appending contents of your "
                               "dotfile %s to the existing version", name)
                with open(source_loc, "r") as infile:
                    dotfile_data = infile.read()

                with open(os.path.join(install_loc, name), "wa") as outfile:
                    outfile.write(dotfile_data)
                return
            elif action == "overwrite":  # This logic is shit, but meh
                self._log.info("Overwriting contents of existing "
                               "dotfile %s with your version", name)
            else:
                self._log.error("Invalid action: %s", action)
                return

        if config["requires_sudo"]:
            sudo_str = "sudo cp -p %s %s" % (source_loc, install_loc)
            os.system(sudo_str)  # Simple and quick enough to warrant use of system
        else:
            shutil.copy2(source_loc, install_loc)

        # TODO: document config syntax

    def configure_packages(self):
        pass  # TODO
