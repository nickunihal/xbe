class AddInvoiceItemTrigger < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION item_mrp_update_notifier()
          RETURNS trigger AS 
      $$
      BEGIN
        IF ( TG_OP = 'UPDATE') THEN
          PERFORM pg_notify('item_mrp_updation',row_to_json(NEW)::text);
        END IF;

        RETURN NEW;
      END
      $$
      LANGUAGE 'plpgsql';

      CREATE TRIGGER item_mrp_update_trigger
      BEFORE UPDATE
      ON invoice_items
      FOR EACH ROW
      EXECUTE PROCEDURE item_mrp_update_notifier();
    SQL
  end
end
