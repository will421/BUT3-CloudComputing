# Exercices Ansible

## Généralités

* Ces exercices sont conçus pour fonctionner en local. Pas besoin de créer de VM sauf si vous le voulez.

Exemple d'inventory :
```yaml
ungrouped:
  hosts:
    ip1: # Connexion par mdp
      ansible_user: azureuser
      ansible_password: mdp
      ansible_ssh_extra_args: "-o StrictHostKeyChecking=no"
    ip2: # Connexion par clé SSH
      ansible_user: azureuser
      private_key_file: ~/.ssh/id_rsa
    localhost: # Connexion local
      ansible_connection: local
```

Exemple de playbook : 
```yaml
---
- name: Aaffichage de ansible_facts
  hosts: all
  tasks:
    - name: Afficher la variable ansible_facts
      debug:
        var: ansible_facts
```

Exemple de commande : 
```bash
ansible-playbook -i inventory.yml playbook.yml
```

## Exercice 1

1. Ecrire un "play" avec une seule tâche. La création d'un dossier avec votre nom. (Voir module [file](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html))
2. Verifiez la création du dossier sur la machine
3. Identifier la différence d'execution de Ansible quand le dossier est présent ou absent.
4. Modifier le playbook pour que le nom du dossier soit dans une variable
5. Afficher la variable ansible_facts et étudier rapidement son contenu (Voir module [debug](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_module.html) pour afficher une variable)

## Exercice 2

1. Créer un inventory de 2 machines. Une dans un groupe `git`, l'autre dans un groupe `configuration`
2. Créer un playbook (en utilisant le plus possible les variables) contenant 2 plays :
  * Le premier s'executera sur le groupe `git` et copiera le contenu de ce [repo](https://github.com/will421/BUT3-CloudComputing) dans le dossier de votre choix
  * Le second s'executera sur le groupe `configuration` et créera 3 dossiers : `test`, `dev`, `prod` en utilisant le mot clé [loop](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html)

## Exercice 3

1. Reprendre le projet de l'exercice 2.
2. Nous ne voulons plus créer tout les dossiers, mais seulement celui donné en ligne de commande par la variable `env`.
3. Modifier le playbook pour ne plus utiliser `loop` mais utiliser la variable `env`.
4. Utiliser le mot clé [when](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#basic-conditionals-with-when) pour vérifier que la variable `env` est bien défini. Dans le cas contraire, on ne veut pas executer la tache.

## Exercice 4

1. Reprendre le projet de l'exercice 3.
2. Créer dans le projet Ansible, un fichier `configuration.json` contenant
```json
{
  "env":"unknown"
}
```
3. Utiliser le module [copy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html) pour copier `configuration.json` dans le dossier créé pour le groupe `configuration`.
4. Creer un template [Jinja](https://jinja.palletsprojects.com/en/latest/templates/) basé sur `configuration.json`. Remplacer `unknown` par la variable `env`, utiliser le module [template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html) et tester avec différentes valeurs de `env` en paramètre de ligne de commande

## Exercice 5

Creer un projet Ansible contenant 3 roles :
- `init_structure` dont la tâche créera 3 dossiers : `projects`, `scripts` et `backup`
- `bash_config` dont la tâche rajoutera les alias suivant au fichier `.bashrc` en utilisant le module [lineinfile](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html)
```bash
alias ll='ls -la'
alias gs='git status'
```
- `scripts` dont le rôle est de copier un fichier `backup.sh` suivant dans le dossier `script`.
```bash
#!/bin/bash
tar -czf ~/backup/projects_$(date +%Y%m%d).tar.gz ~/projects
```

Votre playbook executera tout ces roles en local.

## Exercice 6

1. Reprendre l'exercice 5.
2. Ajouter un [handler](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html) au role `bash_config`. Ce sera une simple tache de debug affichant le message "Fichier .bashrc modifié".
3. Déclencher cet handler lors de la modification du fichier `.bashrc`

## Exercice bonus : Configurer une stack Grafana-Prometheus sur Docker pour surveiller les ressources systèmes

1. Créer un playbook récupérant les images docker suivantes à l'aide du module `containers.podman.podman_image` :
- docker.io/grafana/grafana
- docker.io/prom/prometheus
- docker.io/prom/node-exporter

2. Créer un réseau `monitoring_network` à l'aide du module `containers.podman.podman_network`
3. TODO