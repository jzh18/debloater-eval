#!/usr/bin/python

# Originally copied from the core-utilities/grep-2.19 benchmark 

from __future__ import print_function
import os, subprocess, sys
import tempfile
import unittest
import shutil
import shlex
import time



binary = "/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/benchmarks/benchmarks/high/imagemagick-7.0.1-0/binaries/64/magick"

def execute(cmd, stdin_file=None, wait=True):
    cmd = shlex.split(cmd)
    if stdin_file:
        with open(stdin_file, 'rb') as stdin:
            p = subprocess.Popen(cmd, stdin=stdin)
            if wait:
                p.wait()
    else:
        p = subprocess.Popen(cmd)
        if wait:
            p.wait()
    return p

class Test_imagemagick(unittest.TestCase):
    def setUp(self):
        for pic in ["eggs.bmp", "eggs.gif", "eggs.jpg", "eggs.png"]:
            shutil.copy("/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/tools/tool-debloating-specs/high/input_files/{}".format(pic), os.getcwd())

    def tearDown(self):
        pass

    def test_convert_format(self):
        formats = ["jpg", "png", "bmp", "gif"]
        for frum in formats:
            for to in formats:
                execute(f"{binary} eggs.{frum} eggs2.{to}")

    def test_resized(self):
        for scale in ["50%", "150%"]:
            execute(f"{binary} eggs.jpg -resize {scale} eggs-resized.jpg")

    def test_flip(self):
        execute(f"{binary} eggs.jpg -flip eggs-flipped.jpg")

    def test_flop(self):
        execute(f"{binary} eggs.jpg -flop eggs-flopped.jpg")

    def test_negate(self):
        for flag in ["-negate", "+negate"]:
            execute(f"{binary} eggs.jpg {flag} eggs-negate.jpg")

    def test_scale(self):
        for scale in ["50%", "150%"]:
            execute(f"{binary} eggs.jpg -scale {scale} eggs-scale.jpg")

    def test_roll(self):
        for x in ["+0", "-270", "+270"]:
            for y in ["+0", "-270", "+270"]:
                execute(f"{binary} eggs.jpg -roll {x}{y} eggs-rolled.jpg")

    def test_transverse(self):
        execute(f"{binary} eggs.jpg -transverse eggs-transverse.jpg")

    def test_transpose(self):
        execute(f"{binary} eggs.jpg -transpose eggs-transposed.jpg")

    def test_rotate(self):
        for degrees in ["0", "-270", "-90", "90", "270", "360"]:
            execute(f"{binary} eggs.jpg -rotate {degrees} eggs-transverse.jpg")

    def test_crop(self):
        for w in range(6, 399, 150):
            for h in range(6, 399, 150):
                for x in ["+0", "+90"]:
                    for y in ["+0", "+90"]:
                        execute(f"{binary} eggs.jpg -crop {w}X{h}{x}{y} eggs-cropped.jpg")

def train():
    suite = unittest.TestLoader().loadTestsFromTestCase(Test_imagemagick)
    unittest.TextTestRunner(verbosity=2).run(suite)
    return

if __name__ == '__main__':
    train()

# LD_LIBRARY_PATH=MagickCore/.libs/:MagickWand/.libs/:$LD_LIBRARY_PATH
# MAGICK_CONFIGURE_PATH=$(pwd)/config LD_LIBRARY_PATH=MagickCore/.libs/:MagickWand/.libs/:$LD_LIBRARY_PATH
# PYTHONPATH="/host/tool-debloating-specs:$PYTHONPATH"

# export PYTHONPATH=$PYTHONPATH/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/tools/tool-debloating-specs
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/benchmarks/benchmarks/high/imagemagick-7.0.1-0/binaries/64
# export=MAGICK_CONFIGURE_PATH=/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/benchmarks/benchmarks/high/imagemagick-7.0.1-0/binaries/64