//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function() {
   $("#sourcing_start_date_search").datepicker({dateFormat: 'yy-mm-dd'});
   $("#sourcing_end_date_search").datepicker({dateFormat: 'yy-mm-dd'});
});

//for calculating total
$(function(){
    $("#sourcing_qty").change(function(){
    	rpt = ($("#sourcing_qty").val() * $("#sourcing_unit_price").val()).toFixed(2);
    	//alert(rpt);
    	if ($.isNumeric(rpt) && rpt > 0){
    		//alert($.isNumeric(rpt));
    		$("#sourcing_total").val(rpt);
    	} else {
    		$("#sourcing_total").val("");
    	}
    });
});
$(function(){
    $("#sourcing_unit_price").change(function(){
    	rpt = ($("#sourcing_qty").val() * $("#sourcing_unit_price").val()).toFixed(2);
    	if ($.isNumeric(rpt) && rpt > 0){
    	    //alert(rpt);
    		$("#sourcing_total").val(rpt);
    	} else {
    		//alert(rpt);
    		$("#sourcing_total").val("");
    	}  	
    });
});
