import json
import subprocess

import zmq

class Client(object):

    def __init__(self):
        self.nodes = []

    def run(self):
        self._init_zmq()
        self._fetch_nodes_from_server()
        while True:
            self._print_node_list()
            self._get_input()

    def _init_zmq(self):
        context = zmq.Context()
        self.socket = context.socket(zmq.REQ)
        self.socket.connect("tcp://localhost:5555")

    def _fetch_nodes_from_server(self):
        self.socket.send(json.dumps({"command":"get_top_level_nodes"}))
        self.nodes = json.loads(self.socket.recv())

    def _print_node_list(self):
        print("Nodes:")
        for node in self.nodes:
            title = node["body"][:10].replace("\n", "\\n") + "..."
            print("  (%d) %s" % (node["id"], title))

    def _get_input(self):
        id = int(raw_input("Which to edit? "))
        node = self._get_node_with_id(id)
        self._edit(node)

    def _edit(self, node):
        tmp_path = "/tmp/node-editor-tmp-file.txt"
        with open(tmp_path, "w") as f:
            f.write(node["body"])
        subprocess.call(["vim", tmp_path])
        print("Saving...")
        with open(tmp_path, "r") as f:
            node["body"] = f.read()

    def _get_node_with_id(self, id):
        for node in self.nodes:
            if node["id"] == id:
                return node
        return None

if __name__ == "__main__":
    Client().run()
