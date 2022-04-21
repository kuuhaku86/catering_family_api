let categories = [];
let menus = [];
let selected_menu = null;

function getMenus() {
  let url = '/api/menus';

  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      let tbody = $("#table-body");
      let counter = 1;
      menus = data;

      tbody.empty();
      data.forEach(menu => {
        tbody.append(
          `<tr>
            <th scope="row">${counter}</th>
            <td>${menu.name}</td>
            <td>${menu.description}</td>
            <td>${menu.price}</td>
            <td>
              <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#edit-modal" data-id="${menu.id}">
                Edit
              </button>
              <button type="button" class="btn btn-danger delete" onclick="deleteMenu(${menu.id});">
                Delete
              </button>
            </td>
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
      categories = data;
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
}

getMenus();
getCategories();

$('#create-modal').on('show.bs.modal', function (event) {
  let button = $(event.relatedTarget);
  let modal = $(this);

  modal.find('#categories').empty();

  categories.forEach(category => {
    modal.find('#categories').append(
      `<div class="form-check">
        <input class="form-check-input" type="checkbox" name="category" value="${category.id}" id="category-${category.id}">
        <label class="form-check-label" for="category-${category.id}">
          ${category.name}
        </label>
      </div>`
    );
  });
});

$('#create-modal').on('click', '.btn-primary', function() {
  let url = '/api/menus/';
  let name = $('#create-modal input[name="name"]').val();
  let description = $('#create-modal textarea').val();
  let price = $('#create-modal input[name="price"]').val();
  let categories = [];

  $('#create-modal input[name="category"]:checkbox:checked').each(function() {
    categories.push($(this).val());
  });

  let payload = {
    menu: {
      name: name,
      description: description,
      price: price,
      categories: categories
    }
  };

  $.ajax({
    url: url,
    type: 'POST',
    dataType: 'json',
    data: payload,
    success: function(data) {
      $('#create-modal').modal('hide');
      alert("Menu created");

      $('input:checkbox').removeAttr('checked');
      $('#create-modal input[name="name"]').val("");
      $('#create-modal textarea').val("");
      $('#create-modal input[name="price"]').val("");

      getMenus();
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
});

$('#edit-modal').on('show.bs.modal', function (event) {
  let button = $(event.relatedTarget);
  let id = button.data('id');

  selected_menu = menus.filter(menu => menu.id == id)[0];

  let modal = $(this);
  modal.find('.modal-title').text('Edit ' + selected_menu.name);
  modal.find('.modal-body input[name="name"]').val(selected_menu.name);
  modal.find('.modal-body textarea').val(selected_menu.description);
  modal.find('.modal-body input[name="price"]').val(selected_menu.price);
  modal.find('#categories').empty();

  categories.forEach(category => {
    let checked = selected_menu.categories.filter(c => c.id == category.id).length > 0;

    if (checked) {
      checked = 'checked';
    } else {
      checked = '';
    }

    modal.find('#categories').append(
      `<div class="form-check">
        <input class="form-check-input" type="checkbox" name="category" value="${category.id}" id="category-${category.id}" ${checked}>
        <label class="form-check-label" for="category-${category.id}">
          ${category.name}
        </label>
      </div>`
    );
  });
});

$('#edit-modal').on('click', '.btn-primary', function() {
  let url = '/api/menus/' + selected_menu.id;
  let name = $('#edit-modal input[name="name"]').val();
  let description = $('#edit-modal textarea').val();
  let price = parseFloat($('#edit-modal input[name="price"]').val());
  let categories = [];

  $('#edit-modal input[name="category"]:checkbox:checked').each(function() {
    categories.push(parseInt($(this).val()));
  });

  let payload = {
    name: name,
    description: description,
    price: price,
    categories: categories
  };

  $.ajax({
    url: url,
    type: 'PUT',
    dataType: 'json',
    data: payload,
    success: function(data) {
      $('#edit-modal').modal('hide');
      alert(data.message);
      getMenus();
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
});

function deleteMenu(id) {
  let url = '/api/menus/' + id;

  if (confirm("Are you sure?") == true) {
    $.ajax({
      url: url,
      type: 'DELETE',
      dataType: 'json',
      success: function(data) {
        getCategories();
        alert(data.message);
      },
      error: function(data) {
        alert(data.responseJSON.message);
      }
    });
  }
}