#! /bin/bash

chmod 600 /home/ubuntu/.env

if [ -f ajr-solucoes.tar ]; then
  rm ajr-solucoes.tar
fi
echo "Carregando imagem no Docker..."
gzip -d ajr-solucoes.tar.gz

if [ $? -ne 0 ]; then
  echo "Erro ao descompactar o arquivo ajr-solucoes.tar.gz"
  exit 1
fi
echo "Descompactado com sucesso"
echo "Carregando imagem no Docker..."
docker load -i ajr-solucoes.tar

mv docker-compose-prod.yaml docker-compose.yaml

container_ids=$(docker ps -q)

if [ -z "$container_ids" ]; then
  echo "Nao ha containers em execucao"
else
  for container_id in $container_ids; do
    echo "Parando container: $container_id"
    docker stop $container_id
  done
  echo "Todos os containers em execucao foram parados. "
fi 

echo "Subindo containers"
docker compose up -d