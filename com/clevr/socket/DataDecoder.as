/**
 * Socket.IO Actionscript client
 * 
 * @author Matt Kane
 * @license The MIT license.
 * @copyright Copyright (c) 2010 CLEVR Ltd
 */


package com.clevr.socket {
	import flash.events.EventDispatcher;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	
	public class DataDecoder extends EventDispatcher {

		private var buffer:String;
		private var i:int;
		private var lengthString:String = '';
		private var length:Number;
		private var data:String;
		private var type:String;

		public function DataDecoder() {
			reset();
			buffer = '';
		}

		public function add(data:String):void {
			buffer += data;
			parse();
		}

		public function parse():void {
			for (var l:int = buffer.length; i < l; i++){
				var chr:String = buffer.charAt(i);
				
				if (type === null){
					if (chr == ':') return error('Data type not specified');
					type = '' + chr;
					continue;
				}
				if (isNaN(length) && lengthString === null && chr == ':'){
					lengthString = '';
					continue;
				}
				if (data === null){
					
					if (chr != ':'){
						
						lengthString += chr;
					} else { 
						
						if (lengthString.length === 0)
							return error('Data length not specified');
						length = parseInt(lengthString);
						
						lengthString = null;
						data = '';
					}
					continue;
				}
				if (data.length === length){
					
					if (chr == ','){
						dispatchEvent(new IoDataEvent(IoDataEvent.MESSAGE, data, type));
						buffer = buffer.substr(i + 1);
						reset();
						return parse();
					} else {
						return error('Termination character "," expected');
					}
				} else {
					
					data += chr;
				}
			}

		}
		
		
		public function reset():void {
			type = data = lengthString = null;
			length = Number.NaN;
			i = 0;
		}
		
		private function error(reason:String):void {
			reset();
			dispatchEvent(new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR, false, false, reason));
		}
		
		public static function encode(messages:Array):String {
			
			if(typeof messages[0] != 'array') {
				 messages = [messages];
			}
			
			var ret:String = '';
			var str:String;
			for (var i:int = 0; i < messages.length; i++){
				str = messages[i][1];
				if (str === null) str = '';
				ret += messages[i][0] + ':' + str.length + ':' + str + ',';
			}
			return ret;
		}
		
		public static function encodeMessage(msg:String, anns:Object):String {
			var data:String = '';
			var v:String;
			if(!anns) {
				anns = {};
			}
			for (var k:Object in anns){
				v = anns[k];
				data += k + (v !== null ? ':' + v : '') + "\n";
			}
			data += ':' + (msg === null ? '' : msg);
			return data;			
		}
		
		public static function decodeMessage(msg:String):Array	{
			/*trace('decoding message: ' + msg);*/
			var anns:Object = {};
			var data:String;

			var chr:String;
			var key:String;
			var value:String;
			var l:int = msg.length;

			for (var i:int = 0; i < l; i++){
				chr = msg.charAt(i);
				if (i === 0 && chr === ':'){
					data = msg.substr(1);
					break;
				}
				if (key == null && value == null && chr == ':'){
					data = msg.substr(i + 1);
					break;
				}
				if (chr === "\n"){
					anns[key] = value;
					key = value = null;
					continue;
				}
				if (key == null){
					key = chr;
					continue;
				}
				if (value == null && chr == ':'){
					value = '';
					continue;
				}
				if (value !== null)
					value += chr;
				else
					key += chr;
			}
			return [data, anns];

		}

	}
}
