package org.CCristian.apiservlet.webapp.services;

import org.CCristian.apiservlet.webapp.models.Curso;

import java.util.List;
import java.util.Optional;

public interface CursoService {
    List<Curso> listar() throws SecurityException;
    Optional<Curso> porNombre(String nombre);
}
