# coding: utf8
# license : CeCILL-C
import argparse
import os

from flexeval import create_app

if __name__ == '__main__':

    # On récup les args liés à l'instance a créer
    parser = argparse.ArgumentParser(description="FlexEval")
    parser.add_argument("instance",metavar="INSTANCE_DIRECTORY", type=str, help="Instance's directory")
    parser.add_argument("-u","--url",type=str, help="URL from outside") # E.g. http://expression.enssat.fr/test_mos
    parser.add_argument("-i","--ip",type=str, help="Server IP",default="127.0.0.1")
    parser.add_argument("-p","--port", type=int, help="Port",default="8080")
    args = parser.parse_args()

    if not args.url:
        url = "http://"+args.ip+":"+str(args.port) # Définit l'URL par défaut
    else:
        url = args.url

    instance_abs_path = os.path.abspath(args.instance)
    app = create_app(instance_abs_path, url)

    app.run(host=args.ip,port=args.port)
