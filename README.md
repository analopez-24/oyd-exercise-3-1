# Exercise 3.1 — EC2 Compute Module

Módulo de Terraform que aprovisiona una instancia EC2 con un servidor HTTP escrito en Ruby.

## Architecture

- **Instance type:** t4g.micro (arm64 / Graviton2)
- **AMI:** ami-0ddb64e71e68cf624 (AL2023, us-west-2)
- **Region:** us-west-2
- **Servidor:** Ruby TCP server con los endpoints `/health` y `/echo`

## Usage

Subir `server.rb` al bucket de S3 antes de desplegar:

```bash
aws s3 cp app/server.rb s3://YOUR_BUCKET/server.rb
```

Desplegar:

```bash
cd infra
terraform init
terraform apply -var-file=envs/dev/dev.tfvars
```

Destruir los recursos:

```bash
terraform destroy -var-file=envs/dev/dev.tfvars
```

## Endpoints

```bash
curl http://<instance-ip>:8080/health
# {"status":"ok","compute":"ec2"}

curl -X POST http://<instance-ip>:8080/echo \
  -H 'Content-Type: application/json' \
  -d '{"msg":"hello"}'
# {"msg":"hello","compute":"ec2"}
```

## Evidence

### Respuestas de los endpoints

```bash
$ curl http://44.251.67.20:8080/health
{"status":"ok","compute":"ec2"}

$ curl -X POST http://44.251.67.20:8080/echo \
  -H 'Content-Type: application/json' \
  -d '{"msg":"hello"}'
{"msg":"hello","compute":"ec2"}
```

### instance.txt

```
----------------------------------------------------
|                 DescribeInstances                |
+----------------------+----------+----------------+
|  i-0a6bc41254764c0e1 |  running |  44.251.67.20  |
+----------------------+----------+----------------+
```