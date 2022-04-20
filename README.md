# Gigih Catering Family - Yohan Ardiansyah (KM_G2BE2114)

A project with Ruby on Rails framework and using REST API for its data communication. For the project detail itself, the project focused to solve Gigih Catering Family business problem to monitor their business. This project originally used for finishing final project from Generasi Gigih Yayasan Anak Bangsa Bisa. 

## Visuals

### Database Design

![img](app/assets/images/db.jpg)

### REST API

![api](app/assets/images/api.png)

### UI API consumer

![ui-consumer](app/assets/images/ui-consumer.png)

## Installation

### Requirement

- Ruby 3.0.3
- Gem
- Bundler

### Installation Process

- Go to the Project's directory
- Run command `bundle install` to install the dependencies
- Run command `rails db:migrate` to setup the database
- Run command `bundle exec whenever --update-crontab --set environment=development` to setup the task scheduler
- Run command `rails server` to start the server

## Usage

### JSON Object
For the API, we will use some Object that can be a JSON response for the REST API.

| Name | JSON Object |
|------|-------------|
|**Category Object** | <code>{<br/>&ensp;id(integer),<br/>&ensp;name(string),<br/>&ensp;created_at(string),<br/>&ensp;updated_at(string),<br/>&ensp;soft_deleted(boolean)<br/>}</code><br/><br/>Example:<br/><code>{<br/>&ensp;id: 1,<br/>&ensp;name:"Beverages",<br/>&ensp;created_at:"2022-04-19T02:52:49.072Z",<br/>&ensp;updated_at:"2022-04-19T02:52:49.072Z",<br/>&ensp;soft_deleted:false<br/>}</code>|
|**Menu Object**     | <code>{<br/>&ensp;id(integer),<br/>&ensp;name(string),<br/>&ensp;price(float),<br/>&ensp;description(string),<br/>&ensp;created_at(string),<br/>&ensp;updated_at(string),<br/>&ensp;soft_deleted(boolean)<br/>}</code><br/><br/>Example:<br/><code>{<br/>&ensp;id: 1,<br/>&ensp;name:"Nasi Uduk",<br/>&ensp;price:1200.5,<br/>&ensp;description:"Nasi yang sangat enak",<br/>&ensp;created_at:"2022-04-19T02:52:49.072Z",<br/>&ensp;updated_at:"2022-04-19T02:52:49.072Z",<br/>&ensp;soft_deleted:false<br/>}</code>|
|**Customer Object**     | <code>{<br/>&ensp;id(integer),<br/>&ensp;name(string),<br/>&ensp;email(string),<br/>&ensp;created_at(string),<br/>&ensp;updated_at(string)<br/>}</code><br/><br/>Example:<br/><code>{<br/>&ensp;id: 1,<br/>&ensp;name:"Bob",<br/>&ensp;email:"bob@mail.com",<br/>&ensp;created_at:"2023-04-19T02:52:49.072Z",<br/>&ensp;updated_at:"2022-04-19T02:52:49.072Z"<br/>}</code>|
|**Order Object**     | <code>{<br/>&ensp;id(integer),<br/>&ensp;total_price(float),<br/>&ensp;status(string),<br/>&ensp;created_at(string),<br/>&ensp;updated_at(string),<br/>&ensp;order_menus(array of OrderMenu Object),<br/>&ensp;customer(Customer Object)<br/>}</code><br/><br/>Example:<br/><code>{<br/>&ensp;id: 1,<br/>&ensp;total_price:35000.75,<br/>&ensp;status:"NEW",<br/>&ensp;created_at:"2023-04-19T02:52:49.072Z",<br/>&ensp;updated_at:"2022-04-19T02:52:49.072Z",<br/>&ensp;order_menus:[OrderMenu Object],<br/>&ensp;customer:Customer Object<br/>}</code>|
|**OrderMenu Object**     | <code>{<br/>&ensp;id(integer),<br/>&ensp;quantity(integer),<br/>&ensp;total_price(float),<br/>&ensp;created_at(string),<br/>&ensp;updated_at(string),<br/>&ensp;menu(Menu Object),<br/>&ensp;order(Order Object)<br/>}</code><br/><br/>Example:<br/><code>{<br/>&ensp;id: 1,<br/>&ensp;quantity:5,<br/>&ensp;total_price:2000.75,<br/>&ensp;created_at:"2023-04-19T02:52:49.072Z",<br/>&ensp;updated_at:"2022-04-19T02:52:49.072Z",<br/>&ensp;menus:Menu Object,<br/>&ensp;order:Order Object<br/>}</code>|


