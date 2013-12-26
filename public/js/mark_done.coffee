root = exports ? this

mark_done = (id) ->
  $.ajax(type: 'PUT', url: "#{id}/done")
    .done ->
      element = $("a.delete[data-id=#{id}]")
      delete_button = element.clone().wrap('<p>').parent()
      item = element.closest('tr').children 'td'
      table = $('#done_table')
      table.append "<tr><td>#{item.html()}</td>
                    <td>#{delete_button.html()}</td></tr>"

      do element.closest('tr').remove
      do prepareDelete

root.mark_done = mark_done

