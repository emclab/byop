//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//for calculating total
$(function(){
    $("#installation_purchase_qty").change(function(){
      rpt = ($("#installation_purchase_qty").val() * $("#installation_purchase_unit_price").val()).toFixed(2);
      //alert(rpt);
      if ($.isNumeric(rpt) && rpt > 0){
        //alert($.isNumeric(rpt));
        $("#installation_purchase_total").val(rpt);
      } else {
        $("#installation_purchase_total").val("");
      }
    });
});
$(function(){
    $("#installation_purchase_unit_price").change(function(){
      rpt = ($("#installation_purchase_qty").val() * $("#installation_purchase_unit_price").val()).toFixed(2);
      if ($.isNumeric(rpt) && rpt > 0){
          //alert(rpt);
        $("#installation_purchase_total").val(rpt);
      } else {
        //alert(rpt);
        $("#installation_purchase_total").val("");
      }   
    });
});
