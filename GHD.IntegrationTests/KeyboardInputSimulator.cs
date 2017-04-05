namespace GHD.IntegrationTests
{
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    using WoWSimulator.UISimulation;
    using WoWSimulator.UISimulation.XMLHandler;

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

        public void PressLeftArrow(int times = 1)
        {
            this.PressArrow("LEFT", times);
        }

        public void PressRightArrow(int times = 1)
        {
            this.PressArrow("RIGHT", times);
        }

        public void PressUpArrow(int times = 1)
        {
            this.PressArrow("UP", times);
        }

        public void PressDownArrow(int times = 1)
        {
            this.PressArrow("DOWN", times);
        }

        private void PressArrow(string arrow, int times)
        {
            for (int i = 0; i < times; i++)
            {
                this.editBox.GetScript(EditBoxHandler.OnArrowPressed)(this.editBox, arrow, null, null, null);
            }
        }

        public void PressEnd()
        {
            var len = this.editBox.GetText().Length;
            this.editBox.SetCursorPosition(len);
        }
    }
}