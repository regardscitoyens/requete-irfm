from jinja2 import Environment, FileSystemLoader
import csv
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

depute = None

if len(sys.argv) < 4:
    raise Exception("Utilisation: %s <template> <csv> <num> <output>" % sys.argv[0])

with open(sys.argv[2],  "rb") as csvfile:
    deputes = csv.reader(csvfile, delimiter=';', quotechar='"')
    for row in deputes:
        if row[0] == sys.argv[3]:
            depute = row
            break

if not depute:
    raise Exception("Ligne %s introuvable" % sys.argv[3])

# 0   1   2    3    4       5          6         7             8       9         10      11        12        13        14
# num;nom;slug;sexe;adresse;date_refus;doc_refus;nb_pages_refus;demande;bordereau;cada_no;avis_cada;date_cada;lar_envoi;lar_reception

data = {"depute": depute[1],
        "depute_adresse": depute[4],
        "cada_no": depute[10],
        "cada_date": depute[12],
        "refus_date": depute[5] if depute[5] != '' else None,
        "nb_pages_refus": int(depute[7]),
        "lar_envoi": depute[13] if depute[13] != 'NONE' else None,
        "lar_reception": depute[14] if depute[14] != 'NONE' else None}

env = Environment(loader=FileSystemLoader("."))

template = env.get_template(sys.argv[1])
rendered = template.render(data)

if not len(rendered):
    raise Exception("Rendu vide O_o")

with open(sys.argv[4], "w") as output:
    output.write(rendered)
