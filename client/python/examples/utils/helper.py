import importlib
import sys

found = False

def import_lib(pipelines = ["ent", "cloud"]):
    found = False
    errors = []
    for pipeline in pipelines:
        try:
            pensando_psm = importlib.import_module("pensando_"+pipeline)
            sys.modules['pensando_lib'] = pensando_psm
            import pensando_lib
            return pensando_lib
        except Exception as e:
            # raise e
            errors.append("ERROR: pensando_" + pipeline + " not found: " + e.msg)
            pass
    print("\n".join(errors))
    sys.exit(1)
