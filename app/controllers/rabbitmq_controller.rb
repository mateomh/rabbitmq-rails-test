class RabbitmqController < ApplicationController
  def publish_fanout
    # * * Will publish messages to all queues bound to the exchange 
    connection = Bunny.new(
      host: 'rabbitmq',
      vhost: '/',
      user: 'guest',
      pass: 'guest'
    )
    connection.start

    channel - connection.create_channel
    exchange = channel.fanout('my_fanout', { durable: true })
    message = {
      message: 'Message from publish_fanout'
    }
    exchange.publish(message.to_s)
    connection.close
    render json: {published: 'FANOUT_OK'}
  rescue StandardError => e
    render json: { error: e }
  end
  
  def publish_direct
    # * * Will publish messages to a queue based on the routing key 
    connection = Bunny.new(
      host: 'rabbitmq',
      vhost: '/',
      user: 'guest',
      pass: 'guest'
    )
    connection.start

    channel - connection.create_channel
    exchange = channel.direct('my_direct', { durable: true })
    message = {
      message: 'Message from publish_direct'
    }
    exchange.publish(message.to_s, {routing_key: 'Test_key'})
    connection.close
    render json: {published: 'DIRECT_OK'}
  rescue StandardError => e
    render json: { error: e }
  end

  def publish_topic
    # * * Will publish messages to a queue based on the routing key pattern
    # * * # => 0 or more words
    # * * * => 1 or more words
    connection = Bunny.new(
      host: 'rabbitmq',
      vhost: '/',
      user: 'guest',
      pass: 'guest'
    )
    connection.start

    channel - connection.create_channel
    exchange = channel.topic('my_topic', { durable: true })

    # * * Binding patterns for routing key fo he queues
    # * * Test-Queue-1 => #.topic
    # * * Test-Queue-1 => #.topic.*
    # * * Test-Queue-2 => *.*.topic
    # * * Test-Queue-2 => *.topic

    # * * Test-Queue-1 should get 4 messages
    # * * Test-Queue-2 should get 2 messages

    exchange.publish('Message from publish_topic 1', {routing_key: 'test1.topic.specific'})
    exchange.publish('Message from publish_topic 2', {routing_key: 'test1.topic.specific'})
    exchange.publish('Message from publish_topic 3', {routing_key: 'test1.topic'})
    exchange.publish('Message should not route', {routing_key: 'test1.'})
    exchange.publish('Message should route', {routing_key: 'topic'})
    connection.close

    render json: { published: 'TOPIC_OK' }
  rescue StandardError => e
    render json: { error: e }
  end

  def publish_headers
    # * * Will publish messages to a queue based on the headers igonorign the routing key
    connection = Bunny.new(
      host: 'rabbitmq',
      vhost: '/',
      user: 'guest',
      pass: 'guest'
    )
    connection.start

    channel - connection.create_channel
    exchange = channel.headers('my_headers', { durable: true })

    # * * Bindings for headers for the queues
    # * * Test-Queue-1 =>
    # * *   x-match: all
    # * *   queue: test
    # * *   number: 1
    # * * Test-Queue-2 =>
    # * *   x-match: any
    # * *   location: test2
    # * *   queue: test2

    # * * Test-Queue-1 should get 1 message
    # * * Test-Queue-2 should get 3 messages

    exchange.publish(
      'Message from publish_headers 1', 
      { 
        routing_key: 'test1.topic.specific',
        headers: {
          number: '1',
          queue: 'test'
        } 
    })
    exchange.publish(
      'Message from publish_headers 2', 
      { 
        routing_key: 'test1.topic.specific',
        headers: {
          location: 'test2'
        } 
    })
    exchange.publish(
      'Message from publish_headers 3', 
      { 
        routing_key: 'test1.topic.specific',
        headers: {
          location: 'test2'
          queue: 'test2'
        } 
    })
    exchange.publish(
      'Message should not route', 
      { 
        routing_key: 'test1.topic.specific',
        headers: {
          queue: 'test'
        } 
    })
    exchange.publish(
      'Message should route', 
      { 
        routing_key: 'test1.topic.specific',
        headers: {
          queue: 'test2'
        } 
    })
    connection.close

    render json: { published: 'HEADERS_OK' }
  rescue StandardError => e
    render json: { error: e }
  end
end
