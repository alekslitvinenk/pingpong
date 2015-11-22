package ru.alexli.pinpong.view
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
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
			
			addChild(enemyLaunchpad = new LaunchpadView());
			enemyLaunchpad.x = stage.stageWidth - enemyLaunchpad.width;
			enemyLaunchpad.setPos(stage.stageHeight/2);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		override protected function addBindings():void
		{
			bindSetter(onEnemy, app.gmodel, "enemyPosition");
		}
		
		//binding
		private function onEnemy(val:Number):void
		{
			enemyLaunchpad.y = val;
		}
		
		//events
		private function onMouseMove(evt:MouseEvent):void
		{
			playerLaunchpad.setPos(stage.mouseY);
			
			//Logger.debug("Position: ", playerLaunchpad.y);
			
			SocketService.instance.sendPosition(playerLaunchpad.y);
			
			evt.updateAfterEvent();
		}
	}
}