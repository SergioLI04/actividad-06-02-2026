#!/bin/bash

echo "--- 1. ACTUALIZANDO DESDE GITHUB ---"
git pull origin main

echo "--- 2. LIMPIANDO ENTORNO ---"
rm -rf temporal
mkdir -p temporal/WEB-INF/classes

echo "--- 3. COMPILANDO ---"

javac -cp "/usr/share/tomcat10/lib/servlet-api.jar" -d temporal/WEB-INF/classes src/hola/HolaServlet.java

echo "--- 4. CREANDO WEB.XML ---"
cat <<EOF > temporal/WEB-INF/web.xml
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee" version="5.0">
  <servlet>
    <servlet-name>Hola</servlet-name>
    <servlet-class>hola.HolaServlet</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>Hola</servlet-name>
    <url-pattern>/inicio</url-pattern>
  </servlet-mapping>
</web-app>
EOF

echo "--- 5. GENERANDO ARCHIVO WAR ---"
cd temporal
jar -cvf hola.war *
cd ..

echo "--- 6. DESPLEGANDO EN WEBAPPS ---"

sudo cp temporal/hola.war /var/lib/tomcat10/webapps/

echo "--- 7. REINICIANDO SERVICIO ---"

sudo systemctl restart tomcat10

echo "--- 8. COMPROBANDO RESPUESTA ---"
sleep 5
curl -I http://localhost:8080/hola/inicio
