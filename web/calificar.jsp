<%-- 
    Document   : calificar
    Created on : 08-mar-2019, 12:23:15
    Author     : Gonzalo
--%>

<%@page import="entities.Usuario"%>
<%@page import="entities.Images"%>
<%@page import="java.util.List"%>
<%@page import="entities.Playa"%>
<%@page import="entities.Municipio"%>
<%@page import="entities.Provincia"%>
<%@page import="entities.Ccaa"%>
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


        <title>Hello, world!</title>
    </head>
    <body>
        <%
            Ccaa comunidad = (Ccaa) session.getAttribute("comunidad");
            Provincia provincia = (Provincia) session.getAttribute("provincia");
            Municipio municipio = (Municipio) session.getAttribute("municipio");
            Usuario user = (Usuario) session.getAttribute("usuario");
            Playa playa = (Playa) session.getAttribute("playa");
            Images img;
        %>
        <div class="container">
            <nav class="navbar navbar-expand-md navbar-dark bg-primary">
                <a class="navbar-brand" href="home.jsp">
                    <img src="img/previous.png" />
                    <span class="align-middle">Volver</span>
                </a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <span class="align-middle mr-3 text-white">Hola, <%=user.getNick()%></span>
                            <a class="btn btn-danger" href="Controller?op=logout">Logout</a>
                        </li>
                    </ul>
                </div>
            </nav>
            <div class="container bg-info py-3">
                <div class="jumbotron jumbotron-fluid">
                    <div class="container">
                        <h1 class="display-4"><%=playa.getNombre()%></h1>
                        <hr class="my-4">
                        <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                            <ol class="carousel-indicators">
                                <%
                                    List<Images> imagenes = playa.getImagesList();
                                    for (int i = 0; i < imagenes.size(); i++) {
                                        img = imagenes.get(i);
                                        if (i == 0) {
                                %>
                                <li data-target="#carouselExampleIndicators" data-slide-to="<%=i%>" class="active"></li>
                                    <%
                                    } else {
                                    %>
                                <li data-target="#carouselExampleIndicators" data-slide-to="<%=i%>"></li>
                                    <%
                                            }
                                        }
                                    %>
                            </ol>
                            <div class="carousel-inner">
                                <%
                                    for (int i = 0; i < imagenes.size(); i++) {
                                        img = imagenes.get(i);
                                        if (i == 0) {
                                %>
                                <div class="carousel-item active">
                                    <img class="d-block w-100" src="http://playas.chocodev.com/images/<%=playa.getId()%>_<%=img.getId()%>.jpg" alt="playa">
                                </div>
                                <%
                                } else {
                                %>
                                <div class="carousel-item">
                                    <img class="d-block w-100" src="http://playas.chocodev.com/images/<%=playa.getId()%>_<%=img.getId()%>.jpg" alt="playa">
                                </div>
                                <%
                                        }
                                    }
                                %>
                            </div>
                            <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="sr-only">Previous</span>
                            </a>
                            <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="sr-only">Next</span>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="card mb-2">
                    <div class="card-body">
                        <h5><%=playa.getDescripcion()%></h5>
                    </div>
                </div>
                <div class="card mb-2">
                    <div class="card-body row">
                        <div class="col-md-5 col-sm-12">
                            <img class="img-fluid" src="img/ccaa_<%=comunidad.getId()%>.png" />
                        </div>
                        <div class="col-md-7 col-sm-12 mt-4">
                            <h3>Municipio: <%=municipio.getNombre()%></h3>
                            <h3>Provincia: <%=provincia.getNombre()%></h3>
                        </div>
                    </div>
                </div>
                <div class="card mb-3">
                    <div class="card-body row">
                        <span class="mx-auto">
                            <%
                                for (int i = 1; i <= 5; i++) {
                            %>
                            <a href="Controller?op=votarplaya&puntos=<%=i%>"><img class="img-calificar" src="img/ic_<%=i%>.png" /></a>
                            <%  }%>
                        </span>
                    </div>
                </div>
            </div>
        </div>


        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/myjs.js"></script>
    </body>
</html>