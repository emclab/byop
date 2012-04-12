// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .

var user_password_div = ''

$(document).ready(function() {
	$("#tabs").tabs();
});

//datepicker
// src plant/supplier
$(function() {
   $("#src_plant_src_since").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#src_plant_last_eval_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $('#supplier_supply_since').datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#supplier_last_eval_date").datepicker({dateFormat: 'yy-mm-dd'});
});
// end src plant/supplier
//project
$(function() {
   $("#project_bid_doc_available_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#project_bid_deadline").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#project_bid_opening_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#project_contract_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#project_production_start_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#project_construction_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#project_install_start_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#project_design_start_date").datepicker({dateFormat: 'yy-mm-dd'});
});
//end project
//production, sourcing, purchasing, installation, quality_issue
$(function() {
   $("#production_start_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#production_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#sourcing_start_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#sourcing_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#purchasing_order_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#purchasing_delivery_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#installation_start_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#installation_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#quality_issue_report_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#quality_issue_close_date").datepicker({dateFormat: 'yy-mm-dd'});
});
// end production, sourcing, purchasing, installation
// for AJAX
$(function() {
   $("#test_sample_return_date").live('click', function() {
		$(this).datepicker({dateFormat: 'yy-mm-dd', currentText: '', showOn:'focus' }).removeAttr('value').focus();
	});   
});

// end datepicker


//remove and add field on page
function remove_fields(link) {
  //$(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").remove();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

// end remove fields

//user

//remove the password fields when loading page
$(function (){
	user_password_div = '<div id="user_password">' + $('#user_password').html() + '</div>';
	$('#user_password').remove();
});  // end $(function)

$(function() {
	$('#user_update_password_checkbox').change(function(){
		if ($(this).attr('checked')) {
			$(this).prev().before(user_password_div);		
		} else {
			$('#user_password').remove();
		};
	});
});
// end user