# -*- coding: utf-8 -*-


import logging
import os
import sys
import platform
import subprocess
import shlex
import datetime

import sneaky.utils as utils


class BasePlatform:

    def __init__(self, args):
        self._log = logging.getLogger(self.__class__)
        self.args = args

        self.system = platform.system()  # Windows or Linux
        self.version = platform.release()
        self.bits = int(platform.architecture()[0][:2])  # Architecture (32 | 64)
        self.dist = None
        self._log.debug("\nSystem: %s\nVersion: %s\nArch: %s", self.system, self.version, self.bits)

        self._log.debug("Date: %s", str(datetime.date.today()))
        self.dir_path = os.path.dirname(os.path.realpath(__file__))
        self._log.debug("dir_path: %s", str(self.dir_path))

        config = utils.read_json(args["--config"])

        # Pull config for the platform. Yes, there will be duplication of settings.
        self.config = config[self.system.lower()]

        # Is there a proxy?
        self.proxy = config["proxy"] if "proxy" in config else None

        # Each application will be a dict with configuration for that app
        self.apps = self.config["apps"]

    def configure(self):
        pass

    # Source: https://github.com/pminkov/kubeutils/
    def resolve_file(self, script_name):
        return os.path.join(self.dir_path, "scripts/%s" % script_name)

    def get_os_script(self, script_name):
        return self.resolve_file(self.dist + "/" + script_name)

    def run_script(self, script, args=""):
        command_line = self.get_os_script(script) + " " + args
        with subprocess.Popen(shlex.split(command_line)) as proc:
            logging.debug(proc.stdout.read())

    def run_command(self, command):
        with subprocess.Popen(shlex.split(command)) as proc:
            logging.debug(proc.stdout.read())

    def __repr__(self):
        return "%s(%s)" % (self.__class__, str([x for x in self.args]))

    def __str__(self):
        return "%s::%s::%s" % (self.system, self.version, self.bits)

    def __hash__(self):
        return hash(str(self))
