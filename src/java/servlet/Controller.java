/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import entities.Ccaa;
import entities.Municipio;
import entities.Playa;
import entities.Provincia;
import entities.Punto;
import entities.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import jpautil.JPAUtil;

/**
 *
 * @author Gonzalo
 */
@WebServlet(name = "Controller", urlPatterns = {"/Controller"})
public class Controller extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        RequestDispatcher dispatcher;
        
        String op;
        String sql;
        Query query;
        EntityManager em = null;
        EntityTransaction transaction;
        
        Short idCcaa, idProvincia;
        int idMunicipio;
        List<Ccaa> comunidades;
        List<Provincia> provincias;
        List<Municipio> municipios;
        List<Playa> playas;
        Usuario user = null;
        
        if (em == null) {
            em = JPAUtil.getEntityManagerFactory().createEntityManager();
            session.setAttribute("em", em);
        }
        
        op = request.getParameter("op");
        
        if (op.equals("inicio")) {
            query = em.createNamedQuery("Ccaa.findAll");
            comunidades = query.getResultList();
            
            session.setAttribute("listaComunidades",comunidades);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
            
        } else if (op.equals("ccaa")){
            idCcaa = Short.parseShort(request.getParameter("idCcaa"));
            Ccaa comunidadActual = em.find(Ccaa.class, idCcaa);
            provincias = comunidadActual.getProvinciaList();
            
            session.setAttribute("listaProvincias",provincias);
            session.setAttribute("comunidad",comunidadActual);
            session.setAttribute("provincia",null);
            session.setAttribute("municipio",null);
            session.setAttribute("listaPlayas",null);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
            
        } else if (op.equals("provincia")){
            idProvincia = Short.parseShort(request.getParameter("idProvincia"));
            Provincia provinciaActual = em.find(Provincia.class, idProvincia);
            municipios = provinciaActual.getMunicipioList();
            
            session.setAttribute("listaMunicipios",municipios);
            session.setAttribute("provincia",provinciaActual);
            session.setAttribute("municipio",null);
            session.setAttribute("listaPlayas",null);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
            
        } else if (op.equals("municipio")){
            idMunicipio = Integer.parseInt(request.getParameter("idMunicipio"));
            Municipio municipioActual = em.find(Municipio.class, idMunicipio);
            playas = municipioActual.getPlayaList();
            
            session.setAttribute("listaPlayas",playas);
            session.setAttribute("municipio",municipioActual);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
            
        } else if (op.equals("infovotos")){
            int idPlaya = Integer.valueOf(request.getParameter("idplaya"));
            
            sql = "select concat(p.puntos,'-',count(p)) from Punto p where p.playa.id = :idplaya group by p.puntos order by p.puntos"; 
            query = em.createQuery(sql);
            query.setParameter("idplaya", idPlaya);
            List<String> lista=query.getResultList();
            
            request.setAttribute("infovotos", lista);
            
            dispatcher = request.getRequestDispatcher("info.jsp");
            dispatcher.forward(request, response);
            
        } else if (op.equals("calificar")){
            int idPlaya = Integer.valueOf(request.getParameter("idplaya"));
            Playa playa = em.find(Playa.class, idPlaya);
           
            session.setAttribute("playa",playa);
            
            dispatcher = request.getRequestDispatcher("calificar.jsp");
            dispatcher.forward(request, response);
            
        } else if (op.equals("votarplaya")){
            Short puntos = Short.parseShort(request.getParameter("puntos"));
            user = (Usuario) session.getAttribute("usuario");
            Playa playa = (Playa) session.getAttribute("playa");
            
            Punto voto = new Punto();
            voto.setPuntos(puntos);
            voto.setUsuario(user);
            voto.setPlaya(playa);
            
            transaction = em.getTransaction();
            transaction.begin();
            em.persist(voto);
            transaction.commit();
            em.getEntityManagerFactory().getCache().evictAll();
            
            dispatcher = request.getRequestDispatcher("calificar.jsp");
            dispatcher.forward(request, response);
            
        } else if(op.equals("login")){
            String nick = (String) request.getParameter("textNick");
            String pass = (String) request.getParameter("textPass");
            
            sql = "select u from Usuario u where u.nick = :nick and u.pass = :pass"; 
            query = em.createQuery(sql);
            query.setParameter("nick", nick);
            query.setParameter("pass", pass);
            
            try {
                user = (Usuario) query.getSingleResult();
            } catch (Exception e) {
            }
            
            if (user == null){
                query = em.createNamedQuery("Usuario.findByNick");
                query.setParameter("nick", nick);
                
                try {
                    user = (Usuario) query.getSingleResult();
                } catch (Exception e) {
                }
                
                if(user!=null){
                    System.out.println("Pass mal");
                    
                } else {
                    Usuario nuevoUsuario = new Usuario();
                    nuevoUsuario.setNick(nick);
                    nuevoUsuario.setPass(pass);

                    transaction = em.getTransaction();
                    transaction.begin();
                    em.persist(nuevoUsuario);
                    transaction.commit();
                    em.getEntityManagerFactory().getCache().evictAll();
                    
                    query = em.createNamedQuery("Usuario.findByNick");
                    query.setParameter("nick", nick);
                    user = (Usuario) query.getSingleResult();
                    
                    session.setAttribute("usuario", user);
                }
                
            } else {
                session.setAttribute("usuario", user);
            }
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
            
        } else if(op.equals("logout")){
            session.setAttribute("usuario", null);
            
            dispatcher = request.getRequestDispatcher("home.jsp");
            dispatcher.forward(request, response);
        }
        
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
