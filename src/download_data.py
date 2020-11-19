"""Downloads zipped data from the web to a local filepath as a csv.
Usage: download_data.py --url=<url> --path=<path> 
 
Options:
<url>               URL from where to download the zipped data 
<path>              Path (including filename) of where to locally write the file
"""

import os
import io
import requests
import pandas as pd
from docopt import docopt

opt = docopt(__doc__)

def main(url, path):
    # Code below adapted from https://github.com/pandas-dev/pandas/issues/8685
    response = requests.get(url) 
    bytes_io = io.BytesIO(response.content)
    with gzip.open(bytes_io, 'rt') as read_file:
        data = pd.read_csv(read_file)
    
    try:
        data.to_csv(path, index=False)
    except:
        os.makedirs(os.path.dirname(path))
        data.to_csv(path, index=False)



if __name__ == "__main__":
    main(opt["--url"], opt["--path"])
