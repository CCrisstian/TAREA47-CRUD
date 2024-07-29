package org.CCristian.apiservlet.webapp.services;

import org.CCristian.apiservlet.webapp.models.Curso;
import org.CCristian.apiservlet.webapp.repositories.CursoRepositorioImpl;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class CursoServiceImpl implements CursoService{

    private CursoRepositorioImpl repositoryJBDC;

    public CursoServiceImpl(Connection connection) {
        this.repositoryJBDC = new CursoRepositorioImpl(connection);
    }

    @Override
    public List<Curso> listar() throws SecurityException {
        try {
            return repositoryJBDC.listar();
        }catch (SQLException throwables){
            throw new ServiceJdbcException(throwables.getMessage(), throwables.getCause());
        }
    }

    @Override
    public List<Curso> porNombre(String nombre) {
        try {
            return repositoryJBDC.porNombre(nombre);
        } catch (SQLException throwables){
            throw new ServiceJdbcException(throwables.getMessage(), throwables.getCause());
        }
    }
}
