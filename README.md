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
