#version 1
def get_max_width(dict, **kwargs):
    widths = []
    padding = 10
    if "key1" in kwargs:
        key1 = kwargs["key1"]
    if "key2" in kwargs:
        key2 = kwargs["key2"]
    if "key3" in kwargs:
        key3 = kwargs["key3"]
        for i in range(len(dict["items"])):
            try:
                widths.append(len(dict["items"][i][key1][key2][key3]))
            except KeyError:
                pass
    if "security" in key2:
        for i in range(len(dict["items"])):
            try:
                widths.append(len(dict["items"][i][key1][key2][0]))
            except KeyError:
                pass
    if "proto_ports" in key2:
        for i in range(len(dict["items"])):
            try:
                for j in range (len(dict['items'][i]['spec']['proto_ports'])):
                    widths.append(len(dict['items'][i]['spec']['proto_ports'][j]['ports']))
            except KeyError:
                pass
    else:
        for i in range(len(dict["items"])):
            try:
                widths.append(len(dict["items"][i][key1][key2]))
            except KeyError:
                pass
    return(max(widths)+padding)
