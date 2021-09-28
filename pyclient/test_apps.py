import subprocess as sp
import os

print("Testing apps:\n")
apps_directory = "apps/"
index = 0
success = 0

apps_to_test = ["cluster_ping.py"]
exclude = ["find_workload.py", "fwlogs.py", "rule_poke.py", "find_rule.py", "find_workload_tech_support.py", "identify_dsc.py", "rule.py"]

for app in os.listdir(apps_directory):
    if app.endswith(".py") and app in apps_to_test:
        index += 1
        print("{0:<25} {1:<25}".format("Starting:", app))
        child = sp.Popen(["python3", apps_directory+app], stdout=None, stderr=None)
        child.communicate()
        rc = child.returncode
        success = success + (1 if rc == 0 else 0)
        print("{0:<5} {1:<25} {2:<25}".format(index, app, "Success" if rc == 0 else "Failure"))

print("\n{}/{} tests passed.".format(success, index))
