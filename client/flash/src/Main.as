package
{
	import ru.alexli.fcake.view.AbstractVisualObject;
	import ru.alexli.pinpong.Game;
	
	[SWF(frameRate="32", width="600", height="400", backgroundColor="#000000")]
	public class Main extends AbstractVisualObject
	{
		public function Main()
		{
			super();
		}
		
		override protected function onShow():void
		{
			addChild(Game.instance);
		}
	}
}