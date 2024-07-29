<h1 align="center">TAREA 46: Listado de cursos y búsqueda de información</h1>

El objetivo de la tarea consiste en crear una aplicación web para cursos de programación llamado <b>webapp-bbdd-tarea9</b> que nos permita ver el listado de cursos y un sistema de búsqueda por nombre, manejando separación de capa MVC.
Los requerimientos consisten en incorporar la capa de servicios, separándola del controlador (servlet), una clase repositorio (que se encarga de manejar los datos) para listar y buscar por nombre.
La tabla cursos la pueden crear a partir del siguiente esquema DDL:

```sql
CREATE TABLE `cursos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) DEFAULT NULL,
  `descripcion` varchar(120) DEFAULT NULL,
  `instructor` varchar(45) DEFAULT NULL,
  `duracion` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB
```

Con los datos de ejemplo

```sql
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Máster Completo en Java de cero a experto con IntelliJ', 'Aprende Java SE, Jakarta EE, Hibernate y mas', 'Andres Guzman', 98.53);
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Spring Framework 5: Creando webapp de cero a experto', 'Construye aplicaciones web con Spring Framework 5 & Spring Boot', 'Andres Guzman', 41.51);
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Angular & Spring Boot: Creando web app full stack', 'Desarrollo frontend con Angular y backend Spring Boot 2', 'Andres Guzman', 23.54);
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Microservicios con Spring Boot y Spring Cloud Netflix Eureka', 'Construye Microservicios Spring Boot 2, Eureka, Spring Cloud', 'Andres Guzman', 19.55);
INSERT INTO cursos(nombre, descripcion, instructor, duracion) VALUES('Guía Completa JUnit y Mockito incluye Spring Boot Test', 'Aprende desde cero JUnit 5 y Mockito en Spring Boot 2', 'Andres Guzman', 15.12);
```

Se pide crear e implementar las clases:

- modelo Curso
- de conexión a la BBDD ConexionBaseDatos
- la clase CursoRepositorioImpl implementada a partir de la interface Repositorio (con generic) solo para listar y buscar por nombre:

```java
    List<Curso> listar();
    List<Curso> porNombre(String id);
```

La consulta por nombre la pueden realizar usando where like, de la siguiente forma: 

```sql
SELECT * FROM cursos as c WHERE c.nombre like ?
```

Y el parámetro nombre lo pasan de la siguiente forma: 

```java
stmt.setString(1, "%" + nombre + "%");
```

Los porcentajes "%" + nombre + "%" indican que busque coincidencias tanto a la derecha como a la izquierda del string nombre, el signo de pregunta es el parámetro de búsqueda de la sentencia preparada.

La clase e interface de servicio para curso también con los dos métodos mencionados.

Implementar dos servlets uno para listar y otro para buscar, con la vista jsp separada usando patrón MVC, pasando los atributos a la vista (cursos y un titulo), también tener en cuenta el filtro para la conexión a la base de datos y la clase de excepción ServiceJdbcException.

El listados de los cursos se manejan en un servlet llamado CursoServlet, sobre el listado de cursos agregar un buscador con formulario HTML que permite buscar por nombre del curso, luego la búsqueda la procesa el servlet llamado BuscarCursoServlet que debe mostrar la lista filtrada reutilizando la misma vista del listado.

Una vez terminada y probada la tarea deberán enviar el código fuente de todos los archivos involucrados, además de las imágenes screenshot (imprimir pantalla).

NO subir el proyecto completo, sólo los archivos involucrados, que son los siguientes:

- Clase modelo Curso.
- Clase de acceso a datos CursoRepositorioImpl y su interface Repositorio.
- Clase de servicio CursoServiceImpl y su interface CursoService.
- Clases servlets CursoServlet y BuscarCursoServlet.
- Vista listar.jsp
- Clase ConexionBaseDatos.
- Clase filtro de conexión ConexionFilter.
- Clase ServiceJdbcException
- pom.xml

<h1>Resolución del Profesor</h1>

- Clase modelo Curso.
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.models;

public class Curso {
    
    private Long id;
    private String nombre;
    private String descripcion;
    private String instructor;
    private Double duracion;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getInstructor() {
        return instructor;
    }

    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }

    public Double getDuracion() {
        return duracion;
    }

    public void setDuracion(Double duracion) {
        this.duracion = duracion;
    }
}
```
- Clase de acceso a datos CursoRepositorioImpl y su interface Repositorio.
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.repositories;

