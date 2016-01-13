// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require materialize.js
//= require plugins.js
//= require plugins/prism/prism.js
//= require plugins/formatter/jquery.formatter.min.js
//= require plugins/jquery-validation/jquery.validate.min.js
//= require plugins/jquery-validation/additional-methods.min.js
//= require plugins/perfect-scrollbar/perfect-scrollbar.min.js
//= require dropify.min.js
//= require after_registration.js
//= require user_dashboard.js
$('.dropify').dropify({
    messages: {
        'default': 'Arraste a foto ou clique para enviar',
        'replace': 'Arraste ou clique para substituir',
        'remove':  'Remover',
        'error':   'Esse arquivo é muito grande'

    }
});
$('.dropdown-button').dropdown({
      inDuration: 300,
      outDuration: 225,
      constrain_width: false, // Does not change width of dropdown to that of the activator
      hover: true, // Activate on hover
      gutter: 0, // Spacing from edge
      belowOrigin: true, // Displays dropdown below the button
      alignment: 'left' // Displays dropdown with edge aligned to the left of button
    }
  );
$('.progress').hide();
if($("#edit_user").length){
  $("#edit_user").validate({
    submitHandler: function(form) {
      // do other things for a valid form
      $('.progress').show();
      form.submit();
    },
    errorElement : 'div',
    errorPlacement: function(error, element) {
      var placement = $(element).data('error');
      if (placement) {
        $(placement).append(error)
      } else {
        error.insertAfter(element);
        alert("Erro ao enviar imagem, permitidos apenas arquivos .jpg ou .png");
      }
    }
   });
   $( "#user_avatar" ).rules( "add", {
     extension: "png|jpg",
     messages: {
       extension: "Só são permitidos arquivos .jpg ou .png"
     }
   });
}
if($("#edit_password_form").length){
   $("#edit_password_form").validate({
     errorElement : 'div',
     errorPlacement: function(error, element) {
       var placement = $(element).data('error');
       if (placement) {
         $(placement).append(error)
       } else {
         error.insertAfter(element);
       }
     }
   });
   $( "#current_password" ).rules( "add", {
     required: true,
     messages: {
       required: "Entre com sua senha atual",
     }
   });
   $( "#new_password" ).rules( "add", {
     required: true,
     rangelength: [8,12],
     messages: {
       required: "Entre com sua senha",
       rangelength: "Sua nova senha deve conter entre 8 e 12 caracteres"
     }
   });
   $( "#new_confirm_password" ).rules( "add", {
     required: true,
     rangelength: [8,12],
     equalTo: "#new_password",
     messages: {
       required: "Entre com sua senha",
       rangelength: "Sua nova senha deve conter entre 8 e 12 caracteres",
       equalTo: "As senhas não conferem"
     }
   });
 }
