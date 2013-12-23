root = exports ? this

root.deleteRequest = (id) ->
  $('#delete_modal').modal 'toggle'

  $.ajax(type: 'DELETE', url: "/#{id}")
    .done ->
      item = $("a.delete[data-id=#{id}]").closest 'tr'
      do item.remove

$(document).ready ->
  $('#delete_modal').on 'show.bs.modal', (e) ->
    id = $(this).data 'id'
    deleteBtn = $(this).find '.btn-danger'
    deleteBtn.attr 'href', "javascript:deleteRequest(#{id})"

  $('.delete').on 'click', (e) ->
    do e.preventDefault
    id = $(this).data 'id'
    $('#delete_modal').data('id', id).modal 'show'
