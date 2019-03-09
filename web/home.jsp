<%-- 
    Document   : home
    Created on : 08-mar-2019, 9:06:32
    Author     : Gonzalo
--%>

<%@page import="entities.Usuario"%>
<%@page import="entities.Playa"%>
<%@page import="entities.Municipio"%>
<%@page import="entities.Provincia"%>
<%@page import="entities.Ccaa"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!--Import Google Icon Font-->
        <link href="css/fonts.css" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link type="text/css" rel="stylesheet" href="css/bootstrap.min.css">
        <link type="text/css" rel="stylesheet" href="css/mycss.css"/>


        <title>Playas</title>
    </head>
    <body>
        <%
            List<Ccaa> comunidades = (List<Ccaa>) session.getAttribute("listaComunidades");
            List<Provincia> provincias = (List<Provincia>) session.getAttribute("listaProvincias");
            List<Municipio> municipios = (List<Municipio>) session.getAttribute("listaMunicipios");
            List<Playa> playas = (List<Playa>) session.getAttribute("listaPlayas");

            Ccaa comunidadActual = (Ccaa) session.getAttribute("comunidad");
            Provincia provinciadActual = (Provincia) session.getAttribute("provincia");
            Municipio municipioActual = (Municipio) session.getAttribute("municipio");
            Usuario user = (Usuario) session.getAttribute("usuario");
        %>
        <div class="container">
            <nav class="navbar navbar-expand-md navbar-dark bg-primary">
                <a class="navbar-brand" href="#">Playas de España</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <%
                            if (user == null) {
                        %>
                        <li class="nav-item">
                            <a class="btn btn-secondary text-white" data-toggle="modal" data-target="#modalLogin">Login</a>
                        </li>
                        <%
                        } else {
                        %>
                        <li class="nav-item">
                            <span class="align-middle mr-3 text-white">Hola, <%=user.getNick()%></span>
                            <a class="btn btn-danger" href="Controller?op=logout">Logout</a>
                        </li>
                        <%  }   %>
                    </ul>
                </div>
            </nav>

            <div class="container bg-info">
                <div class="row text-center pt-3">
                    <div class="col-md-4 mb-3">
                        <form class="mx-3" action="Controller" method="post" >
                            <input type="hidden" name="op" value="ccaa">
                            <select name="idCcaa" id="selectCcaa" class="custom-select" onchange="this.form.submit()">
                                <option value="" disabled selected>Selecciona Comunidad Autómona</option>
                                <%
                                    for (Ccaa ccaa : comunidades) {
                                %>
                                <option value="<%=ccaa.getId()%>"><%=ccaa.getNombre()%></option>
                                <%  } %>
                            </select>
                        </form>
                    </div>
                    <div class="col-md-4 mb-3">
                        <form class="mx-3" action="Controller" method="post" >
                            <input type="hidden" name="op" value="provincia">
                            <select name="idProvincia" id="selectProvincia" class="custom-select" onchange="this.form.submit()">
                                <option value="" disabled selected>Selecciona Provincia</option>
                                <%
                                    if (provincias != null) {
                                        for (Provincia provincia : provincias) {
                                %>
                                <option value="<%=provincia.getId()%>"><%=provincia.getNombre()%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </form>
                    </div>
                    <div class="col-md-4 mb-3">
                        <form class="mx-3" action="Controller" method="post" >
                            <input type="hidden" name="op" value="municipio">
                            <select name="idMunicipio" id="selectMunicipio" class="custom-select" onchange="this.form.submit()">
                                <option value="" disabled selected>Selecciona Municipio</option>
                                <%
                                    if (municipios != null) {
                                        for (Municipio municipio : municipios) {
                                %>
                                <option value="<%=municipio.getId()%>"><%=municipio.getNombre()%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </form>
                    </div>
                </div>

                <div class="row mt-2">
                    <%
                        if (playas != null) {
                            for (Playa playa : playas) {
                    %>
                    <div class="col-md-12 col-sm-12 mb-3">
                        <div class="card">
                            <div class="card-body row">
                                <div class="col-md-4 col-sm-12 mb-3">
                                    <img class="img-fluid" src="http://playas.chocodev.com/images/<%=playa.getId()%>_<%=playa.getImagesList().get(0).getId()%>.jpg" alt="imgplaya">
                                </div>
                                <div class="col-md-8 col-sm-12">
                                    <h1><%=playa.getNombre()%></h1>
                                    <h3><%=playa.getDescripcion()%></h3>
                                    <% 
                                        if(user!=null){
                                    %>
                                    <p class="pt-3">
                                        <a class="btn btn-info text-white" data-toggle="modal" data-target="#modalVotos" data-id="<%=playa.getId()%>" data-whatever="<%=playa.getNombre()%>">Info</a>
                                        <a class="btn btn-success" href="Controller?op=calificar&idplaya=<%=playa.getId()%>">Calificar</a>
                                    </p>
                                    <%  }   %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <div class="col text-center pb-3">
                        <img class="img-fluid" src="img/playas.jpg" alt="portada" />
                    </div>
                    <%  } %> 
                </div>
            </div>


        </div>

        <!-- Modal Info -->
        <div class="modal fade" id="modalVotos" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        ...
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Login -->
        <div class="modal fade" id="modalLogin" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Login or Registrer</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form action="Controller" method="post">
                        <div class="modal-body">
                            <div class="form-group row">
                                <label for="textNick" class="col-sm-3 col-form-label">Nick</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="textNick" name="textNick" >
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="textPass" class="col-sm-3 col-form-label">Password</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="textPass" name="textPass" >
                                </div>
                            </div>
                            <div class="form-group row">
                                <input type="hidden" name="op" value="login">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                            <button type="submit" class="btn btn-primary">Guardar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/myjs.js"></script>

        <%
            if (comunidadActual != null) {
        %>
        <script type="text/javascript">
            $('#selectCcaa').val('<%= comunidadActual.getId()%>')
        </script>
        <%  }
            if (provinciadActual != null) {
        %>
        <script type="text/javascript">
            $('#selectProvincia').val('<%= provinciadActual.getId()%>')
        </script>
        <%  }
            if (municipioActual != null) {
        %>
        <script type="text/javascript">
            $('#selectMunicipio').val('<%= municipioActual.getId()%>')
        </script>
        <%  }%>

    </body>
</html>
