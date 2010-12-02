/**
 * Socket.IO Actionscript client
 * 
 * @author Matt Kane
 * @license The MIT license.
 * @copyright Copyright (c) 2010 CLEVR Ltd
 */

package com.clevr.socket {
	import flash.events.Event;
	
	public class IoDataEvent extends Event {
		
		public static const DATA : String = "IoDataEventData";
		public static const MESSAGE : String = "IoDataEventMessage";
		
		public var messageData:Object;
		public var messageType:String;
		
		public function IoDataEvent( type:String, messageData:Object,  messageType:String = null, bubbles:Boolean=true, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			this.messageData = messageData;
			if (type == IoDataEvent.MESSAGE) {
				this.messageType = messageType;
			}
		}
		
		override public function clone() : Event {
			return new IoDataEvent(type, messageData, messageType, bubbles, cancelable);
		}
		
		
	}
	
}

