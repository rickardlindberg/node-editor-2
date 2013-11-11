import json

import zmq

context = zmq.Context()

socket = context.socket(zmq.REQ)
socket.connect("tcp://localhost:5555")

nodes = []

socket.send(json.dumps({"command":"get_top_level_nodes"}))
nodes = json.loads(socket.recv())

while True:
    x = raw_input("Yes? ")
    print(nodes)
