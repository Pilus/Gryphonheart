
namespace GHF.View.CharacterMenuProfile.CharacterList
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using GHF.Model;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Lua;

    public class CharacterListFrame
    {
        private const double YOffset = -20;
        private IFrame frame;
        private List<CharacterListButtonHandler> buttons;

        public CharacterListFrame(IFrame parent)
        {
            this.frame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, parent.GetName() + "CharacterList", parent);
            this.frame.SetPoint(FramePoint.TOPRIGHT, parent, FramePoint.TOPLEFT, 0, YOffset);
            this.frame.SetWidth(CharacterListButtonHandler.Width);
            this.buttons = new List<CharacterListButtonHandler>();
            SetBackdrop(this.frame, "");
        }

        private static void SetBackdrop(IFrame frame, string texture)
        {
            var backdrop = new NativeLuaTable();
            backdrop["bgFile"] = texture;
            backdrop["edgeFile"] = "Interface/Tooltips/UI-Tooltip-Border";
            backdrop["tile"] = false;
            backdrop["tileSize"] = 16;
            backdrop["edgeSize"] = 16;
            var inserts = new NativeLuaTable();
            backdrop["left"] = 4;
            backdrop["right"] = 4;
            backdrop["top"] = 4;
            backdrop["bottom"] = 4;
            backdrop["insets"] = inserts;
            frame.SetBackdrop(backdrop);
        }

        public void Toggle()
        {
            if (this.frame.IsShown())
            {
                this.frame.Hide();
            }
            else
            {
                this.frame.Show();
            }
        }

        public void SetUp(List<Profile> profiles, string initialId, Action<string> toggleProfile, Action save)
        {
            this.PrepareButtons(profiles.Count);

            for (var i = 0; i < profiles.Count; i++)
            {
                var button = this.buttons[i];
                var profile = profiles[i];

                button.Display(profile);

                if (profile.Id.Equals(initialId))
                {
                    button.Highlight(true);
                }

                button.SetClick(() =>
                {
                    save();
                    this.buttons.ForEach(b => b.Highlight(false));
                    button.Highlight(true);
                    toggleProfile(profile.Id);
                });
            }
        }

        private void PrepareButtons(int count)
        {
            var formatter = new ProfileFormatter();
            for (var i = this.buttons.Count; i < count; i++)
            {
                var button = new CharacterListButtonHandler(this.frame, formatter);
                if (i == 0)
                {
                    button.Button.SetPoint(FramePoint.TOP, this.frame, FramePoint.TOP);
                }
                else
                {
                    button.Button.SetPoint(FramePoint.TOP, this.buttons.Last().Button, FramePoint.BOTTOM);
                }
                this.buttons.Add(button);
            }
        }

        public void Update(Profile profile)
        {
            var button = this.buttons.First(b => b.CurrentId() == profile.Id);
            button.Display(profile);
        }
    }
}
