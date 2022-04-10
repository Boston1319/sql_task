
CREATE FUNCTION select_orders_by_item_name(@name_position VARCHAR(255))
	RETURNS TABLE

	AS RETURN (
		SELECT Orders.row_id as order_id, Customers.name as customer, count(order_id) as items_count
		FROM Customers
		JOIN Orders JOIN OrderItems ON Orders.row_id = OrderItems.order_id ON Customers.row_id = Orders.customer_id
		WHERE OrderItems.name = @name_position
		GROUP BY Orders.row_id, Customers.name
	)
