//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

// for AJAX date picker
$(function() {
   $("#payment_log_pay_date").live('click', function() {
		$(this).datepicker({dateFormat: 'yy-mm-dd', currentText: '', showOn:'focus' }).removeAttr('value').focus();
	});   
});