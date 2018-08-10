#!/usr/bin/env python
# Copyright 2018 The Fuchsia Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import argparse
import os
import stat
import string
import sys


def main():
  parser = argparse.ArgumentParser(
      description='Generate a script that invokes multiple dart_test targets')
  parser.add_argument('--out',
                      help='Path to the invocation file to generate',
                      required=True)
  parser.add_argument('--test',
                      action='append',
                      help='Adds a target to the list of test executables',
                      required=True)
  args = parser.parse_args()

  test_file = args.out
  test_dir = os.path.dirname(test_file)
  if not os.path.exists(test_dir):
    os.makedirs(test_dir)

  script = '#!/bin/sh\n\n'
  for test_executable in args.test:
    script += "%s\n" % test_executable

  with open(test_file, 'w') as file:
      file.write(script)
  permissions = (stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR |
                 stat.S_IRGRP | stat.S_IWGRP | stat.S_IXGRP |
                 stat.S_IROTH)
  os.chmod(test_file, permissions)


if __name__ == '__main__':
  sys.exit(main())
