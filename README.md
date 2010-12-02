socket.io Actionscript client
============================
#### By Matt Kane

This is a client for [socket.io](https://github.com/LearnBoost/Socket.IO/) implemented in Actionscript 3. It allows you to connect to the socket server from your Adobe AIR/Flex application. I've tested it in AIR but it should probably work in regular Flex, subject to crossdomain policies.

### Usage
I've tried to follow the same API as the socket.io javascript client. This is a simple example of connecting to a socket.

    socket = new SocketIo("127.0.0.1", {port: 8080});
    socket.addEventListener(IoDataEvent.DATA, function(e:IoDataEvent):void {
        trace(e.messageData);
    });
    socket.connect();
    socket.send("Hi!");
 
For a full example, look at Example.mxml, which is a Flex/AIR port of the socket.io chat demo. You'll need to be running the chat demo server for this to work. See the main socket.io project for details of this.

Compile and run it like so:

    amxmlc Example.mxml
    adl example.xml
    
### Requirements
Obviously, you'll need the Flex and/or AIR SDK. You also need a couple of libraries.

+ [as3corelib](https://github.com/mikechambers/as3corelib)
+ [as3crypto](http://code.google.com/p/as3crypto/)

Install these either as compiled .swcs in your flex library folder, or as source in this folder.

### Bugs and contributions
If you have a patch, fork the Github repo and send me a pull request. Submit bug reports on GitHub, please. 


### Credits

By [Matt Kane](https://github.com/ascorbic)

### License 

(The MIT License)

Copyright (c) 2010 [CLEVR Ltd](http://www.clevr.ltd.uk/)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Includes code from [web-socket-js](https://github.com/gimite/web-socket-js/) Copyright (c) Hiroshi Ichikawa
Also includes code derived from [socket.io](https://github.com/LearnBoost/Socket.IO/) Copyright (c) 2010 LearnBoost