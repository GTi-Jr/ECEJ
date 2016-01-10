// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js
$('.datepicker').pickadate({
  format: 'dd/mm/yyyy',
  formatSubmit: 'yyyy-mm-dd',
  selectYears: 80,
  max: true
});
$('#cpf').formatter({
        'pattern': '{{999}}.{{999}}.{{999}}-{{99}}',
});
$('#phone').formatter({
        'pattern': '+55 ({{99}}) {{99999}} {{9999}}',
});
$('#postal_code').formatter({
        'pattern': '{{99999}}-{{999}}',
});
$("#edit_user_form").validate({
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
 $( "#name" ).rules( "add", {
   required: true,
   messages: {
     required: "Preencha com nome completo"
   }
 });
 $( "#general_register" ).rules( "add", {
   required: true,
   digits: true,
   messages: {
     required: "Entre com seu número de identidade",
     digits: "Preencha esse campo apenas com números"
   }
 });
 $( "#cpf" ).rules( "add", {
   required: true,
   rangelength: [11,14],
   messages: {
     required: "Entre com seu cpf",
     rangelength: "O CPF deve possuir 11 dígitos"
   }
 });
 $( "#phone" ).rules( "add", {
   required: true,
   messages: {
     required: "Entre com seu número de celular"
   }
 });
 $( "#postal_code" ).rules( "add", {
   required: true,
   messages: {
     required: "Preencha com seu CEP"
   }
 });
 $( "#city" ).rules( "add", {
   required: true,
   messages: {
     required: "Preencha com o nome de sua cidade"
   }
 });
 $( "#street" ).rules( "add", {
   required: true,
   messages: {
     required: "Preencha com seu endereço - rua e número"
   }
 });
 $( "#junior_enterprise" ).rules( "add", {
   required: true,
   messages: {
     required: "Entre com o nome de sua EJ"
   }
 });
 $( "#job" ).rules( "add", {
   required: true,
   messages: {
     required: "Diga qual cargo exerce"
   }
 });
 $( "#university" ).rules( "add", {
   required: true,
   messages: {
     required: "Informe a universidade da sua EJ"
   }
 });
