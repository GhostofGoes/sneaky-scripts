#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Credit for base code goes to: yodiaditya
# https://github.com/yodiaditya/slideshare-downloader/blob/master/convertpdf.py

"""SlideShare Downloader.

Usage:
    slideshare_downloader.py [options]

Options:
    -h, --help  Show this screen
    -f <file>   Specify output filename
    -u <url>    URL to download
"""

import img2pdf
from docopt import docopt

from os import walk, mkdir, chdir, getcwd
from os.path import join

from urllib.parse import urlparse
from urllib.request import urlopen
from bs4 import BeautifulSoup
from requests import get

TOP_DIR = getcwd()


def download_images(page_url):
    html = urlopen(page_url).read()
    soup = BeautifulSoup(html, 'html.parser')
    images = soup.findAll('img', {'class': 'slide_image'})
    image_dir = soup.title.string.strip(' \t\r\n').lower().replace(' ', '-')
    try:
        mkdir(image_dir)
    except FileExistsError:
        print("The directory '%s' already exists. Assuming PDF rebuild, continuing with existing contents...\n"
              "Delete the directory to re-download the slide images." % image_dir)
        return image_dir
    chdir(image_dir)
    for image in images:
        image_url = image.get('data-full').split('?')[0]
        with open(urlparse(image_url).path.split('/')[-1], "wb") as file:
            response = get(image_url)
            file.write(response.content)
    chdir(TOP_DIR)
    return image_dir


def convert_pdf(image_dir, filename):
    chdir(join(TOP_DIR, image_dir))
    files = next(walk(join(TOP_DIR, image_dir)))[2]
    with open(join(TOP_DIR, filename), "wb") as file:
        img2pdf.convert(*files, title=filename, outputstream=file)

if __name__ == "__main__":
    arguments = docopt(__doc__)
    if arguments["-u"]:
        download_url = arguments["-u"]
    else:
        download_url = input('SlideShare full URL (including "http://"): ')
    i_dir = download_images(download_url)
    if arguments["-f"]:
        convert_pdf(i_dir, arguments["-f"])
    else:
        convert_pdf(i_dir, i_dir + ".pdf")
