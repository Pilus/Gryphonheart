
namespace GH.Menu
{
    using System;

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

        public bool DragWithoutShift;

        private bool beingDragged = false;
        private double? currentX;
        private double? currentY;
        private double dragOffsetX;
        private double dragOffsetY;

        public DragableButton(double size) : this(size, null)
        {
        }

        public DragableButton(double size, string name)
        {
            this.Button = Global.FrameProvider.CreateFrame(FrameType.Button, name, Global.Frames.UIParent) as IButton;
            this.Button.SetWidth(size);
            this.Button.SetHeight(size);
            this.SetUpButton();
        }

        public DragableButton(IButton button)
        {
            this.Button = button;
            this.SetUpButton();
        }

        private void SetUpButton()
        {
            this.Button.SetPoint(FramePoint.CENTER, Global.Frames.UIParent, FramePoint.CENTER, 0, 0);

            this.Button.RegisterForDrag(MouseButton.LeftButton);
            this.Button.SetMovable(true);

            this.Button.SetScript(FrameHandler.OnDragStart, this.OnDragStart);
            this.Button.SetScript(FrameHandler.OnDragStop, this.OnDragStop);
            this.Button.SetScript(FrameHandler.OnUpdate, this.OnUpdate);
            this.Button.SetScript(FrameHandler.OnEnter, this.OnEnter);
            this.Button.SetScript(FrameHandler.OnLeave, this.OnLeave);
            this.Button.SetScript(ButtonHandler.OnClick, this.OnClick);
            this.Button.SetScript(FrameHandler.OnHide, this.OnHide);
        }

        private void OnEnter(IUIObject self, object arg1)
        {
            if (this.EnterCallback != null)
            {
                this.EnterCallback();
            }
        }

        private void OnLeave(IUIObject self, object arg1)
        {
            if (this.LeaveCallback != null)
            {
                this.LeaveCallback();
            }
        }

        private void OnClick(IUIObject self, object arg1, object arg2)
        {
            if (this.ClickCallback != null)
            {
                this.ClickCallback();
            }
        }

        private void OnDragStart(IUIObject self, object arg1)
        {
            this.beingDragged = true;

            var cursorPos = Global.Api.GetCursorPosition();
            var scale = this.Button.GetEffectiveScale();

            var x = cursorPos.Value1 / scale;
            var y = cursorPos.Value2 / scale;
            if (this.currentX == null || this.currentY == null)
            {
                var center = this.Button.GetCenter();
                this.dragOffsetX = center.Value1 - x;
                this.dragOffsetY = center.Value2 - y;
            }
            else
            {
                this.dragOffsetX = (double)this.currentX - x;
                this.dragOffsetY = (double)this.currentY - y;
            }
        }

        private void OnDragStop(IUIObject self)
        {
            this.beingDragged = false;
            if (this.PositionChangeCallback != null)
            {
                this.PositionChangeCallback((double)this.currentX, (double)this.currentY);
            }
        }

        private void OnUpdate(IUIObject self, object arg1)
        {
            if (this.beingDragged && (Global.Api.IsShiftKeyDown() || this.DragWithoutShift))
            {
                var cursorPos = Global.Api.GetCursorPosition();
                var scale = this.Button.GetEffectiveScale();

                var x = cursorPos.Value1 / scale;
                var y = cursorPos.Value2 / scale;
                this.SetPosition(x + this.dragOffsetX, y + this.dragOffsetY);
            }

            if (this.UpdateCallback != null)
            {
                this.UpdateCallback();
            }
        }

        private void OnHide(IUIObject self)
        {
            if (this.HideCallback != null)
            {
                this.HideCallback();
            }
        }

        public void SetPosition(double x, double y)
        {
            this.Button.SetPoint(FramePoint.CENTER, Global.Frames.UIParent, FramePoint.BOTTOMLEFT, x, y);
            this.currentX = x;
            this.currentY = y;
        }
    }
}
