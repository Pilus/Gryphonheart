

namespace GHF.View
{
    using System;
    using System.Collections.Generic;
    using CharacterMenuProfile;

    using GH.Menu.Containers.Line;
    using GH.Menu.Containers.Page;
    using GH.Menu.Objects;
    using GH.Menu.Objects.DropDown;
    using GH.Menu.Objects.DropDown.ButtonWithDropDown;
    using GH.Menu.Objects.Dummy;
    using GH.Menu.Objects.EditBox;
    using GH.Menu.Objects.EditField;
    using GH.Menu.Objects.Panel;
    using GHF.View.CharacterMenuProfile.CharacterList;
    using Model.AdditionalFields;

    public class ProfileTabProfileGenerator
    {
        public PageProfile GenerateProfile(Action<string, object> valueUpdater, Func<Dictionary<IField, Action>> getAvailableAdditionalFieldActions)
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
                            new ButtonWithDropDownProfile()
                            {
                                align = ObjectAlign.r,
                                text = "Add Additional Fields",
                                tooltip = "Click to add additional fields, such as title, nick name or others.",
                                height = 26,
                                width = 120,
                                dataFunc = () => {
                                    var fields = getAvailableAdditionalFieldActions();
                                    var data = new List<DropDownData>();
                                    foreach (var fieldPair in fields)
                                    {
                                        data.Add(new DropDownData(fieldPair.Key.Title, fieldPair.Value));
                                    }
                                    return data;
                                },
                            } 
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
                    new EditFieldProfile()
                    {
                        align = ObjectAlign.l,
                        text = "Appearance:",
                        label = ProfileTabLabels.Appearance,
                    }
                },
                /* TODO: Reenable when link of GHI item in appearance is implemented.
                new LineProfile()
                {
                    new TextProfile()
                    {
                        align = ObjectAlign.l,
                        text = "Tip: Shift click GHI items to link them in the apperance text.",
                        color = TextColor.white,
                    }
                }, */
            };
        }
    }
}
