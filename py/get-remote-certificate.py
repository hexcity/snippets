#!/usr/bin/env python
#
# fetch the certificate that the server(s) are providing in PEM form
#
# args are HOST:PORT [, HOST:PORT...]
#
# By Bill Janssen.

import sys

def fetch_server_certificate (host, port):

    import re, tempfile, os, ssl

    def subproc(cmd):
        from subprocess import Popen, PIPE, STDOUT
        proc = Popen(cmd, stdout=PIPE, stderr=STDOUT, shell=True)
        status = proc.wait()
        output = proc.stdout.read()
        return status, output

    def strip_to_x509_cert(certfile_contents, outfile=None):
        m = re.search(r"^([-]+BEGIN CERTIFICATE[-]+[\r]*\n"
                      r".*[\r]*^[-]+END CERTIFICATE[-]+)$",
                      certfile_contents, re.MULTILINE | re.DOTALL)
        if not m:
            return None
        else:
            tn = tempfile.mktemp()
            fp = open(tn, "w")
            fp.write(m.group(1) + "\n")
            fp.close()
            try:
                tn2 = (outfile or tempfile.mktemp())
                status, output = subproc(r'openssl x509 -in "%s" -out "%s"' %
                                         (tn, tn2))
                if status != 0:
#                    raise OperationError(status, tsig, output)
                    sys.stdout.write("Status not zero: %s" % status)
                fp = open(tn2, 'rb')
                data = fp.read()
                fp.close()
                os.unlink(tn2)
                return data
            finally:
                os.unlink(tn)

    if sys.platform.startswith("win"):
        tfile = tempfile.mktemp()
        fp = open(tfile, "w")
        fp.write("quit\n")
        fp.close()
        try:
            status, output = subproc(
                'openssl s_client -connect "%s:%s" -showcerts < "%s"' %
                (host, port, tfile))
        finally:
            os.unlink(tfile)
    else:
        status, output = subproc(
            'openssl s_client -connect "%s:%s" -showcerts < /dev/null' %
            (host, port))
    if status != 0:
        sys.stderr.write( "Status not zero: %s\n" %
            status)
        raise OSError(status)
    certtext = strip_to_x509_cert(output)
    if not certtext:
        raise ValueError("Invalid response received from server at %s:%s" %
                         (host, port))
    return certtext

if __name__ == "__main__":
#    if len(sys.argv) < 2:
#        sys.stderr.write(
#            "Usage:  %s HOSTNAME:PORTNUMBER [, HOSTNAME:PORTNUMBER...]\n" %
#            sys.argv[0])
#        sys.exit(1)
#    for arg in sys.argv[1:]:
#        host, port = arg.split(":")
#        sys.stdout.write(fetch_server_certificate(host, int(port)))
    host = "192.168.88.4"
    port = 8989
    sys.stdout.write(fetch_server_certificate(host, int(port)))
    sys.exit(0)
