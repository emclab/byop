//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function() {
	$("#purchasing_actual_receiving_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#purchasing_start_date_search").datepicker({dateFormat: 'yy-mm-dd'});
   $("#purchasing_end_date_search").datepicker({dateFormat: 'yy-mm-dd'});
});

//for calculating total
$(function(){
    $("#purchasing_qty").change(function(){
    	rpt = ($("#purchasing_qty").val() * $("#purchasing_unit_price").val()).toFixed(2);
    	//alert(rpt);
    	if ($.isNumeric(rpt) && rpt > 0){
    		//alert($.isNumeric(rpt));
    		$("#purchasing_total").val(rpt);
    	} else {
    		$("#purchasing_total").val("");
    	}
    });
});
$(function(){
    $("#purchasing_unit_price").change(function(){
    	rpt = ($("#purchasing_qty").val() * $("#purchasing_unit_price").val()).toFixed(2);
    	if ($.isNumeric(rpt) && rpt > 0){
    	    //alert(rpt);
    		$("#purchasing_total").val(rpt);
    	} else {
    		//alert(rpt);
    		$("#purchasing_total").val("");
    	}  	
    });
});
