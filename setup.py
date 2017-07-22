#!/usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup

from sneaky.sneaky_scripts import __version__

with open('requirements.txt') as f:
    REQUIRED = f.read().splitlines()

with open('README.md') as f:
    README = f.read()

setup(
    name='sneaky-scripts',
    version=__version__,
    description='Automated setup of development environments. Definitely not a vagrant clone. ;)',
    long_description=README,
    url='https://github.com/GhostofGoes/sneaky-scripts',
    download_url='https://pypi.python.org/pypi/sneaky-scripts',
    author='Christopher Goes',
    author_email='goesc@acm.org',
    license='MIT',
    packages=['sneaky'],
    # scripts=['sneaky/'],
    include_package_data=True,
    keywords='sneaky scripts windows rhel debian automation bash etc etc',  # SEO YO
    zip_safe=False,
    install_requires=REQUIRED,
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
        'Operating System :: MacOS', # Someday...
        'Natural Language :: English',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Intended Audience :: Information Technology',
        'Intended Audience :: Science/Research',
        'Topic :: System :: Systems Administration',
        'Topic :: System :: Installation/Setup',
        'Topic :: Utilities'
    ],
    platforms=['Windows', 'Linux', 'Mac OS-X'],
    entry_points={
        'console_scripts': [
            'sneaky-scripts = sneaky.sneaky_scripts:main'
        ]
    }
)