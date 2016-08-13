namespace GH.Menu.Objects
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;

    public class TooltipHandler
    {
        private static readonly double[] TooltipColor = new [] { 1.0, 0.8196079, 0.0 };

        private readonly IFrame frame;
        private string tooltipText;

        public TooltipHandler(IFrame frame)
        {
            this.frame = frame;
            this.frame.SetScript(FrameHandler.OnEnter, this.OnShow);
            this.frame.SetScript(FrameHandler.OnLeave, this.OnHide);
        }

        public void SetTooltip(string text)
        {
            this.tooltipText = text;
        }

        private void OnShow(IUIObject obj, object arg1)
        {
            if (string.IsNullOrEmpty(this.tooltipText))
            {
                return;
            }

            var tooltipFrame = Global.Frames.GameTooltip;
            tooltipFrame.SetOwner(this.frame, TooltipAnchor.ANCHOR_LEFT);
            tooltipFrame.ClearLines();
            tooltipFrame.AddLine(this.tooltipText, TooltipColor[0], TooltipColor[1], TooltipColor[2]);
            tooltipFrame.Show();
        }

        private void OnHide(IUIObject obj, object arg1)
        {
            var tooltipFrame = Global.Frames.GameTooltip;
            if (tooltipFrame.GetOwner().Equals(this.frame))
            {
                tooltipFrame.Hide();
            }
        }
    }
}