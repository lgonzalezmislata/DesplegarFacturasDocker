FROM ubuntu:24.04
 
# Configurar entorno no interactivo para evitar prompts en apt
ENV DEBIAN_FRONTEND=noninteractive
 
# Actualizar paquetes y instalar dependencias necesarias
RUN apt-get update
RUN apt-get install -y curl unzip ca-certificates
     
# Instalar Node.js y npm desde los repositorios oficiales
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs 
RUN npm install -g sass
 
COPY /opt /opt
 
 
 
# Instalar JDK Temurin desde una carpeta local
ENV JAVA_HOME=/opt/java
ENV PATH="${JAVA_HOME}/bin:${PATH}"
 
# Instalar Maven desde una carpeta local
ENV MAVEN_HOME=/opt/maven
ENV PATH="${MAVEN_HOME}/bin:${PATH}"
 
# Crear un settings.xml básico para maven para que se conecte a los servidores
RUN mkdir -p /root
COPY /root /root
 
 
WORKDIR /opt/app
 
CMD ["mvn","clean","install"]
