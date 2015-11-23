package ru.alexli.pinpong.view
{
	import flash.display.Graphics;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import ru.alexli.fcake.utils.log.Logger;
	import ru.alexli.fcake.view.AbstractVisualObject;
	import ru.alexli.fcake.view.utils.DrawShortcuts;
	import ru.alexli.pinpong.Game;
	import ru.alexli.pinpong.net.SocketService;
	
	public class MainView extends AbstractVisualObject
	{
		private var app:Game;
		
		private var playerLaunchpad:LaunchpadView;
		private var enemyLaunchpad:LaunchpadView;
		
		private var lastUpdate:int;
		
		public function MainView()
		{
			super();
		}
		
		override protected function onShow():void
		{
			app = Game.instance;
			
			DrawShortcuts.drawRect(this, stage.stageWidth, stage.stageHeight);
			
			var g:Graphics = this.graphics;
			g.moveTo(stage.stageWidth/2, 0);
			g.lineStyle(5, 0xCCCCCC);
			g.lineTo(stage.stageWidth/2, stage.stageHeight);
			
			addChild(playerLaunchpad = new LaunchpadView());
			playerLaunchpad.y = stage.stageHeight/2 - playerLaunchpad.height/2;
			
			addChild(enemyLaunchpad = new LaunchpadView());
			enemyLaunchpad.x = stage.stageWidth - enemyLaunchpad.width;
			enemyLaunchpad.y = playerLaunchpad.y;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		override protected function addBindings():void
		{
			bindSetter(onEnemy, app.gmodel, "enemyPosition");
		}
		
		//binding
		private function onEnemy(val:Number):void
		{
			//enemyLaunchpad.y = val;
		}
		
		//events
		private function onKeyDown(evt:KeyboardEvent):void
		{
			var t:int = getTimer();
			
			if((t - lastUpdate) < 1000) return;
			
			lastUpdate = t;
			
			if(evt.keyCode == Keyboard.UP || evt.keyCode == Keyboard.W)
			{
				SocketService.instance.sendMessage({
					cmd: "moveup",
					game: app.gmodel.gameID,
					time: new Date().time
				});
				
				playerLaunchpad.setPos(playerLaunchpad.y - 50);
			}
			
			if(evt.keyCode == Keyboard.DOWN  || evt.keyCode == Keyboard.S)
			{
				SocketService.instance.sendMessage({
					cmd: "movedown",
					game: app.gmodel.gameID,
					time: new Date().time
				});
				
				playerLaunchpad.setPos(playerLaunchpad.y + 50);
			}
		}
	}
}