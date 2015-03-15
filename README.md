# Shoppe::Notification

A Shoppe Module which emails staff when new orders are received.

It links to the `confirmation` callback and sends an email using a normal
Rails Mailer to all Users (not orders) saying that a new order has been
received. It is sent from the set `outbound_email_address`.

## Installation

Add this line to your application's Gemfile and `bundle install`

```ruby
gem "shoppe-notification"
```