# -*- coding: utf-8 -*-


import logging
import os
import platform
import subprocess
import shlex
import datetime

import sneaky.utils as utils


class BasePlatform:
    """Base class from which platform-specific classes derive."""

    def __init__(self, args):
        """
        :param dict args: Commandline arguments parsed by docopt
        """
        self._log = logging.getLogger(str(self.__class__))
        self.args = args

        self.system = platform.system()  # Windows or Linux
        self.version = platform.release()
        self.bits = int(platform.architecture()[0][:2])  # Architecture (32 | 64)
        self.dist = None
        self._log.debug("\nSystem: %s\nVersion: %s\nArch: %s", self.system, self.version, self.bits)

        self._log.debug("Date: %s", str(datetime.date.today()))
        self.dir_path = os.path.dirname(os.path.realpath(__file__))
        self._log.debug("dir_path: %s", str(self.dir_path))

        if args["--config"]:
            config = utils.read_json(args["--config"])
        else:
            config = utils.read_json(self.resolve_file("sneaky_config.json"))

        # Pull config for the platform. Yes, there will be duplication of settings.
        self.config = config[self.system.lower()]

        # Is there a proxy?
        self.proxy = config["proxy"] if "proxy" in config else None

        # Each application will be a dict with configuration for that app
        self.apps = self.config["apps"]

    def configure(self):
        pass  # Override me!

    def configure_proxy(self):
        pass  # Override me!

    # Source: https://github.com/pminkov/kubeutils/
    def resolve_file(self, filename):
        """
        Resolves the path to a file or directory in resources/
        :param str filename: Name of file/directory to resolve
        :return: Absolute Path to the file/directory
        :rtype: str
        """
        return os.path.join(self.dir_path, "resources", filename)

    def get_os_script(self, script_name):
        """
        Resolves the path to a script for the named OS
        :param str script_name: Name of the script to resolve path of
        :return: Absolute Path to the script
        :rtype: str
        """
        return self.resolve_file(os.path.join(self.dist, script_name))

    def resolve_dotfile(self, dotfile):
        """
        Resolves the path to a dotfile
        :param str dotfile: Name of the dotfile to resolve path of
        :return: Absolute Path to the dotfile
        :rtype: str
        """
        return self.resolve_file(os.path.join("dotfiles", dotfile))

    def run_script(self, script, args=""):
        """
        Runs the specified script with arguments, based on OS of the class
        :param str script: Name of the script to run
        :param str args: Arguments to provide the script with
        """
        command_line = self.get_os_script(script) + " " + args
        with subprocess.Popen(shlex.split(command_line)) as proc:
            self._log.debug(proc.stdout.read())

    def run_command(self, command):
        """
        Executes a command in a subprocess
        :param str command: Command to run, including arguments
        """
        with subprocess.Popen(shlex.split(command)) as proc:
            self._log.debug(proc.stdout.read())

    def __repr__(self):
        return "%s(%s)" % (self.__class__, str([x for x in self.args]))

    def __str__(self):
        return "%s::%s::%s" % (self.system, self.version, self.bits)

    def __hash__(self):
        return hash(str(self))
