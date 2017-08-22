# -*- coding: utf-8 -*-

"""Utility functions."""

import logging
import sys

from tqdm import tqdm
import requests


# Source: https://stackoverflow.com/a/37573701/2214380
def download_exe(url, filename, extension=""):
    """

    :param str url: URL to retrieve from
    :param str filename: Name of the file to be created
    :param str extension: Extension of the file
    """
    download = requests.get(url, stream=True)
    total_size = int(download.headers.get("content-length", 0))
    with open(filename + extension, "wb") as handle:
        for data in tqdm(download.iter_content(), total=total_size,
                         unit='B', unit_scale=True):
            handle.write(data)


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


def read_json(filename):
    """
    Reads input from a JSON file and returns the contents.
    :param str filename: Path to JSON file to read
    :return: Contents of the JSON file
    :rtype: dict or None
    """
    from json import load
    try:
        with open(filename) as json_file:
            return load(fp=json_file)
    except ValueError as message:
        logging.error("Syntax Error in JSON file '%s': %s",
                      filename, str(message))
        return None
    except Exception as message:
        logging.critical("Could not open JSON file '%s': %s",
                         filename, str(message))
        return None


def user_input(prompt, obj_name, func):
    """
    Continually prompts a user for input until the specified object is found.
    :param str prompt: Prompt to bother user with
    :param str obj_name: Name of the type of the object that we seek
    :param func: The function that shalt be called to discover the object
    :return: The discovered object and it's human name
    :rtype: tuple(vimtype, str)
    """
    while True:
        try:
            item_name = str(input(prompt))
        except KeyboardInterrupt:
            print()
            logging.info("Exiting...")
            sys.exit(0)
        item = func(item_name)
        if item:
            logging.info("Found %s: %s", obj_name, item.name)
            return item, item_name
        else:
            print("Couldn't find a %s with name %s. Perhaps try another? "
                  % (obj_name, item_name))


# Based on: http://code.activestate.com/recipes/577058/
def ask_question(question, default="no"):
    """
    Prompts user to answer a question.
    >>> ask_question("Do you like the color yellow?")
    Do you like the color yellow? [y/N]
    :param str question: Question to ask
    :param str default: No
    :return: True/False
    :rtype: bool
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    choice = ''
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("Invalid default answer: '%s'", default)

    while True:
        try:
            choice = str(input(question + prompt)).lower()
        except KeyboardInterrupt:
            print()  # Output a blank line for readability
            logging.info("Exiting...")
            sys.exit(0)

        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            print("Please respond with 'yes' or 'no' or 'y' or 'n'")


# From: list_dc_datastore_info in pyvmomi-community-samples
# http://stackoverflow.com/questions/1094841/
def sizeof_fmt(num):
    """
    Generates the human-readable version of a file size.
    >>> sizeof_fmt(512)
    512bytes
    >>> sizeof_fmt(2048)
    2KB
    :param float num: Robot-readable file size in bytes
    :return: Human-readable file size
    :rtype: str
    """
    for item in ['bytes', 'KB', 'MB', 'GB']:
        if num < 1024.0:
            return "%3.1f%s" % (num, item)
        num /= 1024.0
    return "%3.1f%s" % (num, 'TB')


def pad(value, length=2):
    """
    Adds leading and trailing zeros to value ("pads" the value).
    >>> pad(5)
    05
    >>> pad(9, 3)
    009
    :param int value: integer value to pad
    :param int length: Length to pad to
    :return: string of padded value
    :rtype: str
    """
    return "{0:0>{width}}".format(value, width=length)


startup_text = """
   _____                  __            _____           _       __      
  / ___/____  ___  ____ _/ /____  __   / ___/__________(_)___  / /______
  \__ \/ __ \/ _ \/ __ `/ //_/ / / /   \__ \/ ___/ ___/ / __ \/ __/ ___/
 ___/ / / / /  __/ /_/ / ,< / /_/ /   ___/ / /__/ /  / / /_/ / /_(__  ) 
/____/_/ /_/\___/\__,_/_/|_|\__, /   /____/\___/_/  /_/ .___/\__/____/  
                           /____/                    /_/                
"""