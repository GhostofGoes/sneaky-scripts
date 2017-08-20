# -*- coding: utf-8 -*-

import os
import sys
import platform
import logging

from tqdm import tqdm
import requests

from sneaky.base_platform import BasePlatform


class Linux(BasePlatform):
    """Handles Linux platform and app customization."""

    def __init__(self, args):
        BasePlatform.__init__(self, args)
        self.dist = platform.linux_distribution()[0].lower()
        self.script_path = "linux/" + self.dist

    def configure(self):
        """Call the proper scripts for each distro."""
        # TODO: select package manager from here pass to scripts
        # Deprecated-schmeprecated
        if self.dist == 'redhat':
            self.run_script("rhel_setup.sh")
        elif self.dist == 'debian':
            self.run_script("debian_setup.sh")
        else:
            logging.error("Unknown Linux distribution: %s", self.dist)
