
CREATE FUNCTION calculate_total_price_for_orders_group(@id INT)
	RETURNS INT
	BEGIN
		DECLARE @result INT
		IF ((SELECT customer_id FROM Orders WHERE row_id = @id) IS NOT NULL)
			BEGIN
				SELECT @result = SUM(price) FROM OrderItems WHERE OrderItems.order_id = @id
			END;
		ELSE		
			BEGIN
				DECLARE some_cursor CURSOR FOR SELECT row_id FROM Orders WHERE parent_id = @id
				OPEN some_cursor
					DECLARE  @counter INT, @temp_id INT
					SET @counter = 0
					FETCH NEXT FROM some_cursor INTO @temp_id
					while @@FETCH_STATUS = 0
						BEGIN
							SELECT @counter += dbo.calculate_total_price_for_orders_group(@temp_id)
							FETCH NEXT FROM some_cursor INTO @temp_id
						END;
					SET @result = @counter
				CLOSE some_cursor
				DEALLOCATE some_cursor
			END;
		RETURN @result
	END
	

