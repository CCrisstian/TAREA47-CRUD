<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, org.CCristian.apiservlet.webapp.models.*" %>

<%
List<Curso> cursos = (List<Curso>) request.getAttribute("cursos");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>TAREA 47: CRUD de Cursos</title>
</head>
<body>
<h1>TAREA 47: C.U.R.D. de Cursos</h1>
<p><a href="<%=request.getContextPath()%>/cursos/form">Crear [+]</a></p>
<div class="form-container">
    <form action="<%=request.getContextPath()%>/buscar" method="post">
        <input type="text" id="nombre" name="nombre" required>
        <input type="submit" value="Buscar">
    </form>
</div>
<table>
    <tr>
        <th>ID</th>
        <th>Nombre</th>
        <th>Instructor</th>
        <th>Duración</th>
        <th>Editar</th>
        <th>Eliminar</th>
    </tr>
    <% for (Curso c : cursos) { %>
    <tr>
        <td><%= c.getId() %></td>
        <td><%= c.getNombre() %></td>
        <td><%= c.getInstructor() %></td>
        <td><%= c.getDuracion() %></td>
        <td><a href="<%= request.getContextPath() %>/cursos/form?id=<%= c.getId() %>">Editar</a></td>
        <td><a onclick="return confirm('¿Está seguro que desea Eliminar?');"
        href="<%= request.getContextPath() %>/cursos/eliminar?id=<%= c.getId() %>">Eliminar</a></td>
    </tr>
    <% } %>
</table>
</body>
</html>
