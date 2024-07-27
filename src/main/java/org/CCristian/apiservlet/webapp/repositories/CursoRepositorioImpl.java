package org.CCristian.apiservlet.webapp.repositories;

import org.CCristian.apiservlet.webapp.models.Curso;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CursoRepositorioImpl implements Repositorio {

    private Connection conn;

    public CursoRepositorioImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<Curso> listar() throws SQLException{
        List<Curso> cursos = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT c.id, c.nombre, c.instructor, c.duracion FROM cursos AS c ORDER BY c.id")){
            while (rs.next()){
                Curso curso = getCursos(rs);
                cursos.add(curso);
            }
        }
        return cursos;
    }


    @Override
    public List<Curso> porNombre(String nombre) throws SQLException {
        List<Curso> cursos = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM cursos as c WHERE c.nombre like ?")){
            stmt.setString(1, nombre);
            try (ResultSet rs = stmt.executeQuery()){
                if (rs.next()){
                    cursos.add(getCursos(rs));
                }
            }
        }
        return cursos;
    }

    private static Curso getCursos(ResultSet rs) throws SQLException {
        Curso c = new Curso();
        c.setId(rs.getInt("id"));
        c.setNombre(rs.getString("nombre"));
        c.setInstructor(rs.getString("instructor"));
        c.setDuracion(rs.getLong("duracion"));
        return c;
    }
}
