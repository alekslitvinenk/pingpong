package ru.alexli.pinpong
{
	[Bindable]
	public class GameModel
	{
		public function GameModel()
		{
		}
		
		public var playerID:String = String(Math.random());
			
		public var gameID:String;
		
		public var enemy:Object;
		
		public var enemyPosition:Number;
	}
}