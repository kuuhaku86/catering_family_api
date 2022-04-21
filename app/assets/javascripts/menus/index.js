function getMenus(category_id=null) {
  let url = '/api/menus';

  if (category_id) {
    url += '?category_id=' + category_id;
  }

  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      let tbody = $("#table-body");
      let counter = 1;
      tbody.empty();

      data.forEach(menu => {
        tbody.append(
          `<tr>
            <th scope="row">${counter}</th>
            <td>${menu.name}</td>
            <td>${menu.description}</td>
            <td>${menu.price}</td>
          </tr>`
        );

        counter++;
      });
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
}

function getCategories() {
  let url = '/api/categories';

  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      let select = $("#category-select");

      data.forEach(category => {
        select.append("<option value='" + category.id + "'>" + category.name + "</option>");
      });
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
}

getCategories();
getMenus();

$("#category-select").change(function() {
  let category_id = $(this).val();
  getMenus(category_id);
});