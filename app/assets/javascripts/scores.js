// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

// Reload scores upon selection
$(document).ready(function() {
  $('#sort_score_id').change(function() {
    var sort = $('#sort_score_id option:selected').val();
    window.location.replace('/scores?sort_by=' + sort);
  });
});
