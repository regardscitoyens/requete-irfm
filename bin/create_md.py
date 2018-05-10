from jinja2 import Environment, FileSystemLoader
import csv
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

depute = None

with open(sys.argv[2],  "rb") as csvfile:
    deputes = csv.reader(csvfile, delimiter=';', quotechar='"')
    for row in deputes:
        if row[0] == sys.argv[3] or not depute:
            depute = row


data = {"depute": depute[1],
        "depute_adresse": depute[4],
        "cada_no": depute[8],
        "cada_date": depute[10],
        "refus_date": depute[7] if depute[7] != 'NONE' else None,
        "lar_envoi": depute[11] if depute[11] != 'NONE' else None,
        "lar_reception": depute[12] if depute[12] != 'NONE' else None};

env = Environment(loader=FileSystemLoader("."))

template = env.get_template(sys.argv[1])
print template.render(data);
