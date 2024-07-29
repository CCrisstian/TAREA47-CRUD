<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, org.CCristian.apiservlet.webapp.models.*" %>

<%
List<Curso> cursos = (List<Curso>) request.getAttribute("cursos");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>TAREA 46: Listado de cursos y búsqueda de información</title>
</head>
<body>
<h1>TAREA 46: Listado de cursos</h1>
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
    </tr>
    <% for (Curso c : cursos) { %>
    <tr>
        <td><%= c.getId() %></td>
        <td><%= c.getNombre() %></td>
        <td><%= c.getInstructor() %></td>
        <td><%= c.getDuracion() %></td>
    </tr>
    <% } %>
</table>
</body>
</html>
