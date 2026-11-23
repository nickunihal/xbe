# Rails Database Change Listener using PostgreSQL Triggers & Sidekiq

## Overview

This project demonstrates how to execute server-side application logic whenever specific database records are updated, regardless of whether the changes originate from the Rails application or are made directly in the database.

The application uses **PostgreSQL Triggers, LISTEN/NOTIFY, and Sidekiq** to detect database changes and process them asynchronously.

The primary objective is to build a reusable approach for reacting to database-level changes without relying on ActiveRecord callbacks.

## Problem Statement

ActiveRecord callbacks are useful for handling model lifecycle events within a Rails application. However, they do not capture changes made directly to the database through external queries, scripts, or other applications.

This project explores an alternative approach where PostgreSQL itself detects changes and notifies the Rails application, ensuring that the required business logic executes regardless of how the data is modified.

## Solution Architecture

The implementation uses PostgreSQL's native **Triggers and LISTEN/NOTIFY** functionality.

The workflow is as follows:

1. A PostgreSQL trigger is configured on the `invoice_items` table to listen for UPDATE operations.
2. When an invoice item's attributes are updated, the trigger executes a PostgreSQL function.
3. The function uses `pg_notify` to publish the updated row attributes as a JSON payload to the `item_mrp_updation` channel.
4. A background listener (`DbUpdateListenerJob`) maintains a database connection and listens to this notification channel.
5. When a notification is received, the listener schedules an `InvoiceUpdateOnItemUpdationJob` through Sidekiq.
6. The background job recalculates the invoice batch amount based on the updated invoice details.

This ensures that database changes are detected even when they bypass the Rails application.

## Tech Stack

- **Ruby on Rails 6** – Application framework
- **PostgreSQL** – Database, triggers, and LISTEN/NOTIFY
- **Sidekiq** – Asynchronous background job processing
- **Redis** – Sidekiq backend
- **RSpec** – Automated testing

## Application Domain

The application models a simple invoicing system with the following entities:

| Model | Description |
|---|---|
| Item | Stores item details such as name, category, and MRP |
| Invoice | Stores customer and invoice details |
| InvoiceItem | Join model connecting invoices and items, including rate and quantity |
| InvoiceBatch | Groups invoices and maintains the total invoice amount |

### Model Relationships

- An `Invoice` has many `Items` through `InvoiceItems`.
- An `InvoiceBatch` has many `Invoices`.
- Each `InvoiceItem` stores the rate and quantity used for invoice calculations.

## Key Components

### 1. PostgreSQL Trigger and Function

The database trigger and function are created through a Rails migration:

`20230121194904_add_invoice_item_trigger.rb`

- A trigger is attached to the `invoice_items` table.
- It executes on UPDATE operations.
- The associated PostgreSQL function publishes the updated row attributes using `pg_notify`.
- Notifications are published to the `item_mrp_updation` channel.

### 2. DbUpdateListenerJob

This job acts as a database notification listener.

- Automatically started during application initialization through `perform_async` in `config/initializers/sidekiq.rb`.
- Opens a PostgreSQL database connection.
- Listens continuously to the `item_mrp_updation` notification channel.
- Uses PostgreSQL's `wait_for_notify` functionality to receive notifications.
- Schedules `InvoiceUpdateOnItemUpdationJob` asynchronously when a notification arrives.

### 3. InvoiceUpdateOnItemUpdationJob

This job handles the business logic triggered by database changes.

- Receives the affected `invoice_id`.
- Recalculates the corresponding invoice amount.
- Updates the associated invoice batch's `total_invoice_amount` based on the sum of its invoices.

### 4. RSpec Tests

The project includes tests under:

`spec/db_trigger/db_trigger_spec.rb`

The test suite covers:

- **Invoice batch amount calculation:** Verifies that the batch amount equals the sum of its invoices' bill amounts.
- **Database-level change detection:** Verifies that updating an invoice item's rate triggers the PostgreSQL notification mechanism.
- **Invoice batch recalculation:** Ensures that the batch total is recalculated correctly after an invoice item update.

## Key Concepts Demonstrated

- PostgreSQL Triggers and Stored Functions
- PostgreSQL LISTEN/NOTIFY
- Database-level event handling
- Asynchronous processing with Sidekiq
- Background database notification listeners
- Decoupling database change detection from Rails callbacks
- RSpec testing of database-driven workflows

## Reference

- [RailsConf 2022 – Call Me Back, Postgres! by Ifat Ribon](https://www.youtube.com/watch?v=nWe8JtZx3HM)

---

*This repository is a learning project exploring PostgreSQL-driven event notifications and asynchronous processing in Ruby on Rails.*
