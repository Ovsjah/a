class RabbitService
  class << self
    def call(name, queue)
      setup_reply_queue
      xchange.publish(name, routing_key: queue,
                      correlation_id: call_id,
                      reply_to: reply_queue.name)
      @lock.synchronize { @condition.wait(@lock) }
      @response
    end

    private

      def call_id
        @call_id ||= SecureRandom.urlsafe_base64
      end

      def xchange
        @xchange ||= channel.default_exchange
      end

      def channel
        @channel ||= connection.create_channel
      end

      def connection
        @connection ||= Bunny.new.tap(&:start)
      end

      def reply_queue
        @reply_queue ||= channel.queue('', exclusive: true)
      end

      def setup_reply_queue
        @lock = Mutex.new
        @condition = ConditionVariable.new

        reply_queue.subscribe do |_delivery_info, properties, item_cost|
          if properties[:correlation_id] == call_id
            @response = item_cost
            @lock.synchronize { @condition.signal }
          end
        end
      end
  end
end
