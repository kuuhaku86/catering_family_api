function getCategories() {
  let url = '/api/categories';
  let category = {};

  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      let tbody = $("#table-body");
      let counter = 1;
      tbody.empty();

      data.forEach(category => {
        tbody.append(
          `<tr>
            <th scope="row">${counter}</th>
            <td>${category.name}</td>
            <td>
              <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#edit-modal" data-id="${category.id}" data-name="${category.name}">
                Edit
              </button>
              <button type="button" class="btn btn-danger delete" onclick="deleteCategory(${category.id});">
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

getCategories();

$('#create-modal').on('show.bs.modal', function (event) {
  let button = $(event.relatedTarget);
  let modal = $(this);
});

$('#create-modal').on('click', '.btn-primary', function() {
  let url = '/api/categories/';
  let name = $('#create-modal input').val();
  let payload = {
    category: {
      name: name
    }
  };

  $.ajax({
    url: url,
    type: 'POST',
    dataType: 'json',
    data: payload,
    success: function(data) {
      $('#create-modal').modal('hide');
      alert("Category created");
      $('#create-modal input').val("");
      getCategories();
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
});

$('#edit-modal').on('show.bs.modal', function (event) {
  let button = $(event.relatedTarget);
  let id = button.data('id');
  let name = button.data('name');

  category = {
    id: id,
    name: name
  };

  let modal = $(this);
  modal.find('.modal-title').text('Edit ' + name)
  modal.find('.modal-body input').val(name)
});

$('#edit-modal').on('click', '.btn-primary', function() {
  let url = '/api/categories/' + category.id;
  let name = $('#edit-modal input').val();

  category.name = name;

  $.ajax({
    url: url,
    type: 'PUT',
    dataType: 'json',
    data: category,
    success: function(data) {
      $('#edit-modal').modal('hide');
      alert(data.message);
      getCategories();
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
});

function deleteCategory(id) {
  let url = '/api/categories/' + id;

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