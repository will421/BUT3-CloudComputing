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

## Exercice 1 (sans docker)

1. Créer une configuration Terraform créant un fichier local avec le contenu "test". Voir [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file).
2. Lancer `tofu plan` et étudier le résultat
3. Lancer `tofu apply` et vérifier la présence du fichier
4. Supprimer le fichier et lancer `tofu apply`

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
6. Rajouter un output sur le champ `ip_address` du container et la visualier après un `tofu apply` avec `tofu output`

## Exercice 2 (sans docker)

1. Reprendre l'exercice 1
2. Lire le début de la documentation sur les variables : https://developer.hashicorp.com/terraform/language/values/variables
3. Créer une variable `permission` pour contenir les permissions du fichier (ex: "0666") et l'utilisation sur le fichier. Essayer avec ou sans valeur par defaut.
4. Lire le début de la documentation sur les outputs : https://developer.hashicorp.com/terraform/language/values/outputs
5. Rajouter un output sur le champ `content_md5` du fichier et la visualier après un `tofu apply` avec `tofu output`. Le comparer avec le md5 généré avec la commande `md5sum`

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
5. Dans votre configuration, utiliser une datasource pour référencer cette image dans votre conteneur. Voir [image](https://registry.terraform.io/providers/abh80/docker/latest/docs/data-sources/image)

## Exercice 3 (sans docker)

1. Repartir de l'exercice 3
2. Supprimer le fichier avec `tofu destroy` et vérifier qu'il n'existe plus
3. Créer "manuellement" un fichier `external.txt` avec le contenu `external`
4. Lire le début de la doc sur les [data sources](https://developer.hashicorp.com/terraform/language/data-sources)
5. Dans votre configuration, utiliser une datasource pour copier le contenu du fichier `external.txt` dans un nouveau fichier. Voir [local_file](https://registry.terraform.io/providers/abh80/docker/latest/docs/data-sources/image)
