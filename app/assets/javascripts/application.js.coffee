#= require jquery
#= require jquery.turbolinks
#= require bootstrap-sprockets
#= require jquery_ujs
#= require_tree .

#= require highcharts/highcharts
#= require highcharts/highcharts-more
#= require highcharts/highstock
#= require turbolinks

ready = ->
  
  $('[data-toggle="tooltip"]').tooltip()

  $('.collapse').click( ->  $('.collapseSideMenu').parent().collapse() )

  $('.navbar .dropdown').hover(
    ->  $(this).find('.dropdown-menu').first().stop(true, true).delay(100).slideDown()
    ->  $(this).find('.dropdown-menu').first().stop(true, true).delay(150).slideUp()
  )

$(document).ready(ready)
$(document).on('page:load', ready)
