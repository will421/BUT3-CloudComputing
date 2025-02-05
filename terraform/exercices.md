# Exercices Terraform

## Généraliés

Les machines de l'IUT ne possèdent pas Terraform mais un clone appelé OpenTofu. Les commandes sont les mêmes. Il suffit de remplacer "terraform" par "tofu" dans la ligne de commande.
Exemples :
```bash
tofu init
tofu plan
tofu apply
tofu destroy
```

Les machines de l'IUT n'utilisent pas Docker mais Podman. Il est possible que vous ayez besoin de lancer cette commande pour que les actions concernant Docker fonctionnent : `systemctl --user enable --now podman.socket`

Exemple de configuration basique :
```terraform
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "hello_world" {
  name = "docker.io/hello-world"
}
```

## Exercice 1

1. Créer une configuration Terraform lancant un conteneur basé sur l'image `docker.io/hello-world`. Voir [docker_container](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container).
2. Lancer `tofu plan` et étudier le résultat
3. Lancer `tofu apply` et vérifier l'état du conteneur avec `docker ps`.
4. Lancer `tofu apply` avec le conteneur déja lancé
5. Supprimer le conteneur avec `docker container rm` et lancer `tofu apply`

## Exercice 1 (Azure)

1. Se connecter à Azure avec la commande `az login`
2. Il faudra utiliser le provider `azureerm`
1. Créer une configuration Terraform créant un ressource groupe de nom `test`. Voir [resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group).
2. Lancer `tofu plan` et étudier le résultat
3. Lancer `tofu apply` et vérifier le résultat sur Azure.
4. Lancer `tofu apply` de nouveau.
5. Supprimer le resource groupe sur le portail Azure  lancer `tofu apply`

## Exercice 2

1. Créer une configuration terraform lancant un container `nginx` et l'executer :
* image : docker.io/nginx
* une redirection de port de 80->8080
2. Tester le container en ouvrant la page http://localhost:8080
3. Lire le début de la documentation sur les variables : https://developer.hashicorp.com/terraform/language/values/variables
4. Remplacer le port externe (8080) par una variable `container_port`. Essayer avec ou sans valeur par defaut.
5. Lire le début de la documentation sur les outputs : https://developer.hashicorp.com/terraform/language/values/outputs
6. Rajouter un output de nom `ip_address` et de valeur `localhost:<port>` et la visualier après un `tofu apply` avec `tofu output`

## Exercice 2 (Azure)

1. Reprendre l'exercice 1
2. Lire le début de la documentation sur les variables : https://developer.hashicorp.com/terraform/language/values/variables
3. Créer une variable `location` pour contenir la région (ex : "WestEurope") et s'en servir dans le resource_group. Essayer avec ou sans valeur par defaut.
4. Lire le début de la documentation sur les outputs : https://developer.hashicorp.com/terraform/language/values/outputs
5. Rajouter un output sur le champ `id` et le visualier après un `tofu apply` avec `tofu output`. Le comparer avec l'id visible sur le portail Azure

## Exercice 3

1. Repartir de l'exercice 2
2. Supprimez vos images et conteneurs terraform avec `tofu destroy`
3. Lire le début de la doc sur les [data sources](https://developer.hashicorp.com/terraform/language/data-sources)
4. Télécharger l'image docker `nginx` en ligne de commande : `docker pull docker.io/nginx`
5. Dans votre configuration, utiliser une datasource pour référencer cette image dans votre conteneur. Voir [image](https://registry.terraform.io/providers/abh80/docker/latest/docs/data-sources/image). L'idée est de remplacer la ressource `docker_image` par une datasource.

## Exercice 3 (Azure)

1. Repartir de l'exercice 3
2. Supprimer les ressources avec `tofu destroy` et vérifier qu'ils n'existent plus
3. Créer "manuellement" un ressource_group sur le portail Azure
4. Lire le début de la doc sur les [data sources](https://developer.hashicorp.com/terraform/language/data-sources)
5. Dans votre configuration, utiliser une datasource pour référencer la ressource_group et créer une VM dedans.  Voir [resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) et [azurerm_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine)


## Exercice 4

1. Repartir de l'exercice 3
2. Créer un fichier `index.html` avec le contenu de votre choix
2. Ajouter un volume à votre container mappant `/usr/share/nginx/html/index.html` vers votre le fichier `index.html` précédemment créé. Ex: `${abspath(path.module)}/index.html`
3. Tester que la page web est bien affiché par votre navigateur
4. Utiliser la fonction [templatefile](https://developer.hashicorp.com/terraform/language/functions/templatefile) pour générer un fichier html à partir d'une variable de votre configuration.
  * Créer un fichier `index.html.tpl` basé sur `index.html`. Ce fichier template devra avoir un titre basé sur une variable `title`
  * Utiliser la fonction `templatefile` pour affecter une valeur à `title` et la resource `local_file` pour générer `index.html`
5. Confirmer que le serveur web renvoie la page générée.

## Exercice 4 (Azure)

1. Repartir de l'exercice 3
2. Créer une VM
  * Il y a beaucoup de ressources à créer pour faire tourner une VM : `azurerm_resource_group`, `azurerm_virtual_network`, `azurerm_subnet`, `azurerm_network_security_group`, `azurerm_public_ip`, `azurerm_network_interface`, `azurerm_network_interface_security_group_association`, `azurerm_linux_virtual_machine`
  * Aidez-vous de la doc ou d'une IA pour vous aider sur liens entres les différentes ressources

## Exercice 5

Nous voulons surveiller notre machine local au travers d'une page web avec Grafana.

1. Créer manuellement le fichier `prometheus.yml` contenant :
```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```
2. Créer manuellement un dossier `grafana-provisioning` et créer un fichier de nom `grafana-provisioning/datasources/datasources.yml` contenant
```
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false
```

3. Ajouter un réseau docker à la configuration appelé `monitoring_network`
4. Ajouter un volume docker à la configuration appelé `grafana_data`
5. Ajouter 3 conteneurs à la configuration :
* nom: prometheus
  * image : docker.io/prom/prometheus
  * volume : "chemin vers votre fichier prometheus" -> /etc/prometheus/prometheus.yml
  * networks: monitoring_network
* nom: grafana
  * image : docker.io/grafana/grafana
  * port : 3000 -> 3000
  * volume : "chemin vers votre dossier grafana-provisioning" -> /etc/grafana/provisioning
  * volume : grafana_data -> /var/lib/grafana
  * networks: monitoring_network
* nom: node-exporter
  * image : docker.io/prom/node-exporter
  * networks: monitoring_network
6. Se connecter à grafana sur http://localhost:3000 et les identifiants admin/admin.
7. Cliquer sur Dashboards > Create dashboard > Import dashboard > Discard
8. Mettre l'id `1860` et cliquer sur `Load`
9. Dans le champ "Prometheus", selectionner la datasource "Prometheus" et cliquer sur "Import"

## Exercice 6 

1. Reprendre l'exercice 5
2. Remplacer la configuration avec 2 modules
  * un pour grafana et son volume `grafana_data`
  * un pour prometheus et node-exporter