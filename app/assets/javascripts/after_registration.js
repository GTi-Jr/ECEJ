  $('.datepicker').pickadate({
    monthsFull: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'],
    monthsShort: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'],
    weekdaysFull: ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'],
    weekdaysShort: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'],
    today: 'Hoje',
    clear: 'Limpar',
    close: 'Fechar',
    format: 'dd/mm/yyyy',
    min: new Date(1940,1,1),
    max: new Date(2001,12,31),
    max: true,
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 40, // Creates a dropdown of 15 years to control year
    yearRange: '1950:2005'
  });

  function valueChanged(){
        if($('#filled-in-box').is(":checked")){
            $("#federation_div").show();
            $( "#federation" ).rules( "add", {
              required: true,
              messages: {
                required: "Se você pertence a uma EJ federada, é necessário que informe qual federação."
              }
            });
        }
        else{
            $("#federation_div").hide();
        }
  }

    $('#cpf').formatter({
            'pattern': '{{999}}.{{999}}.{{999}}-{{99}}',
    });
    $('#phone').formatter({
            'pattern': '({{99}}) {{99999}} {{9999}}',
    });
    $('#postal_code').formatter({
            'pattern': '{{99999}}-{{999}}',
    });
    $('#birthday').formatter({
        'pattern': '{{99}}/{{99}}/{{9999}}',
    });
    $('.progress').hide();
    if($("#edit_user_form").length){
    $("#edit_user_form").validate({
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
         }
       }
     });
     $( "#user_avatar" ).rules( "add", {
       extension: "png|jpg",
       messages: {
         extension: "Só são permitidos arquivos .jpg ou .png"
       }
     });
     $( "#name" ).rules( "add", {
       required: true,
       messages: {
         required: "Preencha com nome completo"
       }
     });
     $( "#rg" ).rules( "add", {
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
     $( "#cep" ).rules( "add", {
       required: true,
       messages: {
         required: "Preencha com seu CEP"
       }
     });
     $( "#state" ).rules( "add", {
       required: true,
       messages: {
         required: "Preencha com seu Estado"
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
     $( "#birthday" ).rules( "add", {
       required: true,
       messages: {
         required: "Informe sua Data de Nascimento"
       }
     });
     $( "#transport" ).rules( "add", {
       required: true,
       messages: {
         required: "Precisamos saber se precisa de transporte para o evento"
       }
     });
   }
