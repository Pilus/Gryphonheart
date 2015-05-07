namespace GH.Menu.Objects.EditBox
{
    using BlizzardApi;
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;

    public class EditBoxObject : BaseObject
    {
        private readonly IEditBoxFrame frame;
        private readonly EditBoxProfile profile;

        public EditBoxObject(EditBoxProfile profile, IMenuContainer parent, LayoutSettings settings)
            : base(profile, parent, settings)
        {
            this.frame = (IEditBoxFrame)FrameUtil.FrameProvider.CreateFrame(FrameType.Frame, UniqueName(Type), parent.Frame, "GH_EditBoxFrame_Template");
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
            this.frame.Box.NumbersOnly = this.profile.numbersOnly;
            this.frame.Box.VariablesOnly = this.profile.variablesOnly;

            if (this.profile.width != null)
            {
                this.frame.SetWidth((double)this.profile.width);
            }

            this.frame.Box.SetScript(EditBoxHandler.OnTextChanged, () =>
            {
                if (this.profile.OnTextChanged != null)
                {
                    this.profile.OnTextChanged(this.frame.Box.GetText());
                }
            });

            this.frame.Box.SetScript(EditBoxHandler.OnEnterPressed, () =>
            {
                if (this.profile.OnEnterPressed != null)
                {
                    this.profile.OnEnterPressed();
                }
            });

            if (this.profile.size != null)
            {
                this.frame.Box.SetMaxLetters((int)this.profile.size);
            }
            
            if (this.profile.startText != null)
            { 
                this.frame.Box.SetText(this.profile.startText);
            }

            this.SetUpTabbableObject(this.frame.Box);
        }

        public override object GetValue()
        {
            return this.frame.Box.GetText();
        }

        public override void Force(object value)
        {
            this.frame.Box.SetText((string)value ?? "");
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