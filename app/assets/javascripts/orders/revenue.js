function getInputs() {
  let email = $("#email").val();
  let min_price = $("#min-price").val();
  let max_price = $("#max-price").val();
  let min_date = $("#min-date").val();
  let max_date = $("#max-date").val();

  let query = '';

  if (email) {
    query += 'email=' + email + "&";
  }

  if (min_price) {
    query += 'min_price=' + min_price + "&";
  }

  if (max_price) {
    query += 'max_price=' + max_price + "&";
  }

  if (min_date) {
    query += 'min_date=' + min_date + "&";
  }

  if (max_date) {
    query += 'max_date=' + max_date;
  }

  return query;
}

function getOrders() {
  let url = '/api/orders/revenue?';

  url += getInputs();

  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    success: function(data) {
      let tbody = $("#table-body");
      let counter = 1;

      tbody.empty();
      data.orders.forEach(order => {
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
          <td>${order.status}</td>
          <td>${order.total_price}</td>
        </tr>`;

        tbody.append(row);

        counter++;
      });

      let row = `<tr>
          <th></th>
          <td colspan="4" style="text-align:center;"><b>Total</b></td>
          <td>${data.total_revenue}</td>
        </tr>`;

      tbody.append(row);
    },
    error: function(data) {
      alert(data.responseJSON.message);
    }
  });
}

getOrders();

$("#search").on("click", function(event) {
  getOrders();
});
