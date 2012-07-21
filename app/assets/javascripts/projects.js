//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function() {
   $("#project_start_date_search").datepicker({dateFormat: 'yy-mm-dd'});
   $("#project_end_date_search").datepicker({dateFormat: 'yy-mm-dd'});
});