# Despliegue de Servicio Nginx en AWS ECS

Este proyecto utiliza Terraform para desplegar un servicio Nginx en AWS ECS (Amazon Elastic Container Service).

## Arquitectura

La arquitectura de la solución consiste en los siguientes elementos:

- **AWS VPC y Subredes**: Se configuran una VPC y dos subredes públicas en diferentes zonas de disponibilidad de la región eu-west-1 de AWS.
- **AWS ECS Cluster**: Se crea un clúster de ECS para alojar los contenedores Docker.
- **AWS ECS Task Definition**: Define la configuración de la tarea ECS que ejecutará el contenedor Nginx.
- **AWS ECS Service**: Configura un servicio ECS para gestionar la ejecución de las tareas Nginx, asegurando que siempre haya al menos una instancia en funcionamiento.
- **AWS Load Balancer (ALB)**: Se utiliza un balanceador de carga de capa de aplicación (ALB) para distribuir el tráfico entre las instancias del servicio Nginx.
- **AWS Security Group**: Define reglas de seguridad para controlar el tráfico de red hacia las instancias ECS.

## Uso

1. Clona este repositorio en tu máquina local.
2. Instala Terraform si aún no lo tienes instalado.
3. Ejecuta `terraform init` para inicializar el directorio de trabajo de Terraform.
4. Ejecuta `terraform plan` para revisar los cambios que se aplicarán.
5. Ejecuta `terraform apply` para desplegar la infraestructura en AWS.
6. Para conectarse copia el valor del `output` y pegalo en un buscador web.
