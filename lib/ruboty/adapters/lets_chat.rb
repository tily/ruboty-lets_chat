require "socket.io-client-simple"

module Ruboty
  module Adapters
    class LetsChat < Base
      include Mem

      env :LCB_URL, "Let's Chat URL (default: http://localhost:5000)"
      env :LCB_TOKEN, "Let's Chat API Token"
      env :LCB_ROOMS, "Let's Chat Room Ids (separated by comma)"

      LCB_URL = ENV['LCB_URL'] || 'localhost:5000'
      LCB_TOKEN = ENV['LCB_TOKEN']
      LCB_ROOMS = ENV['LCB_ROOMS'].split(',')

      def run
        _robot = robot
        _socket = socket

        # patch in to catch socket.io connect event
        websocket = _socket.instance_variable_get('@websocket')
        websocket.on :message do |msg|
          _socket.__emit 'socket.io connect' if (code = msg.data[/^(\d+)/, 1]) && (code.to_i == 40)
        end

        _socket.on 'socket.io connect' do
          _socket.emit 'connected'
          LCB_ROOMS.each do |room|
            _socket.emit 'rooms:join', room
          end
        end

        _socket.on 'messages:new' do |data|
          _robot.receive(
            body: data['text'],
            from: data['owner']['id'],
            from_name: data['owner']['username'],
            room_id: data['room']['id'],
            room_name: data['room']['name'],
          )
        end

        _socket.on 'error' do |data|
          # TODO: handle error
        end

        loop {}
      rescue Interrupt
        exit
      end

      def say(message)
        socket.emit('messages:create', room: message[:original][:room_id], text: message[:body])
      end

      def socket
        @socket ||= SocketIO::Client::Simple.connect(LCB_URL, token: LCB_TOKEN)
      end
    end
  end
end
