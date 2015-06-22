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
        private readonly IGrinderFrame frame;
        private readonly CsLuaList<IGrinderTrackingRow> trackingRows;

        public View()
        {
            this.frame = (IGrinderFrame)Global.Api.GetGlobal("GrinderFrame");
            this.frame.Show();
            this.trackingRows = new CsLuaList<IGrinderTrackingRow>();
        }

        public void AddTrackingEntity(IEntityId id, string name, string icon)
        {
            var row = this.trackingRows.FirstOrDefault(r => r.IsShown() == false);

            if (row == null)
            {
                row = (IGrinderTrackingRow) Global.FrameProvider.CreateFrame(
                    FrameType.Frame, "GrinderTrackingRow" + (this.trackingRows.Count + 1), this.frame.TrackingContainer,
                    "GrinderTrackingRowTemplate");

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
            else
            {
                row.Show();
            }

            row.Id = id;
            row.Name.SetText(name);
            row.IconTexture.SetTexture(icon);
        }

        public void RemoveTrackingEntity(IEntityId id)
        {
            var index = this.trackingRows.IndexOf(this.trackingRows.First(row => row.Id.Equals(id)));

            while (true)
            {
                var row = this.trackingRows[index];
                if (row.IsShown() == true && row != this.trackingRows.Last(r => r.IsShown()))
                {
                    var nextRow = this.trackingRows[index + 1];
                    CloneRow(row, nextRow);
                }
                else
                {
                    row.Hide();
                    break;
                }

                index++;
            }
        }

        private static void CloneRow(IGrinderTrackingRow targetRow, IGrinderTrackingRow templateRow)
        {
            targetRow.Id = templateRow.Id;
            targetRow.Name.SetText(templateRow.Name.GetText());
            targetRow.IconTexture.SetTexture(templateRow.IconTexture.GetTexture());
            targetRow.Amount.SetText(templateRow.Amount.GetText());
            targetRow.Velocity.SetText(templateRow.Velocity.GetText());
        }

        public void SetTrackButtonOnClick(Action clickAction)
        {
            this.frame.TrackButton.SetScript(ButtonHandler.OnClick, button => clickAction());
        }

        public void SetTrackingEntityHandlers(Action<IEntityId> onReset, Action<IEntityId> onRemove)
        {
            throw new NotImplementedException();
        }

        public void SetUpdateAction(Action update)
        {
            double lastUpdate = 0;
            this.frame.SetScript(FrameHandler.OnUpdate, (frame) =>
            {
                if (Lua.Core.time() >= lastUpdate + 0.1)
                {
                    lastUpdate = Lua.Core.time();
                    update();
                }
            });
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
