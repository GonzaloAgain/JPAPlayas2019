<%-- 
    Document   : info
    Created on : 08-mar-2019, 11:19:39
    Author     : Gonzalo
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<String> listaVotos = (List<String>) request.getAttribute("infovotos");
    if (listaVotos.size() == 0) {
%>
No hay votos
<%  } else {
%>
<table class="table table-borderless">
    <tbody class="text-center">
        <%
            for (int i = 1; i <= 5; i++) {
                int numero = 0;
                for (int j = 0; j < listaVotos.size(); j++) {
                    int puntos = Integer.parseInt(listaVotos.get(j).substring(0, listaVotos.get(j).indexOf("-")));
                    if (i == puntos) {
                        numero = Integer.parseInt(listaVotos.get(j).substring(listaVotos.get(j).indexOf("-") + 1));
                        break;
                    }
                }
        %>
        <tr>
            <td><img class="img-voto" src="img/ic_<%=i%>.png" /></td>
            <td><%=numero%></td>
        </tr>
        <%  }   %>
    </tbody>
</table>
<%  }%>
