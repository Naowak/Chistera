extends StreamPeerTCP

const MESSAGE_RECEIVED = "msg_received"

var TIMEOUT = 10
var error = ''
var data = ''
var receiver = null
var receiver_f = null
var received_header = false
var dispatcher = Reference.new()

func listen():
	var tm = 0.0
	var size = 0
	var byte = 0
	var fin = 0
	var opcode = 0
	if get_status() == STATUS_CONNECTED:
		if get_available_bytes() > 0:
			# frame
			byte = get_8()
			fin = byte & 0x80
			opcode = byte & 0x0F
			byte = get_8()
			var mskd = byte & 0x80
			var payload = byte & 0x7F
			# Respond to keep-alive ping
			if opcode == 9:
				put_8(0x80 | 0x0A)
				put_8(0x00)
				print('pong')
				return
#			printt('length', get_available_bytes())
#			printt(fin,mskd,opcode,payload)
			if payload < 126:
				# size of data = payload
				data += get_string(payload)
				if fin:
					if receiver: dispatcher.emit_signal(MESSAGE_RECEIVED, data)
					data = ''
			else:
				size = 0
				if payload == 126:
					# 16-bit size
					size = get_u8() * 256 + get_u8()
#					printt(size,'of data')
					while size:
						size -= get_available_bytes()
						data += get_string(get_available_bytes())
#						print(size)
					if receiver: dispatcher.emit_signal(MESSAGE_RECEIVED, data)
					data = ''



func send(msg):
	var utf8msg = msg.to_utf8()
	if utf8msg.size() < 126:
		put_8(0x80 | 0x01) # final frame and text frame flags
		put_u8(utf8msg.size()) # mask flag off and payload size  **max of 125 bytes
		# Convert to int array, stream 1 char at a time
		for i in range(utf8msg.size()):
			put_u8(utf8msg[i])
#		print(msg+" sent")
	elif utf8msg.size() < 8192:
		put_8(0x00 | 0x01) # non-final frame and text frame flags
		put_u8(0x00 | 0x7D) # mask flag off and payload size = 125
		# Convert to int array, stream 1 char at a time
		for i in range(125):
			put_u8(utf8msg[i])
		utf8msg = utf8msg.subarray(125,utf8msg.size()-1)
		while utf8msg.size():
			if utf8msg.size() > 125:
				put_8(0x00 | 0x00) # non-final frame and no opcode flags
				put_u8(0x00 | 0x7D) # mask flag off and payload size = 125
				# Convert to int array, stream 1 char at a time
				for i in range(125):
					put_u8(utf8msg[i])
				utf8msg = utf8msg.subarray(125,utf8msg.size()-1)
			else:
				put_8(0x80 | 0x00) # final frame and no opcode flags
				put_u8(utf8msg.size()) # mask flag off and payload size
				# Convert to int array, stream 1 char at a time
				for i in range(utf8msg.size()):
					put_u8(utf8msg[i])
				utf8msg = []
#		print(msg+" sent")



func connect(host,port):
	# Attempt connection to server
	if OK == connect_to_host(IP.resolve_hostname(host),port):
		# Wait for connection to be established
		var tm = 0.0
		while true:
			if get_status() == STATUS_ERROR:
				error = 'Connection fail'
				return error
			if get_status() == STATUS_CONNECTED:
				break
			tm += 0.01
			if tm > TIMEOUT:
				error = 'Connection timeout'
				return error
			OS.delay_msec(10)
		
		# Prepare header
		var header = "GET / HTTP/1.1\r\n"
		header += "Host: " + host + "\r\n"
		header += "Upgrade: websocket\r\n"
		header += "Connection: Upgrade\r\n"
		header += "Sec-WebSocket-Key: " + str(IP.get_local_addresses()).md5_text() + "\r\n"
		header += "Sec-WebSocket-Version: 13\r\n"
		header += "Sec-WebSocket-Protocol: namethiswhatever\r\n"
		header += "\r\n"
		
		# Send header
		if OK != put_data(header.to_ascii()):
			error = 'Error sending handshake headers'
			return error
	
	else:
		error = 'Connection fail'
		return error
	
	# Wait for header response from server (we really should have this already)
	var tm = 0.0
	while get_available_bytes() == 0:
		tm += 0.01
		OS.delay_msec(10)
		if tm > TIMEOUT:
			error = 'Receive headers timeout'
			return error
	
	# Unless we want to parse the headers from server, do nothing with it
	get_string(get_available_bytes())



func set_receiver(o,f):
	if receiver:
		unset_receiver()
	receiver = o
	receiver_f = f
	dispatcher.connect(MESSAGE_RECEIVED, receiver, receiver_f)

func unset_receiver():
	dispatcher.disconnect(MESSAGE_RECEIVED, receiver, receiver_f)
	receiver = null
	receiver_f = null

func _init(reference):
	dispatcher.add_user_signal(MESSAGE_RECEIVED)
