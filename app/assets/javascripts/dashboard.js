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
//= require after_registration.js
//= require user_dashboard.js
$('.progress').hide();
$("#edit_user").validate({
  submitHandler: function(form) {
    // do other things for a valid form
    $('.progress').show();
    form.submit();
  }
 });
