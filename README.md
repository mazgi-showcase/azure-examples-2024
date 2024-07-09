# azure-examples-2024

## How to Use

### Write out your IDs and information in the .env file

If you have an old `.env` file, you are able to reset it by removing it.

```console
rm -f .env
```

:information_source: If you are using Linux, write out UID, GID, and GID for the `docker` group, into the `.env` file to let that as exported on Docker Compose as environment variables.

```console
test $(uname -s) = 'Linux' && {
  echo -e "DOCKER_GID=$(getent group docker | cut -d : -f 3)"
  echo -e "GID=$(id -g)"
  echo -e "UID=$(id -u)"
} >> .env || :
```

```console
echo "ARM_SUBSCRIPTION_ID=YOUR_SUBSCRIPTION" >> .env
echo "ARM_CLIENT_ID=$(jq -r .appId examples/provisioning/config/credentials/azure-service-principal.provisioning-owner)" >> .env
echo "ARM_CLIENT_SECRET=$(jq -r .password examples/provisioning/config/credentials/azure-service-principal.provisioning-owner)" >> .env
echo "ARM_TENANT_ID=$(jq -r .tenant examples/provisioning/config/credentials/azure-service-principal.provisioning-owner)" >> .env
echo "AZURE_DEFAULT_LOCATION=YOUR_REGION" >> .env
```

```console
echo "ENV_UNIQUE_ID=YOUR_SUBSCRIPTION" >> .env
```

### Start the container

```console
docker compose up
```

```console
docker compose exec provisioning zsh -l
```

```console
az login --service-principal\
 --username "${ARM_CLIENT_ID}"\
 --password "${ARM_CLIENT_SECRET}"\
 --tenant "${ARM_TENANT_ID}"
```
