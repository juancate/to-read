root = exports ? this

delete_request = (id) ->
  $('#delete_modal').modal 'toggle'

  $.ajax(type: 'DELETE', url: "/#{id}")
    .done ->
      item = $("a.delete[data-id=#{id}]").closest 'tr'
      do item.remove

prepare_delete = ->
  $('.delete').on 'click', (e) ->
    do e.preventDefault
    id = $(this).data 'id'
    $('#delete_modal').data('id', id).modal 'show'

$(document).ready ->
  $('#delete_modal').on 'show.bs.modal', (e) ->
    id = $(this).data 'id'
    delete_btn = $(this).find '.btn-danger'
    delete_btn.attr 'href', "javascript:delete_request(#{id})"

  do prepare_delete

root.delete_request = delete_request
root.prepare_delete = prepare_delete
