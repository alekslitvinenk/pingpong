package ru.alexli.pinpong.cmd
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import ru.alexli.fcake.command.AbstractCommand;
	import ru.alexli.fcake.utils.log.Logger;
	
	public class GetUpdateCmd extends AbstractCommand
	{
		private var loader:URLLoader;
		
		public function GetUpdateCmd()
		{
			super();
		}
		
		override protected function execInternal():void
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(new URLRequest("http://alibaba-games.com/login/update.php"));
		}
		
		//events
		private function onLoadComplete(evt:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			Logger.debug("Data: ", loader.data);
		}
		
		private function onError(err:Object):void
		{
			Logger.error(err);
		}
	}
}