import java.sql.SQLException;
import java.util.List;

public interface Repository<T> {
    List<T> listar() throws SQLException;
    List<T> porNombre(String nombre) throws SQLException;
}
```
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.repositories;

import org.aguzman.apiservlet.webapp.bbdd.tarea9.models.Curso;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CursoRepositorioImpl implements Repository<Curso> {

    private Connection conn;

    public CursoRepositorioImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<Curso> listar() throws SQLException {
        List<Curso> cursos = new ArrayList<>();

        try ( Statement stmt = conn.createStatement();  ResultSet rs = stmt.executeQuery("SELECT * FROM cursos as c")) {
            while (rs.next()) {
                Curso p = getCurso(rs);
                cursos.add(p);
            }
        }
        return cursos;
    }

    @Override
    public List<Curso> porNombre(String nombre) throws SQLException {
        List<Curso> cursos = new ArrayList<>();
        
        try ( PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cursos as c WHERE c.nombre like ?")) {
            stmt.setString(1, "%" + nombre + "%");

            try ( ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    cursos.add(getCurso(rs));
                }
            }
        }
        
        return cursos;
    }

    private Curso getCurso(ResultSet rs) throws SQLException {
        Curso c = new Curso();
        c.setId(rs.getLong("id"));
        c.setNombre(rs.getString("nombre"));
        c.setDescripcion(rs.getString("descripcion"));
        c.setInstructor(rs.getString("instructor"));
        c.setDuracion(rs.getDouble("duracion"));
        return c;
    }
}
```
- Clase de servicio CursoServiceImpl y su interface CursoService.
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.services;

import org.aguzman.apiservlet.webapp.bbdd.tarea9.models.Curso;

import java.util.List;

public interface CursoService {
    List<Curso> listar();
    List<Curso> porNombre(String nombre);
}
```
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.services;

import org.aguzman.apiservlet.webapp.bbdd.tarea9.models.Curso;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.repositories.CursoRepositorioImpl;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.repositories.Repository;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class CursoServiceImpl implements CursoService{
    private Repository<Curso> repository;

    public CursoServiceImpl(Connection connection) {
        this.repository = new CursoRepositorioImpl(connection);
    }

    @Override
    public List<Curso> listar() {
        try {
            return repository.listar();
        } catch (SQLException e) {
            throw new ServiceJdbcException(e.getMessage(), e.getCause());
        }
    }

    @Override
    public List<Curso> porNombre(String nombre) {
        try {
            return repository.porNombre(nombre);
        } catch (SQLException e) {
            throw new ServiceJdbcException(e.getMessage(), e.getCause());
        }
    }
}
```
- Clases servlets CursoServlet y BuscarCursoServlet.
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.controllers;

import org.aguzman.apiservlet.webapp.bbdd.tarea9.services.CursoService;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.services.CursoServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.models.Curso;

