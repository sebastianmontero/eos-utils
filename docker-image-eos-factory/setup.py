#!/usr/bin/env python

from setuptools import setup

setup(name='eosf',
      version='2.0',
      description='EOS Factory',
      author='tokenika',
      packages=['core', 'shell', 'eosf'],
      install_requires=[
          'termcolor',
      ],
     )

