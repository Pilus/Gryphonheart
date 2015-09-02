

namespace GHF.View
{
    using System;
    using CharacterMenuProfile;
    using GH.Menu;
    using GH.Menu.Objects;
    using GH.Menu.Objects.Button;
    using GH.Menu.Objects.Dummy;
    using GH.Menu.Objects.EditBox;
    using GH.Menu.Objects.EditField;
    using GH.Menu.Objects.Line;
    using GH.Menu.Objects.Page;
    using GH.Menu.Objects.Panel;
    using GH.Menu.Objects.Text;

    public class ProfileTabProfileGenerator
    {
        public PageProfile GenerateProfile(Action<string, object> valueUpdater)
        {
            return new PageProfile("Profile")
            {
                new LineProfile()
                {
                    new DummyProfile()
                    {
                        height = CharacterListToggleObject.Height,
                        width = CharacterListToggleObject.Width,
                        label = ProfileTabLabels.ToggleCharacterList,
                    }
                },
                new LineProfile()
                {
                    new PanelProfile(ObjectAlign.l)
                    {
                        new LineProfile()
                        {
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.l,
                                label = ProfileTabLabels.FirstName,
                                text = "First Name:",
                                tooltip = "The first name or given name of your character.",
                                OnTextChanged = (text) => valueUpdater(ProfileTabLabels.FirstName, text),
                            },
                        },
                        new LineProfile()
                        {
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.l,
                                label = ProfileTabLabels.LastName,
                                text = "Last Name:",
                                tooltip = "The last name of your character.",
                                OnTextChanged = (text) => valueUpdater(ProfileTabLabels.LastName, text),
                            },
                        },
                    },
                    new PanelProfile(ObjectAlign.l)
                    {
                        new LineProfile()
                        {
                            new EditBoxProfile()
                            {
                                align = ObjectAlign.r,
                                label = ProfileTabLabels.MiddleNames,
                                text = "Middle Name(s):",
                                tooltip = "Eventual middle name(s) of your character.",
                                OnTextChanged = (text) => valueUpdater(ProfileTabLabels.MiddleNames, text),
                            },
                        },
                        new LineProfile()
                        {
                            /*new ButtonProfile()
                            {
                                align = ObjectAlign.r,
                                text = "Add Extra Fields",
                                tooltip = "Click to add additional fields, such as title, nick name or others.",
                                onClick = () => {},
                                height = 26,
                            }*/
                        },
                    },
                },
                new LineProfile()
                {
                    new PanelProfile(ObjectAlign.l)
                    {
                        label = ProfileTabLabels.AdditionalFieldsPanel,
                    }
                },
                new LineProfile()
                {
                    /*
                    new EditFieldProfile()
                    {
                        align = ObjectAlign.l,
                        text = "Appearance:",
                        label = ProfileTabLabels.Appearance,
                    } */
                },
                new LineProfile()
                {
                    new TextProfile()
                    {
                        align = ObjectAlign.l,
                        text = "Tip: Shift click GHI items to link them in the apperance text.",
                        color = TextColor.white,
                    }
                },
            };
        }
    }
}
