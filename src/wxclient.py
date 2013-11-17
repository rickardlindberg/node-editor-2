import json
import subprocess

import wx
import zmq

class Server(object):

  def connect(self):
    context = zmq.Context()
    self.socket = context.socket(zmq.REQ)
    self.socket.connect("tcp://localhost:5555")

  def get_nodes(self):
    self.socket.send(json.dumps({"command":"get_top_level_nodes"}))
    return json.loads(self.socket.recv())

  def edit_body(self, node_id, body):
    self.socket.send(json.dumps({
        "command": "edit_body",
        "id": node_id,
        "body": body}))
    print(self.socket.recv())


class NodeEditorFrame(wx.Frame):

  def __init__(self):
    wx.Frame.__init__(self, None)
    server = Server()
    server.connect()
    basic_editor = BasicEditor(self, server)


class BasicEditor(wx.SplitterWindow):

  def __init__(self, parent, server):
    wx.SplitterWindow.__init__(self, parent)
    body_editor = BodyEditor(self, server)
    node_tree = NodeTree(self, body_editor, server)
    self.SplitVertically(node_tree, body_editor, 300)


class NodeTree(wx.TreeCtrl):

  def __init__(self, parent, body_editor, server):
    wx.TreeCtrl.__init__(self, parent,
        style=wx.TR_HIDE_ROOT|wx.TR_LINES_AT_ROOT|wx.TR_HAS_BUTTONS)
    self.Bind(wx.EVT_TREE_SEL_CHANGED, self.OnSelChanged, self)
    self._body_editor = body_editor
    self._server = server
    root = self.AddRoot("root")
    for node in self._server.get_nodes():
      item = self.AppendItem(root, "%s" % node["id"])
      self.SetItemHasChildren(item, True)
      self.SetPyData(item, node)

  def OnSelChanged(self, event):
    item = event.GetItem()
    if item:
      self._body_editor.edit_node(self.GetPyData(item))


class BodyEditor(wx.TextCtrl):

  def __init__(self, parent, server):
    wx.TextCtrl.__init__(self, parent, style=wx.TE_MULTILINE)
    self.Bind(wx.EVT_TEXT, self.OnTextChanged, self)
    self._server = server
    self._current_node = None

  def edit_node(self, node):
    self._current_node = node
    self.SetValue(node["body"])

  def OnTextChanged(self, event):
    new_body = self.GetValue()
    self._server.edit_body(self._current_node["id"], new_body)
    self._current_node["body"] = new_body


if __name__ == "__main__":
  app = wx.App(False)
  frame = NodeEditorFrame()
  frame.Show()
  app.MainLoop()
