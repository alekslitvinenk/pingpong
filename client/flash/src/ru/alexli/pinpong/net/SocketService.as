package ru.alexli.pinpong.net
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.Endian;
	
	import ru.alexli.fcake.utils.log.Logger;
	import ru.alexli.pinpong.Game;

	public class SocketService
	{
		private var socket:Socket;
		
		private static var canBeInstantiated:Boolean;
		
		private static var _instance:SocketService;
		
		public static function get instance():SocketService
		{
			if(!_instance)
			{
				canBeInstantiated = true;
				_instance = new SocketService();
				canBeInstantiated = false;
			}
			
			return _instance;
		}
		
		public function SocketService()
		{
			if(!canBeInstantiated)
			{
				throw new IllegalOperationError("Error!");
			}
		}
		
		public function connect():void
		{
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onConnect, false, 0, true);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onData, false, 0, true);
			socket.addEventListener(Event.CLOSE, onClose, false, 0, true);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
			socket.connect("217.146.78.167", 5000);
		}
		
		public function sendPosition(val:Number):void
		{
			if(socket && socket.connected)
			{
				socket.writeDouble(val);
				socket.flush();
			}
		}
		
		//events
		private function onConnect(evt:Event):void
		{
			Logger.debug("SOCKET CONNECTED");
			
			socket.endian = Endian.LITTLE_ENDIAN;
		}
		
		private function onClose(evt:Event):void
		{
			Logger.debug("SOCKET CLOSED BY SERVER");
		}
		
		private function onData(evt:ProgressEvent):void
		{
			Logger.debug("DATA RECEIVED");
			
			while(socket.bytesAvailable >= 8)
			{
				var enemyPos:Number = socket.readDouble();
				
				Game.instance.gmodel.enemyPosition = enemyPos;
			}
		}
		
		private function onError(err:Object):void
		{
			Logger.error(err);
		}
	}
}