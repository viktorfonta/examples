jQuery ->
  $('#user_role').change ->
    $('#user_admin_accesses_input').toggle($(@).val() == 'admin')
  $('#user_role').trigger('change')