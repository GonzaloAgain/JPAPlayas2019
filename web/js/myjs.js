$(document).ready(function() {
    console.log('ready');
    init();
});

//Funcion que inicializa
function init(){
    $('.carousel').carousel()
    loadVotaciones();
}

function loadVotaciones(){	
    $('#modalVotos').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var idplaya = button.data('id');
        var nombre = button.data('whatever');
        $(".modal-title").text("Calificaciones de "+nombre);
        console.log('playa' + idplaya);
        $.ajax({
            type: "GET",
            url: "Controller?op=infovotos&idplaya=" + idplaya,
            success: function (info) {
                $(".modal-body").html(info);
            }
        });
    });
}



