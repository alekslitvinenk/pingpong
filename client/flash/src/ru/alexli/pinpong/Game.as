package ru.alexli.pinpong
{
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import ru.alexli.fcake.utils.log.BrowserConsoleTarget;
	import ru.alexli.fcake.utils.log.LogLevel;
	import ru.alexli.fcake.utils.log.Logger;
	import ru.alexli.fcake.utils.log.TraceTarget;
	import ru.alexli.fcake.view.AbstractApp;
	import ru.alexli.pinpong.net.SocketService;
	import ru.alexli.pinpong.view.MainView;
	
	public class Game extends AbstractApp
	{
		public var gmodel:GameModel;
		
		private var mainView:Sprite;
		
		private static var canBeInstantiated:Boolean;
		
		private static var _instance:Game;
		
		public static function get instance():Game
		{
			if(!_instance)
			{
				canBeInstantiated = true;
				_instance = new Game();
				canBeInstantiated = false;
			}
			
			return _instance;
		}
		
		public function Game()
		{
			if(!canBeInstantiated)
			{
				throw new IllegalOperationError("Error!");
			}
		}
		
		override protected function onAppCreated():void
		{
			Logger.targets = [new TraceTarget(LogLevel.DEBUG), new BrowserConsoleTarget(LogLevel.DEBUG)];
			Logger.debug("INIT");
			
			gmodel = new GameModel();
			
			//new GetUpdateCmd().execute();
			
			SocketService.instance.connect();
		}
		
		override protected function onAppInited():void
		{
			Logger.debug("SHOW");
			
			addChild(mainView = new MainView());
		}
	}
}