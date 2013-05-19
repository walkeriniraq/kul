$ ->
  $('#ajax_submit').click =>
    $('#echo_response').load('echo', { input: $('#ajax_input').val() })