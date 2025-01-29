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

1. Créer une configuration Terraform lancant un conteneur basé sur l'image hello-world. Voir [docker_container](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container).
2. Lancer `tofu plan` et étudier le résultat
3. Lancer `tofu apply` et vérifier l'état du conteneur avec `docker ps`.
4. Lancer `tofu apply` avec le conteneur déj//a lancé
5. Supprimer le conteneur avec `docker container rm` et lancer `tofu apply`

## Exercice 1, sans docker

1. Créer une configuration Terraform créant une fichier local. Voir [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file).
2. Lancer `tofu plan` et étudier le résultat
3. Lancer `tofu apply` et vérifier la présence du fichier
4. Supprimer le fichier et lancer `tofu apply`

## Exercice 2

1. Créer une configuration terraform lancant un container `nginx` et l'executer :
* image : docker.io/nginx
* une redirection de port de 80->8080
2. Tester le container en ouvrant la page http://localhost:8080
3. Lire le début de la documentation sur les variables : https://developer.hashicorp.com/terraform/language/values/variables
4. Remplacer le port externe (8080) par una variable `container_port`. Essayer avec ou sans valeur par defaut.
5. Lire le début de la documentation sur les outputs : https://developer.hashicorp.com/terraform/language/values/outputs
6. Rajouter un output sur le champ `ip_address` du container et la visualier apr//es un `tofu apply` avec `tofu output`

## Exercice 2, sans docker

WIP