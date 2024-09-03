#!/usr/bin/python

# Originally copied from the core-utilities/grep-2.19 benchmark 

from __future__ import print_function
import os, subprocess, sys
import tempfile
import unittest
import shutil
import shlex
import time
from contextlib import contextmanager




binary = "/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/benchmarks/benchmarks/high/poppler-0.60/binaries/64/pdftohtml"


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

class Test_poppler(unittest.TestCase):
    def setUp(self):
        shutil.copy("/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/tools/tool-debloating-specs/high/input_files/BinRec.pdf", "BinRec.pdf")
        shutil.copy("/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/tools/tool-debloating-specs/high/input_files/markdown.pdf", "markdown.pdf")
        shutil.copy("/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/tools/tool-debloating-specs/high/input_files/openpdf.zip", "openpdf.zip")
        subprocess.check_call("unzip openpdf.zip".split())

    def tearDown(self):
        subprocess.check_call("rm *.pdf", shell=True)
        pass

    def test_markdown(self):
        execute(f"{binary} markdown.pdf")

    def test_opts_range(self):
        execute(f"{binary} -f 1 -l 1 markdown.pdf")

    def test_opts_single_doc(self):
        execute(f"{binary} -s markdown.pdf")

    def test_opts_stdout(self):
        execute(f"{binary} -stdout markdown.pdf")

    def test_images(self):
        execute(f"{binary} BinRec.pdf")

    def test_openpdf_corpus(self):
        files = [
            "OPENPDF-129-0.pdf",
            "OPENPDF-129-1.pdf",
            "OPENPDF-129-2.pdf",
            "OPENPDF-129-3.pdf",
            "OPENPDF-129-4.pdf",
            "OPENPDF-156-0.pdf",
            "OPENPDF-156-1.pdf",
            "OPENPDF-179-0.pdf",
            "OPENPDF-179-1.pdf",
            "OPENPDF-179-2.pdf",
            "OPENPDF-216-0.pdf",
            "OPENPDF-216-1.pdf",
            "OPENPDF-216-2.pdf",
            "OPENPDF-254-0.zip-0.pdf",
            "OPENPDF-254-0.zip-2.pdf",
            "OPENPDF-296-0.pdf",
            "OPENPDF-296-1.pdf",
            "OPENPDF-296-2.pdf",
            "OPENPDF-296-3.pdf",
            "OPENPDF-296-4.pdf",
            "OPENPDF-296-5.pdf",
            "OPENPDF-330-0.pdf",
            "OPENPDF-65-0.pdf",
            "OPENPDF-73-0.pdf",
            "OPENPDF-86-0.pdf",
            "OPENPDF-86-1.pdf",
            "OPENPDF-9-0.pdf",
            "OPENPDF-LINK-158-0.pdf",
            "OPENPDF-LINK-320-0.pdf",
            "OPENPDF-LINK-320-1.pdf",
            "OPENPDF-LINK-86-0.pdf"
        ]
        for f in files:
            execute(f"{binary} {f} output.html")

def train():
    suite = unittest.TestLoader().loadTestsFromTestCase(Test_poppler)
    unittest.TextTestRunner(verbosity=2).run(suite)
    return

if __name__ == '__main__':
    train()

#cmake -DCMAKE_BUILD_TYPE=release -DCMAKE_C_FLAGS="-O3" -DCMAKE_CXX_FLAGS="-O3  " -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang
