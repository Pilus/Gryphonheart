namespace Grinder.View
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using CsLua.Collection;
    using Grinder.View.Xml;
    using System;
    using Lua;

    public class View : IView
    {
        private const string VelocityString = "%f.2 / hour";

        private readonly IGrinderFrame frame;
        private readonly CsLuaList<IGrinderTrackingRow> trackingRows;
        private readonly IEntitySelectionDropdownHandler entitySelectionDropdownHandler;

        private Action<IEntityId> onReset;
        private Action<IEntityId> onRemove;

        public View(IEntitySelectionDropdownHandler entitySelectionDropdownHandler)
        {
            this.frame = (IGrinderFrame)Global.Api.GetGlobal("GrinderFrame", typeof(IGrinderFrame), true);
            this.frame.Show();
            this.trackingRows = new CsLuaList<IGrinderTrackingRow>();
            this.entitySelectionDropdownHandler = entitySelectionDropdownHandler;
        }

        public void AddTrackingEntity(IEntityId id, string name, string icon)
        {
            var row = this.trackingRows.FirstOrDefault(r => r.IsShown() == false);

            if (row == null)
            {
                row = Global.FrameProvider.CreateFrame<IGrinderTrackingRow>(
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

                ApplyTrackingEntityHandlersToRow(row);

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

        private void ApplyTrackingEntityHandlersToRow(IGrinderTrackingRow row)
        {
            row.ResetButton.SetScript(ButtonHandler.OnClick, (button) =>
            {
                var parent = (IGrinderTrackingRow)button.GetParent();
                if (this.onReset != null)
                {
                    this.onReset(parent.Id);
                }
            });

            row.RemoveButton.SetScript(ButtonHandler.OnClick, (button) =>
            {
                var parent = (IGrinderTrackingRow)button.GetParent();
                if (this.onRemove != null)
                {
                    this.onRemove(parent.Id);
                }
            });
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
            this.onReset = onReset;
            this.onRemove = onRemove;
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

        public void ShowEntitySelection(IEntitySelection selection)
        {
            this.entitySelectionDropdownHandler.Show(this.frame.TrackButton, selection);
        }

        public void UpdateTrackingEntityVelocity(IEntityId id, int count, double velocity)
        {
            var row = this.trackingRows.First(r => r.Id.Equals(id));
            row.Amount.SetText(count + string.Empty);
            row.Velocity.SetText(Strings.format(VelocityString, velocity));
        }
    }
}
