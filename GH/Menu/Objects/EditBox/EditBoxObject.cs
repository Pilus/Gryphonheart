namespace GH.Menu.Objects.EditBox
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Debug;

    public class EditBoxObject : BaseObject, IMenuObjectWithValue
    {
        private const string Template = "GH_EditBoxWithFilters_Template";

        public static string Type = "Editbox";

        private readonly IEditBoxWithFilters frame;

        private double? width;

        public EditBoxObject() : base(Type, FrameType.EditBox, Template)
        {
            this.frame = (IEditBoxWithFilters) this.Frame;
        }

        public override void Prepare(IElementProfile profile, IMenuHandler handler)
        {
            base.Prepare(profile, handler);
            this.SetUpFromProfile((EditBoxProfile) profile);
        }


        private void SetUpFromProfile(EditBoxProfile profile)
        {
            this.frame.NumbersOnly = profile.numbersOnly;
            this.frame.VariablesOnly = profile.variablesOnly;

            if (profile.width != null)
            {
                this.frame.SetWidth((double)profile.width);
            }

            this.frame.SetScript(EditBoxHandler.OnTextChanged, (self) =>
            {
                if (profile.OnTextChanged != null)
                {
                    profile.OnTextChanged(this.frame.GetText());
                }
            });

            this.frame.SetScript(EditBoxHandler.OnEnterPressed, (self) =>
            {
                if (profile.OnEnterPressed != null)
                {
                    profile.OnEnterPressed();
                }
            });

            if (profile.size != null)
            {
                this.frame.SetMaxLetters((int)profile.size);
            }
            
            if (profile.startText != null)
            { 
                this.frame.SetText(profile.startText);
            }

            this.width = profile.width;
            //this.SetUpTabbableObject(new TabableEditBox(this.frame));
        }

        public object GetValue()
        {
            return this.frame.GetText();
        }

        public void SetValue(object value)
        {
            this.frame.SetText((string)value ?? "");
        }

        public override double GetPreferredCenterY()
        {
            return -4;
        }

        public override double? GetPreferredWidth()
        {
            return this.width;
        }
    }
}