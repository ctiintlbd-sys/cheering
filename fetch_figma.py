import urllib.request
import json
import sys

url = "https://api.figma.com/v1/files/Fc03PPDFTz7D0nrTEQj0ah/nodes?ids=1122:13319,1122-13319"
req = urllib.request.Request(url)
req.add_header('X-Figma-Token', 'figd_nofETWfHwObCLwsogli1FvzhpzvyZcWJJJ5pPnBt')

try:
    with urllib.request.urlopen(req) as response:
        data = json.loads(response.read().decode())
        with open('figma_data.json', 'w') as f:
            json.dump(data, f, indent=2)
        print("Success")
except Exception as e:
    print(f"Error: {e}")

