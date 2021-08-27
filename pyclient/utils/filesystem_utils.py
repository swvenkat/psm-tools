import logging

def saveBinary(path, data):
    try:
        with open(path, 'wb') as out_file:       
            out_file.write(data)
    except:
        logging.error("Could not write file: "+path)
        raise