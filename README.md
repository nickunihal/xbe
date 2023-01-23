# README

## Overview
We'd like to ensure that server application code runs any time that certain data in the database changes (even if the change was directly made to the database).<br /><br />
Assignment: Create a sample Rails application that implements a solution to this problem in a way that can be reused across the application.
Use PostgreSQL for the database. Use Sidekiq to run the async server job. Write RSpec tests to exercise the functionality.

## Solution
The functionality is implemented by using Postgresql Triggers, LISTEN and NOTIFY feature. Instead of using ActiveRecord callbacks, database triggers are used so as to capture the changes happening directly in postgres. Trigger is added to invoice_items table for UPDATE action which triggers a pg_notify method to send the changed row attributes as payload to channel "item_mrp_updation".<br /><br />
In our Rails application we have a sidekiq worker which opens a database connection thread and listens to the channel "item_mrp_updation". wait_for_notify functionality of psotgres is used to receive the payload and schedule an async jon to update the invoice batch details of the corresponding invoice batch. 

## Pre requisites
* Rails 6 
* postgresql
* Redis
* Sidekiq
* Other common dependencies for Rails6 app.

# Application 

### Model
* Item(name:string , category:string , mrp:integer) . 
* Invoice(invoice_no:string, full_name:string, phone:string, email:string, total_paid_amount:decimal, discount:decimal, invoice_batch_id:bigint) 
  - has_many items through invoice_items
* InvoiceItem(invoice_id:bigint, item_id: bigint, rate:decimal, quantity:integer)
* InvoiceBatch(batch_date:date, total_invoice_amount:bigint)
  - has many invoices
  
### Migration and Database Triggers
  * Postgres triggers and functions are added using Rails migration.(file- 20230121194904_add_invoice_item_trigger.rb ) 
  * Trigger is added on invoice_items table to check for any changes and executes PROCEDURE item_mrp_update_notifier when any Update happens      on any of the table rows.
  * Function item_mrp_update_notifier calls pg_notifier to send notification to channel item_mrp_updation with updated row attributes. The         data is received by all lsiteners checking for "item_mrp_updation" channel
  
### Sidekiq Jobs
  * DbUpdateListenerJob
    - This job is auto started when application initializes by using perform_async method from initializers/sidekiq.rb .
    - It opens a db connection and listens to channel "item_mrp_updation". We run an infinite loop and checks for channel notification payload       using pg wait_for_notify method. Once notification of new event is received, InvoiceUpdateOnItemUpdationJob is triggered asynchronously       which takes invoice_id as the param and updates the invoice batch of the corresponding invoice with updated sum of invoice amount of the       batched invoices.
    
### Rspec
  * db_trigger/db_trigger_spec.rb
    - Tests the functionality of invoice batch updation
    - Invoice batch amount is sum of invoice bill amounts
      - Checks if total_invoice_amount updated in Invoicebatch entry is the sum of total_bill_amount of the batched invoices.
    - Invoice Batch amount changes on Correspondin invoice item rate updation
      - Tests the LISTEN and NOTIFY feature of postgresql.
    - amount updation logic
      - Checls of the logic for invoice batch total_invoice_updation is sum of the batched invoice total_bill_amount.
      
### References
  * [RailsConf 2022 - Call me back, Postgres by Ifat Ribon](https://www.youtube.com/watch?v=nWe8JtZx3HM)
