class DbUpdateListenerJob
  include Sidekiq::Worker

  def perform(args)
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      # connection is the ActiveRecord::ConnectionAdapters::PostgreSQLAdapter object
      conn = connection.instance_variable_get(:@connection)
      # conn is the underlying PG::Connection object, and exposes #wait_for_notify

      begin
        conn.async_exec "LISTEN item_mrp_updation"
        
        loop do 
          connection.raw_connection.wait_for_notify do |channel, pid, payload|
            invoice_id = JSON.parse(payload)["invoice_id"] rescue nil
            puts invoice_id  
            InvoiceUpdateOnItemUpdationJob.perform_async(invoice_id) if invoice_id.present?
            #trigger async job
          end
        end

      ensure
        # Don't want the connection to still be listening once we return
        # it to the pool - could result in weird behavior for the next
        # thread to check it out.
        conn.async_exec "UNLISTEN *"
      end
    end

  end
end