@WebServlet({"/index.html", "/cursos"})
public class CursoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Connection conn = (Connection) req.getAttribute("conn");
        CursoService service = new CursoServiceImpl(conn);
        List<Curso> cursos = service.listar();

        req.setAttribute("titulo", "Tarea 9: Listado de cursos");
        req.setAttribute("cursos", cursos);
        getServletContext().getRequestDispatcher("/listar.jsp").forward(req, resp);
    }
}
```
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.services.CursoServiceImpl;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.models.Curso;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.services.CursoService;

@WebServlet("/cursos/buscar")
public class BuscarCursoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Connection conn = (Connection) req.getAttribute("conn");
        CursoService service = new CursoServiceImpl(conn);
        String nombre = req.getParameter("nombre");
        
        List<Curso> cursos = service.porNombre(nombre);

        req.setAttribute("titulo", "Tarea 9: filtrando cursos");
        req.setAttribute("cursos", cursos);
        getServletContext().getRequestDispatcher("/listar.jsp").forward(req, resp);
    }
}
```
- Vista listar.jsp
```java
<%@page contentType="UTF-8" import="java.util.*, org.aguzman.apiservlet.webapp.bbdd.tarea9.models.*"%>
<%
List<Curso> cursos = (List<Curso>) request.getAttribute("cursos");
String titulo = (String) request.getAttribute("titulo");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title><%=titulo%></title>
    </head>
    <body>
        <h1><%=titulo%></h1>
        <form action="<%=request.getContextPath()%>/cursos/buscar" method="post">
            <input type="text" name="nombre">
            <input type="submit" value="Buscar">
        </form>
        <table>
            <tr>
                <th>id</th>
                <th>nombre</th>
                <th>instructor</th>
                <th>duracion</th>
            </tr>
            <% for(Curso c: cursos){%>
            <tr>
                <td><%=c.getId()%></td>
                <td><%=c.getNombre()%></td>
                <td><%=c.getInstructor()%></td>
                <td><%=c.getDuracion()%></td>
            </tr>
            <%}%>
        </table>
    </body>
</html>
```
- Clase ConexionBaseDatos.
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBaseDatos {

    private static String url = "jdbc:mysql://localhost:3306/java_curso?serverTimezone=America/Santiago";
    private static String username = "root";
    private static String password = "sasa";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
}
```
- Clase filtro de conexión ConexionFilter.
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.services.ServiceJdbcException;
import org.aguzman.apiservlet.webapp.bbdd.tarea9.util.ConexionBaseDatos;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebFilter("/*")
public class ConexionFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        try (Connection conn = ConexionBaseDatos.getConnection()) {

            if (conn.getAutoCommit()) {
                conn.setAutoCommit(false);
            }

            try {
                request.setAttribute("conn", conn);
                chain.doFilter(request, response);
                conn.commit();
            } catch (SQLException | ServiceJdbcException e) {
                conn.rollback();
                ((HttpServletResponse)response).sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```
- Clase ServiceJdbcException
```java
package org.aguzman.apiservlet.webapp.bbdd.tarea9.services;

public class ServiceJdbcException extends RuntimeException{
    public ServiceJdbcException(String message) {
        super(message);
    }

    public ServiceJdbcException(String message, Throwable cause) {
        super(message, cause);
    }
}
```
- pom.xml
```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.aguzman.apiservlet.webapp.bbdd.tarea9</groupId>
    <artifactId>webapp-bbdd-tarea9</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>
    <properties>
        <maven.compiler.source>16</maven.compiler.source>
        <maven.compiler.target>16</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>
    <dependencies>
        <dependency>
            <groupId>jakarta.platform</groupId>
            <artifactId>jakarta.jakartaee-api</artifactId>
            <version>9.0.0</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>
    <build>
        <finalName>${project.artifactId}</finalName>
        <plugins>
            <plugin>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
            </plugin>
            <plugin>
                <groupId>org.apache.tomcat.maven</groupId>
                <artifactId>tomcat7-maven-plugin</artifactId>
                <version>2.2</version>
                <configuration>
                    <url>http://localhost:8080/manager/text</url>
                    <username>admin</username>
                    <password>12345</password>
                </configuration>
            </plugin>
            <plugin>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.2.3</version>
                <configuration>
                    <failOnMissingWebXml>false</failOnMissingWebXml>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```
