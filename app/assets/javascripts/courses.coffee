$(document).ready ->
  
  selectDropdown = $('#players-select')
  submitButton = $('#players-submit')

  $('#players-select')?.on 'change', (e) ->
    if selectDropdown.val()
      submitButton.removeAttr('disabled')
    else
      submitButton.attr('disabled', true)
