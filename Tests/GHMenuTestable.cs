namespace Tests
{
    using BlizzardApi.WidgetInterfaces;
    using System.Linq;
    using System.Text.RegularExpressions;
    using GH.Menu.Objects.EditField;
    using WoWSimulator;
    using WoWSimulator.UISimulation;

    public class GHMenuTestable
    {
        ISession session;
        IFrame currentMenu;

        public GHMenuTestable(ISession session)
        {
            this.session = session;
        }

        public void SelectMenu(string name)
        {
            var c = 1;

            IFrame menu = this.session.GetGlobal<IFrame>("Menu" + c);
            while (menu != null)
            {
                if (name == menu["Name"])
                {
                    this.currentMenu = menu;
                    return;
                }
                c++;
                menu = this.session.GetGlobal<IFrame>("Menu" + c);
            }

            throw new UiSimuationException(string.Format("No menu found with name {0}. Searched {1} menus.", name, c));
        }

        private void VerifyCurrentMenu()
        {
            if (this.currentMenu == null)
                throw new UiSimuationException("Current menu not set.");
        }

        private bool IsRegionInMenu(IRegion region)
        {
            return region != null && (region == this.currentMenu || this.IsRegionInMenu(region.GetParent()));
        }


        private IFontString GetLabel(string labelText)
        {
            var visibleFrames = this.session.Util.GetVisibleFrames().ToList();

            var framesInMenu = visibleFrames.Where(this.IsRegionInMenu);

            if (!framesInMenu.Any())
            {
                throw new UiSimuationException("No visible frames in menu.");
            }

            return (IFontString)framesInMenu.SelectMany(f => f.GetRegions()).FirstOrDefault(r =>
                (r is IFontString && (r as IFontString).GetText().Contains(labelText)));
        }

        public void VerifyLabelVisible(string labelText)
        {
            this.VerifyCurrentMenu();

            var label = this.GetLabel(labelText);

            if (label == null)
            {
                throw new UiSimuationException(string.Format("No label found displaying the text '{0}' in the menu.", labelText));
            }
        }

        private readonly Regex textLabelObjectRegex = new Regex(@"Wrapper\d+$");

        private IFrame GetObjectOfLabel(IFontString label)
        {
            var frame = label.GetParent();
            while (!this.textLabelObjectRegex.IsMatch(frame.GetName()))
            {
                frame = frame.GetParent();

                if (frame == null)
                {
                    throw new UiSimuationException("Highest level object not found.");
                }
            }
            return (IFrame)frame;
        }

        private IFrame GetObject(string labelText)
        {
            var label = this.GetLabel(labelText);
            if (label == null)
            {
                throw new UiSimuationException(string.Format("No label found displaying the text '{0}' in the menu.", labelText));
            }

            var objectWithTextLabelFrame = this.GetObjectOfLabel(label);
            return objectWithTextLabelFrame.GetChildren()[1];
        }

        private object GetValueFromObject(IFrame obj)
        {
            var name = Regex.Replace(obj.GetName(), @"\d+$", string.Empty);

            switch (name)
            {
                case "Editbox":
                    return (obj as IEditBox).GetText();
                case "EditField":
                    return (obj as IEditFieldFrame).Text.GetText();
                default:
                    throw new UiSimuationException(string.Format("Could not get value from object type '{0}'.", name));
            }
        }

        private void SetValueOnObject(IFrame obj, object value)
        {
            var name = Regex.Replace(obj.GetName(), @"\d+$", string.Empty);

            switch (name)
            {
                case "Editbox":
                    (obj as IEditBox).SetText(value as string);
                    break;
                case "EditField":
                    (obj as IEditFieldFrame).Text.SetText(value as string);
                    break;
                default:
                    throw new UiSimuationException(string.Format("Could not set value on object type '{0}'.", name));
            }
        }

        public object GetObjectValue(string labelText)
        {
            this.VerifyCurrentMenu();
            return GetValueFromObject(GetObject(labelText));
        }

        public void SetObjectValue(string labelText, object value)
        {
            this.VerifyCurrentMenu();
            SetValueOnObject(GetObject(labelText), value);
        }

        public void CloseMenu()
        {
            this.VerifyCurrentMenu();

            var button = (IButton)this.session.GetGlobal<IFrame>(this.currentMenu.GetName() + "TitleBarCloseButton");
            button.Click();
        }
    }
}
