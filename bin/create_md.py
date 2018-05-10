from jinja2 import Environment, FileSystemLoader
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

env = Environment(loader=FileSystemLoader("."))

template = env.get_template(sys.argv[1])
print template.render(depute='Regis Lateur',
                        depute_adresse="Assemblee nationale, 126 rue de l'universite, 75355 Paris 07 SP",
                        cada_no='2017XXXXX',
                        cada_date='1 janvier 2018',
                        refus_date='19 juin 2017',
                        lar_envoi='20 mai 2017',
                        lar_reception='25 mai 2017');
