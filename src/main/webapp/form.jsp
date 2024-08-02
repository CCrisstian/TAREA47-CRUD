<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, org.CCristian.apiservlet.webapp.models.*" %>

<%
    Curso curso = (Curso) request.getAttribute("curso");
    Map<String, String> errores = (Map<String, String>) request.getAttribute("errores");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Formulario de Cursos</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/styles.css">
</head>
<body>
<h1>Formulario de Cursos</h1>
<form action="<%=request.getContextPath()%>/cursos/form" method="post">
    <div>
        <label for="nombre">Nombre</label>
        <div>
            <input type="text" name="nombre" id="nombre" value="<%=curso.getNombre() != null? curso.getNombre(): ""%>">
        </div>
        <% if(errores != null && errores.containsKey("nombre")){%>
            <div style="color:red;"><%=errores.get("nombre")%></div>
        <% } %>
    </div>
    <div>
         <label for="descripcion">Descripción</label>
         <div>
            <textarea name="descripcion" rows="5" cols="50" id="descripcion"><%= curso.getDescripcion() != null ? curso.getDescripcion() : "" %></textarea>
        </div>
        <% if(errores != null && errores.containsKey("descripcion")){%>
                <div style="color:red;"><%=errores.get("descripcion")%></div>
        <% } %>
    </div>
    <div>
         <label for="instructor">Instructor</label>
            <div>
                <input type="text" name="instructor" id="instructor" value="<%=curso.getInstructor() != null? curso.getInstructor(): ""%>">
            </div>
        <% if(errores != null && errores.containsKey("instructor")){%>
            <div style="color:red;"><%=errores.get("instructor")%></div>
        <% } %>
    </div>
    <div>
       <label for="duracion">Duración</label>
          <div>
            <input type="number" name="duracion" id="duracion" value="<%=curso.getDuracion() != 0? curso.getDuracion(): ""%>">
          </div>
          <% if(errores != null && errores.containsKey("duracion")){%>
            <div style="color:red;"><%=errores.get("duracion")%></div>
       <% } %>
    </div>
    <div><input type="submit" value="<%=(curso.getId() > 0)?"Editar":"Crear"%>"></div>
    <input type="hidden" name="id" value="<%=curso.getId()%>" >
</body>
</html>