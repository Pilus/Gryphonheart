namespace GH.Menu.Objects.EditBox
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using Debug;

    public class EditBoxObject : BaseObject
    {
        private readonly IEditBoxWithFilters frame;
        private readonly EditBoxProfile profile;

        public EditBoxObject(EditBoxProfile profile, IMenuContainer parent, LayoutSettings settings)
            : base(profile, parent, settings)
        {
            this.frame = (IEditBoxWithFilters)FrameUtil.FrameProvider.CreateFrame(FrameType.EditBox, UniqueName(Type), parent.Frame, "GH_EditBoxWithFilters_Template");
            this.Frame = this.frame;
            this.profile = profile;

            this.SetUpFromProfile();
        }

        public static EditBoxObject Initialize(IObjectProfile profile, IMenuContainer parent, LayoutSettings settings)
        {
            return new EditBoxObject((EditBoxProfile)profile, parent, settings);
        }

        public static string Type = "Editbox";

        private void SetUpFromProfile()
        {
            this.frame.NumbersOnly = this.profile.numbersOnly;
            this.frame.VariablesOnly = this.profile.variablesOnly;

            if (this.profile.width != null)
            {
                this.frame.SetWidth((double)this.profile.width);
            }

            this.frame.SetScript(EditBoxHandler.OnTextChanged, (self) =>
            {
                if (this.profile.OnTextChanged != null)
                {
                    this.profile.OnTextChanged(this.frame.GetText());
                }
            });

            this.frame.SetScript(EditBoxHandler.OnEnterPressed, (self) =>
            {
                if (this.profile.OnEnterPressed != null)
                {
                    this.profile.OnEnterPressed();
                }
            });

            if (this.profile.size != null)
            {
                this.frame.SetMaxLetters((int)this.profile.size);
            }
            
            if (this.profile.startText != null)
            { 
                this.frame.SetText(this.profile.startText);
            }

            this.SetUpTabbableObject(this.frame);
        }

        public override object GetValue()
        {
            return this.frame.GetText();
        }

        public override void SetValue(object value)
        {
            this.frame.SetText((string)value ?? "");
        }

        public override double GetPreferredCenterY()
        {
            return -4;
        }

        public override double? GetPreferredWidth()
        {
            return this.profile.width;
        }
    }
}