### User Story & API Contract

|#| Usage | Detail |
|-|-|---|
|Extra from Myself (Responses)   |Response from API| If I'm not specify the response in the next API contract, then the response will almost the same as this.<br/><br/>Response:<br/><code>{<br/>&ensp;message(string)<br/>}</code><br/>Example:<br/><code>{<br/>&ensp;message: "Category updated"<br/>}</code><br/><br/>The error response's format will be the same too, although the status code of the response will be different|
|Extra from Myself (Categories)  |Create, Read, Edit, and Delete Categories|Because the menu item needs category, I will tell the categories usage first.<br/><br/>**`POST /api/categories` &ensp;: Create a category**<br/>Payload:<br/><code>{<br/>&ensp;category:<br/>&ensp;{<br/>&ensp;&ensp;name(string)<br/>&ensp;}<br/>}</code><br/>Example:<br/><code>{<br/>&ensp;category:<br/>&ensp;{<br/>&ensp;&ensp;name: "Beverages"<br/>&ensp;}<br/>}</code><br/><br/>Response:<br/>`Category Object`<br/><br/>**`PUT /api/categories`&ensp;: Edit a category**<br/>Payload:<code><br/>{<br/>&ensp;name(string)<br/>}</code><br/>Example:<br/><code>{<br/>&ensp;name: "Beverages"<br/>}</code><br/><br/>**`GET /api/categories`&ensp;: Get array of categories**<br/>Response:<br/>`Array of Category Object`<br/><br/>**`DELETE /api/categories/:category_id`&ensp;: Soft delete a category**<br/><br/>You can consume these APIs with UI at URI `/categories` from the browser|
|1  |As an owner, <br/>I want to create a new menu item,<br/>So that I can show them to my customers later.| **`POST /api/menus` &ensp;: Create a menu**<br/>Payload:<br/><code>{<br/>&ensp;menu:<br/>&ensp;{<br/>&ensp;&ensp;name(string),<br/>&ensp;&ensp;description(string),<br/>&ensp;&ensp;price(float),<br/>&ensp;&ensp;categories(Array of Category Id),<br/>&ensp;}<br/>}</code><br/>Example:<br/><code>{<br/>&ensp;menu:<br/>&ensp;{<br/>&ensp;&ensp;name: "Nasi Uduk",<br/>&ensp;&ensp;description: "Nasi yang mantab",<br/>&ensp;&ensp;price: 10000.5,<br/>&ensp;&ensp;categories: [1, 2],<br/>&ensp;}<br/>}</code><br/><br/>Response:<br/>`Menu Object`<br/><br/>You can consume this API with UI at URI `/menus/owner` from the browser|
|2  |As an owner,<br />I want to update an existing menu item<br /> So that I can modify info related to the menu item | **`PUT /api/menus` &ensp;: Edit a menu**<br/>Payload:<br/><code>{<br/>&ensp;name(string),<br/>&ensp;description(string),<br/>&ensp;price(float),<br/>&ensp;categories(Array of Category Id),<br/>}</code><br/>Example:<br/><code>{<br/>&ensp;name: "Nasi Kucing",<br/>&ensp;description: "Nasi seukuran kucing",<br/>&ensp;price: 10000.5,<br/>&ensp;categories: [2, 4],<br/>}</code><br/><br/>You can consume this API with UI at URI `/menus/owner` from the browser|
|3  |  As an owner,<br /> I want to show the list of all menu items<br /> So that my customers can see the list of all menu items that I sell |**`GET /api/menus`&ensp;: Get array of menus for Customer**<br/>Response:<br/>`Array of Menu Object`<br/><br/>Query that can be used:<br/>- `category_id(int)`: To get the menu according to its category<br/><br/>You can consume this API with UI at URI `/menus` from the browser|
|4  |As an owner,<br /> I want to delete an existing menu item<br /> So that I can remove a menu item that is no longer provided by my catering service|**`DELETE /api/menus/:menu_id`&ensp;: Soft delete a menu**<br/><br/>You can consume this API with UI at URI `/menus/owner` from the browser|
|5  |As an owner, <br/>I want to add customer’s order<br/> So that I can prepare their order|**`POST /api/orders` &ensp;: Create a order**<br/>Payload:<br/><code>{<br/>&ensp;customer:<br/>&ensp;{<br/>&ensp;&ensp;name(string),<br/>&ensp;&ensp;email(string)<br/>&ensp;},<br/>&ensp;menu_ids(Array of Menu Id),<br/>&ensp;menu_quantities(Array of Quantity for each menu (Ordered by the menu Id)),<br/>}</code><br/>Example:<br/><code>{<br/>&ensp;customer:<br/>&ensp;{<br/>&ensp;&ensp;name: "Bob",<br/>&ensp;&ensp;email: "bob@gmail.com"<br/>&ensp;},<br/>&ensp;menu_ids: [1, 2],<br/>&ensp;menu_quantities: [2, 3],<br/>}</code><br/><br/>You can consume this API with UI at URI `/orders` from the browser|
|6  |As an owner,<br /> I want to update a customer’s order<br /> So that I can modify info related to the order<br />|**`PUT /api/orders/:order_id` &ensp;: Edit a order**<br/>Payload:<br/><code>{<br/>&ensp;status(string between("NEW", "PAID", "CANCELED"))<br/>}</code><br/>Example:<br/><code>{<br/>&ensp;status: "NEW"<br/>}</code><br/><br/>You can consume this API with UI at URI `/orders` from the browser<br/><br/>For the status update automation from "NEW" INTO "CANCELED" at 5 P.M should be already run with command `bundle exec whenever --update-crontab --set environment=development`|
|7  | As an owner,<br /> I want to see a daily report of orders,<br /> So that I can see the revenue that I have generated for that day|**`GET /api/orders/revenue`&ensp;: Get array of orders that get revenue**<br/>Response:<br/>`Array of Order Object`<br/><br/>Query that can be used:<br/>- `email(string)`: Email of the customer<br/>- `max_price(float)`: Maximum total price of an order<br/>- `min_price(float)`: Minimum total price of an order<br/>- `max_date(date with format yyyy-mm-dd)`: Maximum range of date<br/>- `min_date(date with format yyyy-mm-dd)`: Minimum range of date<br/><br/>You can consume this API with UI at URI `/orders/revenue` from the browser|
|Extra from Myself (GET all order)  | Get all order at the system|**`GET /api/orders`&ensp;: Get array of orders**<br/>Response:<br/>`Array of Order Object`<br/><br/>You can consume this API with UI at URI `/orders` from the browser|

## Rails on Replit

This is a template to get you started with Rails on Replit. It's ready to go so you can just hit run and start coding!

This template was generated using `rails new` (after you install the `rails` gem from the packager sidebar) so you can always do that if you prefer to set it up from scratch. The only had two make config changes we had to make to run it on Replit:

- bind the app on `0.0.0.0` instead of `localhost` (see `.replit`)
- allow `*.repl.co` hosts (see `config/environments/development.rb`)
- allow the app to be iframed on `replit.com` (see `config/application.rb`)

### Running the app

Simple hit run! You can edit the run command from the `.replit` file.

### Running commands

Start every command with `bundle exec` so that it runs in the context of the installed gems environment. The console pane will give you output from the server but you can run arbitrary command from the shell without stopping the server.

### Database

SQLite would work in development but we don't recommend running it in production. Instead look into using the built-in [Replit database](http://docs.replit.com/misc/database). Otherwise you are welcome to connect databases from your favorite provider. 

### Help

If you need help you might be able to find an answer on our [docs](https://docs.replit.com) page. Alternatively you can [ask in the community](https://replit.com/talk/ask). Feel free to report bugs [here](https://replit.com/bugs) and give us feedback [here](https://Replit/feedback).