# `a` is a test-app for Qpard

## Summary

It has service that uses RabbitMQ and Bunny gem for sending messages to app `b` and receiving responses from it, creating items with responses as attributes.

You can establish the connection to RabbitMQ in a-app by sending a post request

```
require 'rest-client'

r = RestClient.post('http://localhost:3000/create', {name: "Alabama"})
```
