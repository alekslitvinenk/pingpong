package ru.alexli.pinpong.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import ru.alexli.fcake.view.utils.DrawShortcuts;
	
	public class LaunchpadView extends Sprite
	{
		public function LaunchpadView()
		{
			super();
			
			DrawShortcuts.drawRect(this, 20, 100, 0xCCCCCC);
			
			var innerFill:Shape = new Shape();
			innerFill.x = 5;
			innerFill.y = 5;
			addChild(innerFill);
			
			DrawShortcuts.drawRect(innerFill, 10, 90, 0x999999);
		}
		
		public function setPos(val:Number):void
		{
			//val -= height/2;
			
			if(val < 0)
			{
				val = 0;
			}
			
			if((val + height) > stage.stageHeight)
			{
				val = stage.stageHeight - height;
			}
			
			y = val;
		}
	}
}