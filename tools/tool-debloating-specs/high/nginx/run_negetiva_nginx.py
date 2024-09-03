#!/usr/bin/python

# Originally copied from the core-utilities/grep-2.19 benchmark 

from __future__ import print_function
import os, subprocess, sys
import tempfile
import unittest
import shutil
import shlex
import time

binary = "/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/benchmarks/benchmarks/high/nginx-1.23.3/binaries/64/nginx"

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



def mkdirp(path):
    if os.path.exists(path):
        return path
    else:
        return os.mkdir(path)

def wget(args):
    assert type(args) == str
    subprocess.call(shlex.split("wget " + args))

class Test_nginx(unittest.TestCase):
    def test_start_nginx(self):
        os.chmod(os.getcwd(), 0o777)
        mkdirp("logs")
        for root, dirs, files in os.walk(os.getcwd()):
            for dir in dirs:
                os.chmod(os.path.join(root, dir), 0o0777)
            for file in files:
                os.chmod(os.path.join(root, file), 0o0777)
        shutil.copytree("/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/tools/tool-debloating-specs/high/input_files/nginx-serve-ip", "serve-ip")
        shutil.copy("/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/tools/tool-debloating-specs/high/input_files/nginx-file_server.conf", "file_server.conf")
        self.proc = execute(f"{binary} -p {os.getcwd()} -c file_server.conf", wait=False)
        time.sleep(1.0)

    def tearDown(self):
        time.sleep(60.0)
        shutil.rmtree("serve-ip")
        self.proc.terminate()
        

    # def test_file_server_download(self):
    #     wget("http://127.0.0.1:8080/dir1/file1.html")
    #     wget("http://127.0.0.1:8080/dir1/./../about.html")
    #     wget("-O index.html http://127.0.0.1:8080")

    # def test_file_server_download_404(self):
    #     wget("http://127.0.0.1:8080/dir2/about.html")

def train():
    suite = unittest.TestLoader().loadTestsFromTestCase(Test_nginx)
    unittest.TextTestRunner(verbosity=2).run(suite)
    return

if __name__ == '__main__':
    train()
