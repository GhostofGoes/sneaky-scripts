#!/usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup
from sneaky import __version__

with open('README.rst') as f:
    README = f.read()

setup(
    name='sneaky-scripts',
    version=__version__,
    description='Automated setup and configuration of your system environment',
    long_description=README,
    url='https://github.com/GhostofGoes/sneaky-scripts',
    download_url='https://pypi.python.org/pypi/sneaky-scripts',
    author='Christopher Goes',
    author_email='goesc@acm.org',
    license='MIT',
    packages=['sneaky'],
    include_package_data=True,
    keywords='sneaky scripts windows linux ubuntu centos rhel kali debian '
             'automation bash dotfiles python Goes to mice town',  # SEO YO
    zip_safe=False,
    install_requires=[
        'docopt == 0.6.2',
        'tqdm',
        'requests >= 2.18.4',

        'colorlog;platform_system=="Linux"',

        'pywinauto;platform_system=="Windows"',
        'colorlog[windows];platform_system=="Windows"',
        # 'pywin32 >= 1.0;platform_system=="Windows"'
    ],
    classifiers=[  # PyPI SEO!
        'Development Status :: 2 - Pre-Alpha',
        'Environment :: Console',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: POSIX :: Linux',
        'Natural Language :: English',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Intended Audience :: Information Technology',
        'Intended Audience :: Science/Research',
        'Topic :: System :: Systems Administration',
        'Topic :: System :: Installation/Setup',
        'Topic :: Utilities'
    ],
    platforms=['Windows', 'Linux'],
    entry_points={
        'console_scripts': [
            'sneaky = sneaky.sneaky_scripts:main'
        ]
    }
)
