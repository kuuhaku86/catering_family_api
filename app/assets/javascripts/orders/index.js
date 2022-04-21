let menus = [];
let selected_order = null;

function getMenus() {
  let url = '/api/menus';

  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      menus = data;

      let div_menus = $('#menus');

      div_menus.empty();

      for (let i = 0; i < menus.length; i++) {
        let menu = menus[i];

        let tr_menu = $('<tr></tr>');
        let td_menu_name = $('<td></td>');
        let input_menu = $('<input type="checkbox" class="form-check-input" name="menus[]" value="' + menu.id + '">');
        let label_menu = $('<label class="form-check-label">' + menu.name + '</label>');
        let td_menu_quantity = $('<td></td>');
        let input_quantity_menu = $(`<input type="number" class="form-check-input" name="quantity_menus[]" id="quantity-${menu.id}" value="0" min="0">`);

        td_menu_name.append(input_menu);
        td_menu_name.append(label_menu);
        td_menu_quantity.append(input_quantity_menu);
        tr_menu.append(td_menu_name);
        tr_menu.append(td_menu_quantity);

        div_menus.append(tr_menu);
      }
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
}

function getOrders() {
  let url = '/api/orders';

  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      let tbody = $("#table-body");
      let counter = 1;
      menus = data;

      tbody.empty();
      data.forEach(order => {
        let row = `<tr>
          <th scope="row">${counter}</th>
          <td>${order.customer.email}</td>
          <td>
        `;
        
        order.order_menus.forEach(order_menu => {
          row += `<div class="row">
            - ${order_menu.menu.name} | Jumlah: ${order_menu.quantity} | Total: ${order_menu.total_price}
          </div>`;
        });

        row += `</td>
          <td>${order.created_at}</td>
          <td>${order.total_price}</td>
          <td>${order.status}</td>
          <td>
            <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#edit-modal" data-id="${order.id}">
              Edit
            </button>
          </td>
        </tr>`;

        tbody.append(row);

        counter++;
      });
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
}

getMenus();
getOrders();

$('#create-modal').on('show.bs.modal', function (event) {
  let button = $(event.relatedTarget);
  let modal = $(this);
});

$('#create-modal').on('click', '.btn-primary', function() {
  let url = '/api/orders/';
  let email = $('#create-modal input[name="email"]').val();
  let menu_ids = [];
  let menu_quantities = [];

  $('#create-modal input[name="menus[]"]:checkbox:checked').each(function() {
    let quantity = $("#quantity-" + $(this).val()).val();

    if (quantity > 0) {
      menu_ids.push($(this).val());
      menu_quantities.push(quantity);
    }
  });

  if (menus.length < 1) {
    alert('Please select at least one menu');

    return;
  }

  menus = JSON.stringify(menus);

  let payload = {
    customer: {
      email: email
    },
    menu_ids: menu_ids,
    menu_quantities: menu_quantities
  };

  $.ajax({
    url: url,
    type: 'POST',
    dataType: 'json',
    data: payload,
    success: function(data) {
      $('#create-modal').modal('hide');
      alert("Order created");

      $('input[type="checkbox"]').prop('checked' , false);
      $('#create-modal input[name="email"]').val("");
      $('#create-modal input[name="quantity_menus[]"]').val("");

      getOrders();
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
});

$('#edit-modal').on('show.bs.modal', function (event) {
  let button = $(event.relatedTarget);
  let id = button.data('id');
  selected_order = id;
});

$('#edit-modal').on('click', '.btn-primary', function() {
  let url = '/api/orders/' + selected_order;
  let new_status = $('#edit-modal select').val();

  let payload = {
    status: new_status
  };

  $.ajax({
    url: url,
    type: 'PUT',
    dataType: 'json',
    data: payload,
    success: function(data) {
      $('#edit-modal').modal('hide');
      alert(data.message);
      getOrders();
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
});
