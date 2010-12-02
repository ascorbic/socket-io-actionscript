/**
 * Socket.IO Actionscript client
 * 
 * @author Matt Kane
 * @license The MIT license.
 * @copyright Copyright (c) 2010 CLEVR Ltd
 */

package com.clevr.socket
{	
	import com.adobe.serialization.json.JSON;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.AsyncErrorEvent;
	
	public class SocketIo extends EventDispatcher {
		public var connected:Boolean = false;
		public var connecting:Boolean = false;
		public var host:String;
		public var options:Object;
		public var socket:WebSocket;
		public var sessionid:String;
		
		protected var decoder:DataDecoder;
		private var _queue:Array;

		public function SocketIo(host:String, options:Object) {
			super();
			this.options = {
				secure: false,
				port:  80,
				resource: 'socket.io'
			}
			this.host = host;
			_queue = new Array();
			for(var p:String in options){
				this.options[p] = options[p];
			}
			decoder = new DataDecoder();
			var self:SocketIo = this;
			decoder.addEventListener(IoDataEvent.MESSAGE, function(event:IoDataEvent):void {
				self.onMessage(event.messageType, event.messageData);
			});
			
			decoder.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(event:AsyncErrorEvent):void {
				onError(event.text);
			})
		}
		
		public function connect():void {
			if(connecting) {
				disconnect();
			}
			connecting = true;
			socket = new WebSocket(url, "");
			
			var self:SocketIo = this;
			socket.addEventListener("message", function(e:Event):void {
				var data:Array = self.socket.readSocketData();
				for (var i:int = 0; i < data.length; i++) {
					self.decoder.add(data[i]);
				}
			});
			
			socket.addEventListener("close", function(e:Event):void {
				onDisconnect();
			});
			
			socket.addEventListener("error", function(e:Event):void {
				onError("Socket error");
			});
			socket.addEventListener("open", function(e:Event):void {
				onConnect();
			});
		}
		
		public function send(message:Object, atts:Object = null):void {
			if(!atts) {
				atts = {};
			}
			if(typeof message == 'object') {
				message = JSON.encode(message);
				atts['j'] = null;
			}
			write('1', DataDecoder.encodeMessage(message.toString(), atts));
		}
		
		public function json(message:Object, atts:Object = null):void {
			if(!atts) {
				atts = {};
			}
			atts['j'] = null;
			write('1', DataDecoder.encodeMessage(JSON.encode(message), atts));
		}
		
		
		public function write(type:Object, message:Object = null):void {
			if(!connected || !socket) {
				enQueue(type, message);
			} else {
				socket.send(DataDecoder.encode(typeof type == 'array' ? type as Array: [type, message]));
			}
		}
		
		public function disconnect():void {
			socket.close();
			onDisconnect();
		}
		
		protected function enQueue(type:Object, message:Object):void {
			if(!_queue) {
				_queue = new Array();
			}
			_queue.push([type, message]);
		}
		
		protected function runQueue():void {
			if(_queue.length && connected && socket) {
				write(_queue);
				_queue = new Array();
			}
			
		}
		

		protected function get url():String{
				return (options.secure ? 'wss' : 'ws') 
				+ '://' + host 
				+ ':' + options.port
				+ '/' + options.resource
				+ '/flashsocket'
				+ (sessionid ? ('/' + sessionid) : '');
		}
		
		protected function onMessage(type:String, data:Object):void {
			var message:String = data.toString();
			switch (type){
				case '0':
					disconnect();
					break;

				case '1':
					var msg:Array = DataDecoder.decodeMessage(message);
					if ('j' in msg[1]){
						msg[0] = JSON.decode(msg[0]);
					}
					dispatchEvent(new IoDataEvent(IoDataEvent.DATA, msg[0]));
					break;

				case '2':
					onHeartbeat(message);
					break;

				case '3':
					sessionid = message;
					onConnect();
					break;
			}
		}
		
		protected function onHeartbeat(heartbeat:Object):void {
			write('2', heartbeat); // echo
		}
		
		protected function onError(message:String):void {
			trace("Error: " + message);
			connected = false;
			connecting = false;
			sessionid = null;
			_queue = [];
			dispatchEvent(new Event("error"));
		}
		
		protected function onConnect():void	{
			connected = true;
			connecting = false;
			runQueue();
			dispatchEvent(new Event(Event.CONNECT));
		}
		
		protected function onDisconnect():void {
			var wasConnected:Boolean = connected;
			connected = false;
			connecting = false;
			sessionid = null;
			
			_queue = [];
			if (wasConnected) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}