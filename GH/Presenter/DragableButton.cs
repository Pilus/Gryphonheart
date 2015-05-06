
namespace GH.Presenter
{
    using System;
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class DragableButton
    {
        public IButton Button { get; private set; }
        public Action<double, double> PositionChangeCallback { get; set; }
        public Action EnterCallback { get; set; }
        public Action LeaveCallback { get; set; }
        public Action ClickCallback { get; set; }
        public Action UpdateCallback { get; set; }
        public Action HideCallback { get; set; }

        private bool beingDragged = false;
        private double currentX;
        private double currentY;

        public DragableButton(double size)
        {
            this.Button = FrameUtil.FrameProvider.CreateFrame(FrameType.Button, null, Global.UIParent) as IButton;
            this.Button.SetWidth(size);
            this.Button.SetHeight(size);
            this.Button.SetPoint(FramePoint.CENTER, Global.UIParent, FramePoint.CENTER, 0, 0);

            this.Button.RegisterForDrag(MouseButton.LeftButton);
            this.Button.SetMovable(true);

            this.Button.SetScript(FrameHandler.OnDragStart, this.OnDragStart);
            this.Button.SetScript(FrameHandler.OnDragStop, this.OnDragStop);
            this.Button.SetScript(FrameHandler.OnUpdate, this.OnUpdate);
            this.Button.SetScript(FrameHandler.OnEnter, this.OnEnter);
            this.Button.SetScript(FrameHandler.OnLeave, this.OnLeave);
            this.Button.SetScript(ButtonHandler.OnClick, this.OnClick);
            this.Button.SetScript(FrameHandler.OnUpdate, this.OnUpdate);
            this.Button.SetScript(FrameHandler.OnHide, this.OnHide);
        }

        private void OnEnter()
        {
            if (this.EnterCallback != null)
            {
                this.EnterCallback();
            }
        }

        private void OnLeave()
        {
            if (this.LeaveCallback != null)
            {
                this.LeaveCallback();
            }
        }

        private void OnClick()
        {
            if (this.ClickCallback != null)
            {
                this.ClickCallback();
            }
        }

        private void OnDragStart()
        {
            this.beingDragged = true;
        }

        private void OnDragStop()
        {
            this.beingDragged = false;
            if (this.PositionChangeCallback != null)
            {
                this.PositionChangeCallback(this.currentX, this.currentY);
            }
        }

        private void OnUpdate()
        {
            if (this.beingDragged && Global.IsShiftKeyDown())
            {
                var cursorPos = Global.GetCursorPosition();
                var scale = this.Button.GetEffectiveScale();

                var x = cursorPos.Item1 / scale;
                var y = cursorPos.Item2 / scale;
                this.SetPosition(x, y);
            }

            if (this.UpdateCallback != null)
            {
                this.UpdateCallback();
            }
        }

        private void OnHide()
        {
            if (this.HideCallback != null)
            {
                this.HideCallback();
            }
        }

        public void SetPosition(double x, double y)
        {
            this.Button.SetPoint(FramePoint.CENTER, Global.UIParent, FramePoint.BOTTOMLEFT, x, y);
            this.currentX = x;
            this.currentY = y;
        }
    }
}
