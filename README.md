# FILROUGE-TF
Repo Terraform pour projet FILROUGE

Permet d'automatiser la création :
- d'un VPC comprenant 2 sous-réseaux publics et 2 sous-réseaux privés dans 2 zones de disponibilité AWS
- d'un cluster EKS et d'un Node Group
- d'une instance EC2 hébergeant le service Jenkins
- d'une instance EC2 hébergeant les services nécessaires à l'automatisation CI/CD (git, docker, kubectl, eksctl, helm, terraform)

Se référer aux fichiers variables.tf de chaque dossier pour personnaliser les modules. 