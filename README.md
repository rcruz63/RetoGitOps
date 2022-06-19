# Reto

## Primera parte: assets globales

Practitioner:

* Crear Personal Access Token (PAT) en GitHub
* Dar de alta PAT de GitHub en Jenkins
* Generar credenciales de usuario en AWS
* Dar de alta credenciales de AWS en Jenkins

Proficiency:

* Dar de alta organización en SonarCloud
* Crear Personal Access Token en SonarCloud
* Configurar PAT de SonarCloud en Jenkins
* Configurar webhook de SonarCloud apuntando a Jenkins

## Segunda parte: Repo infra (Terraform)

### Objetivo

Crear un bucket S3 desde Terraform con flujo GitOps

### Requisitos

Características del bucket:

* Nombre del bucket: "mapfre-gitops-" (ejempo: mapfre-gitops-pedroamador).
* Tipo de bucket: sitio WEB, con "index.html" como documento por defecto.
* Visibilidad: acceso público de lectura.

Flujo de entrega:

* El backend de Terraform será de tipo "local" en el Jenkins, en la ruta /opt/buckets/, por ejemplo "/opt/buckets/pedroamador"
* Se hará "terraform plan" todas las ramas, excepto rama "main"
* Se aplicará terraform únicamente con la rama "main"

Pipeline:

* Incluir archivo Jenkinsfile en el directorio raíz del repositorio
* Configurar Job de Jenkins como "Pipeline Multibranch"
* Configurar Webhook en el repositorio de GitHub apuntando a "jenkins.cicd.kevops.academy"
* Configurar credenciales de AWS como secretos y usarlas:
  - Como variables de entorno, o bien
  - Como variables definidas en "variables.tf" y sobreescritas en el archivo "terraform.tfvars"

Proficiency:

* Hacer commits con formato "conventional commit"
* Hacer un changelog basado en los mensajes de commit
* Etiquetar el repositorio (tag) con versiones semánticas tipo MAYOR.MINOR.PATCH
  - Incluir stage de Sonar en el pipeline:
  - Dar de alta proyecto SonarCloud
  - Crear Personal Access Token en SonarCloud
  - Configurar PAT de SonarCloud en Jenkins
  - Configurar webhook de SonarCloud apuntando a Jenkins
* Usar ramas de características (feature branches) e integrar código mediante Pull Requests a la rama "main"
* Configurar el plan de Terraform en un módulo con parámetros para las credenciales de AWS y el nombre del bucket (que debe comenzar por "mapfre-gitops-*")

Otros:

Se debe tener precaución para no incluir en el repositorio información sensible, como credenciales de AWS. Éstas deben utilizarse en el flujo de entrega como secretos de Jenkins

## Tercera parte: Repo Estáticos / Microservicio (Ansible)

### Objetivo

Provisionar un bucket S3 desde Ansible con flujo GitOps

### Requisitos

Tarea de Ansible: - Copiar archivo estático "index.html" en el bucket provisionado en el repositorio de infraestructura - El archivo estático debe contener "Hello, World! (v1.0.0)" o similar (contenido libre)

Flujo de entrega:

* Se hará test del playbook con "ansible-playbook .yml --check" en un stage de pruebas para todas las ramas
* Se aplicará el playbook exclusivamente en la rama "main"

Pipeline:

* Incluir archivo Jenkinsfile en el directorio raíz del repositorio
* Configurar Job de Jenkins como "Pipeline Multibranch"
* Configurar Webhook en el repositorio de GitHub apuntando a "jenkins.cicd.kevops.academy"
* Configurar credenciales de AWS como secretos y usarlas como variables de entorno

Proficiency:

* Hacer commits con formato "conventional commit"
* Hacer un changelog basado en los mensajes de commit
* Etiquetar el repositorio (tag) con versiones semánticas tipo MAYOR.MINOR.PATCH
* Incluir stage de Sonar en el pipeline:
  - Dar de alta proyecto SonarCloud
  - Crear Personal Access Token en SonarCloud
  - Configurar PAT de SonarCloud en Jenkins
  - Configurar webhook de SonarCloud apuntando a Jenkins
* Usar ramas de características (feature branches) e integrar código mediante Pull Requests a la rama "main"
* Usar un template "jinja2" y un archivo "version.txt" para que el contenido del HTML "Hello, World! (vX.Y.Z)" sea dinámico.

Otros:

* Se debe tener precaución para no incluir en el repositorio información sensible, como credenciales de AWS. Éstas deben utilizarse en el flujo de entrega como secretos de Jenkins

## Recursos

* Git:
- [Changelog Generator](https://github.com/ayudadigital/dc-git-changelog-generator) 
- [Git: Get Next Release Number](https://github.com/ayudadigital/dc-get-next-release-number)
* Jenkins:
- [Use credentials in environment variables- Terraform:](https://stackoverflow.com/questions/48182807/jenkins-use-withcredentials-in-global-environment-section)
- [Bucket S3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [S3 ACL](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl)
- [S3 Website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)
- [Local Backend](https://www.terraform.io/language/settings/backends/local)
- [AWS Credentials in Environment Variables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables)
* Ansible:
- [s3_sync](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Validating tasks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_checkmode.html)
* [URL de SonarCloud](https://sonarcloud.io/)
* Recursos del path formativo:
- [Repositorios de mapfre-gitops](https://github.com/mapfre-gitops)
- [Repositorios de kevops-acme](https://github.com/kevops-acme)
- [URL de Jenkins de Kevops Academy](http://jenknis.cicd.kevops.academy:8080/)

## Entregables

Para poder evaluar el reto se necesita adjuntar a esta tarea:

* URL de los repositorios de Git generados
* URL de los jobs de Jenkins ejecutados
* URL del bucket de S3