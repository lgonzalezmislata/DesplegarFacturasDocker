#!/bin/bash
echo Iniciando deploy $(date +"%Y-%m-%d %H:%M:%S") >> log.txt

#Parar los contenedores
docker compose down



#Datos para crear la imagen logongas/compilar:1.0.0
rm -rf ./compilar/volumes/app
git clone https://github.com/lgonzalezmislata/Facturas.git ./compilar/volumes/app

#JDK
curl -L -o OpenJDK21U-jdk_x64_linux_hotspot_21.0.6_7.tar.gz https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.6_7.tar.gz
tar -xvzf OpenJDK21U-jdk_x64_linux_hotspot_21.0.6_7.tar.gz -C ./compilar/build/src/opt
mv ./compilar/build/src/opt/jdk-21.0.6+7 ./compilar/build/src/opt/java


#Crear la imagen logongas/compilar:1.0.0
docker image rm logongas/compilar:1.0.0
docker build -t logongas/compilar:1.0.0 -f ./compilar/build/Dockerfile ./compilar/build/src
docker container run \
     --pull=never \
     -v ./compilar/volumes/app:/opt/app  \
     --name  compilar \
     --hostname compilar \
     logongas/compilar:1.0.0

docker logs compilar 2>&1
docker container stop compilar
docker container rm compilar


#Datos para crear la imagen logongas/java:1.0.0
cp ./compilar/volumes/app/target/Facturas-0.0.1-SNAPSHOT.jar ./java/build/src/opt/app/app.jar

#Crear la imagen logongas/compilar:1.0.0
docker image rm logongas/java:1.0.0
docker build -t logongas/java:1.0.0 -f ./java/build/Dockerfile ./java/build/src





#Levantar los contenedores
docker compose up -d


echo Finalizado deploy $(date +"%Y-%m-%d %H:%M:%S") >> log.txt
