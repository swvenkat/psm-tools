import os

import import_lib
pensando_lib = import_lib.import_lib()
import pensando_lib
from pensando_lib.psm import configuration, api_client
from pensando_lib.psm.apis import WorkloadV1Api

from workload_utils import getDscFromWorkload

import warnings
warnings.simplefilter("ignore")

HOME = os.environ['HOME']

cfg = configuration.Configuration(
    psm_config_path=HOME+"/.psm/config.json",
    interactive_mode=True
)
cfg.verify_ssl = False
client = api_client.ApiClient(cfg)


workload_instance = WorkloadV1Api(client)
workload_response = workload_instance.list_workload("default")

#an existing workload
try:
    print(getDscFromWorkload(client, "default" , workload_response.items[0]["meta"]["name"], workload_instance))
except IndexError:
    print("No workloads found. Skipping test case")

#an invalid workload name
name = "invalidworkloadname"
nameisdif = False
oldname = name
while(nameisdif):
    for work in workload_response.items:
        if (work["meta"]["name"] == name):
            oldname = name
            name += "1"
    nameisdif == (oldname == name)
print(getDscFromWorkload(client, "default", name, workload_instance))

#an invalid workload IP
IP = "0.0.0.0"
print(getDscFromWorkload(client, "default" , IP, workload_instance))

#an invalid workload IP thats forced into name
print(getDscFromWorkload(client, "default" , "0.0.0.0", workload_instance, forceName=True))