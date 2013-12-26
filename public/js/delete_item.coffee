root = exports ? this

deleteRequest = (id) ->
  $('#delete_modal').modal 'toggle'

  $.ajax(type: 'DELETE', url: "/#{id}")
    .done ->
      item = $("a.delete[data-id=#{id}]").closest 'tr'
      do item.remove

prepareDelete = ->
  $('.delete').on 'click', (e) ->
    do e.preventDefault
    id = $(this).data 'id'
    $('#delete_modal').data('id', id).modal 'show'

$(document).ready ->
  $('#delete_modal').on 'show.bs.modal', (e) ->
    id = $(this).data 'id'
    deleteBtn = $(this).find '.btn-danger'
    deleteBtn.attr 'href', "javascript:deleteRequest(#{id})"

  do prepareDelete

root.deleteRequest = deleteRequest
root.prepareDelete = prepareDelete
