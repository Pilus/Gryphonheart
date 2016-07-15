namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using BlizzardApi.WidgetInterfaces;
    using XMLHandler;

    public class CheckButton : Button, ICheckButton
    {
        public CheckButton(UiInitUtil util, string objectType, CheckButtonType frameType, IRegion parent)
            : base(util, objectType, frameType, parent)
        {
            
        }

        public bool GetChecked()
        {
            throw new NotImplementedException();
        }

        public string GetCheckedTexture()
        {
            throw new NotImplementedException();
        }

        public string GetDisabledCheckedTexture()
        {
            throw new NotImplementedException();
        }

        public void SetChecked(bool state)
        {
            //throw new NotImplementedException();
        }

        public void SetCheckedTexture(string texture)
        {
            throw new NotImplementedException();
        }

        public void SetDisabledCheckedTexture(string texture)
        {
            throw new NotImplementedException();
        }
    }
}