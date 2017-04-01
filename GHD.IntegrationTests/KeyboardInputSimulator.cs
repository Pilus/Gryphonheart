namespace GHD.IntegrationTests
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using WoWSimulator.UISimulation;

    public class KeyboardInputSimulator
    {
        private IEditBox editBox;

        public KeyboardInputSimulator()
        {
            this.editBox = GlobalFrames.CurrentFocus;
        }

        public void TypeString(string str)
        {
            foreach (var c in str.ToCharArray())
            {
                this.editBox.Insert(c.ToString());
            }
        }

        public void MoveLeft(int times = 1)
        {
            for (int i = 0; i < times; i++)
            {
                this.editBox.GetScript(EditBoxHandler.OnArrowPressed)(this.editBox, "LEFT", null, null, null);
            }
        }
    }
}