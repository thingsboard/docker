# Toolbox Image

## Motivation

While cluster deployments engineers often have a necessity to:
* Check services endpoints via HTTP clients;
* Check connections to the database inside the cluster;
* Send test data to debugging cluster install;
* Writes different scripts to automate and optimize some install and deploy processes;

This toolbox contains a list of popular and commonly use tools/clients to help reach these goals.

## Content
* postgresql-client
* py3-pip
* bash
* curl
* cqlsh

## How to use

This image doesn't have any entrypoint or cmd. So feel free to pass this by using a standard mechanism of Docker or Kubernetes.

In scripts/ directory script-runner.sh can run a list of scripts that you can run each by each

```shell
echo "Start running following scripts "$*""
for var in "$@"
do
    echo "---------------"
    bash "$var"
done
```

Example of using in Kubernetes
```yaml
- name: validate-db
  image: thingsboard/toolbox
  env: 
    # environment variable for internal scripts psql-validator and cqlsh-validator
    - name: RETRY_COUNT
      value: "5"
    - name: SECONDS_BETWEEN_RETRY
      value: "25"
    # environment for psql and cqlsh 
    - name: PGHOST
      value: "POSTGRES HOST"
    - name: PGDATABASE
      value: "POSTGRES DATABASE"
    - name: PGUSER
      value: "POSTGRES USER"
    - name: QUERY_TO_VALIDATE
      value: "Select SOMETHING"
    - name: PGPASSWORD
      valueFrom:
        secretKeyRef:
          name: postgres-secret
          key: SPRING_DATASOURCE_PASSWORD
    - name: CASSANDRA_HOST
      value: "CASSANDRA HOST"
    - name: CASSANDRA_USER
      value: "CASSANDRA USER"
    - name: CASSANDRA_PASSWORD
      valueFrom:
        secretKeyRef:
          key: CASSANDRA_PASSWORD
          name: cassandra-secret
  # Running main script script-runner and passing as arguments two validator scripts
  command:
    - bash
  args:
    - script-runner.sh
    - psql-validator.sh
    - cqlsh-validator.sh
```