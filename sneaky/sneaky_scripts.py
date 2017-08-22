#!/usr/bin/env python
# -*- coding: utf-8 -*-

# http://multivax.com/last_question.html

"""Cross-platform setup and customization scripts.

Usage:
    sneaky [options]

Options:
    -f, --config FILE   Configuration file to use [default: sneaky_config.json]
    -v, --verbose       Debugging output to terminal [default: False]
    -q, --quiet         Don't "print" to terminal [default: False]
    -h, --help          Show this screen
    --version           Show version

Author: Christopher Goes
https://github.com/ghostofgoes/sneaky-scripts
"""

import os
import sys
import platform
import logging

from docopt import docopt

import sneaky.utils as utils


__version__ = "0.3.1"


# TODO: proxy configuration
# TODO: system configuration
# Logging code stolen from this awesome person: https://github.com/GhostofGoes/ADLES
def main():
    args = docopt(__doc__, version='Sneaky Scripts ' + __version__)

    if args["--quiet"]:
        sys.stdout = open(os.devnull, 'w')

    utils.setup_logging(verbose=bool(args["--verbose"]))
    logging.debug("** Args **\n%s", str(args))

    sys_name = platform.system()
    if sys_name == "Windows":
        from sneaky.windows import Windows
        system = Windows(args)
    elif sys_name == "Linux":
        from sneaky.linux import Linux
        system = Linux(args)
    elif sys_name == "Darwin":
        logging.critical("I don't use OSX, submit a pull request or something.")
        raise NotImplementedError
    else:
        logging.critical("Unknown system: %s", sys_name)
        sys.exit(1)

    print(utils.startup_text)
    print(str(system))
    system.configure()


if __name__ == '__main__':
    main()
