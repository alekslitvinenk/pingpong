package ru.alexli.pinpong.net
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import ru.alexli.fcake.utils.log.Logger;
	import ru.alexli.pinpong.Game;

	public class SocketService
	{
		private var app:Game;
		
		private var socket:Socket;
		
		/**
		 * Длина пакета данных, полученных от сервера 
		 */		
		private var pkgLen:int;
		
		private var _dataBuffer:ByteArray = new ByteArray();
		
		/**
		 * Буфер пакета данных 
		 */		
		private var dataPackage:ByteArray = new ByteArray();
		
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
			
			app = Game.instance;
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
		
		public function sendMessage(val:Object):void
		{
			if(socket && socket.connected)
			{
				var jsonBa:ByteArray = new ByteArray();
				jsonBa.writeUTF(JSON.stringify(val));
				jsonBa.position = 0;
				
				var message:ByteArray = new ByteArray();
				message.writeInt(jsonBa.length);
				message.writeBytes(jsonBa);
				message.position = 0;
				
				socket.writeBytes(message);
				socket.flush();
			}
		}
		
		/**
		 * Чтение пакета данных из буфера данных 
		 * 
		 */		
		private function readDataPackage():void
		{
			var message:Object = JSON.parse(dataPackage.readUTF());
			
			switch(message.cmd)
			{
				/*case "onlogin":
					app.gmodel.playerInfo = message.playerinfo;
					break;*/
				
				case "enemyfound":
					app.gmodel.enemy = message.enemy;
					break;
				
				case "gamestarted":
					app.gmodel.gameID = message.gameid;
					break;
			}
		}
		
		/**
		 * Чтение данных из буфера данных и запись их буфер пакета
		 * Если длина пакета равна длине буфера данных, то вызывается функция чтения пакета 
		 * 
		 */		
		private function readFromBuffer():void
		{
			
			while(_dataBuffer.bytesAvailable)
			{
				//если длина пакета еще не была прочитана, то читаем ее
				if(pkgLen== 0){
					//если длина буфера позволяет прочитать длину пакета читаем ее
					if(_dataBuffer.length >= 4){
						pkgLen = _dataBuffer.readInt();
					}else{
						return;
					}
				}
				
				//общая длинна данных
				var dataLen:uint = _dataBuffer.bytesAvailable;
				
				//если данных в буфере больше чем длина пакета, считываем из буфера не больше длинны пакета
				if(dataLen >= pkgLen){
					var dataToRead:uint = pkgLen;
					
					_dataBuffer.readBytes(dataPackage, dataPackage.length, dataToRead);
					
					readDataPackage();
					
					pkgLen = 0;
				}else{
					return;
				}
				
			}
		}
		
		//events
		private function onConnect(evt:Event):void
		{
			Logger.debug("SOCKET CONNECTED");
			
			socket.endian = Endian.LITTLE_ENDIAN;
			
			sendMessage({
				cmd: "login",
				player: app.gmodel.playerID,
				time: new Date().time
			});
		}
		
		private function onClose(evt:Event):void
		{
			Logger.debug("SOCKET CLOSED BY SERVER");
		}
		
		private function onData(evt:ProgressEvent):void
		{
			Logger.debug("DATA RECEIVED: " + socket.bytesAvailable + " BYTES");
			socket.readBytes(_dataBuffer, _dataBuffer.length);
			
			readFromBuffer();
		}
		
		private function onError(err:Object):void
		{
			Logger.error(err);
		}
	}
}