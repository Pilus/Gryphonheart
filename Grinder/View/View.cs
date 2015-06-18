namespace Grinder.View
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Grinder.View.Xml;
    using System;
    public class View : IView
    {
        private const string RowId = "Id";
        private IGrinderFrame frame;
        private CsLuaList<IGrinderTrackingRow> trackingRows;

        public View()
        {
            this.frame = (IGrinderFrame)Global.Api.GetGlobal("GrinderFrame");
            this.frame.Show();
            this.trackingRows = new CsLuaList<IGrinderTrackingRow>();
        }

        public void AddTrackingEntity(IEntityId id, string name, string icon)
        {
            var row = (IGrinderTrackingRow)Global.FrameProvider.CreateFrame(
                FrameType.Frame, "GrinderTrackingRow" + (this.trackingRows.Count + 1), this.frame.TrackingContainer, "GrinderTrackingRowTemplate");

            row[RowId] = id;
            row.Name.SetText(name);
            row.IconTexture.SetTexture(icon);

            var previousRow = this.trackingRows.LastOrDefault();
            if (previousRow == null)
            {
                row.SetPoint(FramePoint.TOPLEFT, this.frame.TrackingContainer, FramePoint.TOPLEFT);
                row.SetPoint(FramePoint.TOPRIGHT, this.frame.TrackingContainer, FramePoint.TOPRIGHT);
            }
            else
            {
                row.SetPoint(FramePoint.TOPLEFT, previousRow, FramePoint.BOTTOMLEFT);
                row.SetPoint(FramePoint.TOPRIGHT, previousRow, FramePoint.BOTTOMRIGHT);
            }

            this.trackingRows.Add(row);
        }

        public void RemoveTrackingEntity(IEntityId id)
        {
            throw new NotImplementedException();
        }

        public void SetTrackButtonOnClick(Action clickAction)
        {
            this.frame.TrackButton.SetScript(ButtonHandler.OnClick, (IButton button) => clickAction());
        }

        public void SetTrackingEntityHandlers(Action<IEntityId> onReset, Action<IEntityId> onRemove)
        {
            throw new NotImplementedException();
        }

        public void SetUpdateAction(Action update)
        {
            throw new NotImplementedException();
        }

        public void ShowEntitySelection(IEntitySelection selction)
        {
            throw new NotImplementedException();
        }

        public void UpdateTrackingEntityVelocity(IEntityId id, int count, double velocity)
        {
            throw new NotImplementedException();
        }
    }
}
