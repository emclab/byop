//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

//for calculating total
$(function(){
    $("#part_in_qty").change(function(){
    	rpt = ($("#part_in_qty").val() * $("#part_unit_price").val()).toFixed(2);
    	//alert(rpt);
    	if ($.isNumeric(rpt) && rpt > 0){
    		//alert($.isNumeric(rpt));
    		$("#part_total").val(rpt);
    	} else {
    		$("#part_total").val("");
    	}
    });
});

$(function(){
    $("#part_unit_price").change(function(){
    	rpt = ($("#part_in_qty").val() * $("#part_unit_price").val()).toFixed(2);
    	//alert(rpt);
    	if ($.isNumeric(rpt) && rpt > 0){
    	    //alert(rpt+"..");
    		$("#part_total").val(rpt);
    	} else {
    		//alert(rpt+"...");
    		$("#part_total").val("");
    	}  	
    });
});
//for total with stock qty on edit form
$(function(){
    $("#part_stock_qty").change(function(){
    	rpt = ($("#part_stock_qty").val() * $("#part_unit_price").val()).toFixed(2);
    	//alert(rpt);
    	if ($.isNumeric(rpt) && rpt > 0){
    		//alert($.isNumeric(rpt));
    		$("#part_total_edit").val(rpt);
    	} else {
    		$("#part_total_edit").val("");
    	}
    });
});
$(function(){
    $("#part_unit_price").change(function(){
    	rpt = ($("#part_stock_qty").val() * $("#part_unit_price").val()).toFixed(2);
    	if ($.isNumeric(rpt) && rpt > 0){
    	    //alert(rpt);
    		$("#part_total_edit").val(rpt);
    	} else {
    		//alert(rpt);
    		$("#part_total_edit").val("");
    	}  	
    });
});
