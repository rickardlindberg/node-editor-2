node-editor-2
=============

Experimental outliner/IDE.

I want a better IDE. I want to edit code, not text. Code (and other documents)
have a hierarchical structure that is not immediately visible when browsing
code in an editor.

The basic editor I imagine looks like this:

![](doc/basic_editor.png?raw=true)

Then you can split into more of this basic editor. Sort of like you can do in
Vim.

![](doc/splits.png?raw=true)

Then you can have multiple tabs of these splits.

![](doc/tabbed.png?raw=true)

Distributed editing
-------------------

The client can be quite dumb, and the core of the node editing happens on a
server. The server and client can (and probably will be most of the time) on
the same machine. They will communicate with ZeroMQ.

![](doc/distributed_editing.png?raw=true)

API
---

- `add_node`
- `delete_node`
- `move_node`
- `edit_node`

Cross-language
--------------

Should be able to write node plugins for different document types.
