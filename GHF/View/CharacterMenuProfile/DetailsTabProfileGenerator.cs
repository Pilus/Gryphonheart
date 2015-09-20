
namespace GHF.View.CharacterMenuProfile
{
    using System;
    using CsLua.Collection;
    using GH.Menu;
    using GH.Menu.Objects;
    using GH.Menu.Objects.DropDown;
    using GH.Menu.Objects.DropDown.ButtonWithDropDown;
    using GH.Menu.Objects.Dummy;
    using GH.Menu.Objects.EditField;
    using GH.Menu.Objects.Line;
    using GH.Menu.Objects.Page;
    using GH.Menu.Objects.Panel;
    using GH.Menu.Objects.Text;
    using GHF.View.CharacterMenuProfile.CharacterList;

    public static class DetailsTabProfileGenerator
    {
        public static PageProfile GenerateProfile(Func<string, bool> IsFieldAdded)
        {
            return new PageProfile("Details")
            {
                new LineProfile()
                {
                    new DummyProfile()
                    {
                        height = CharacterListToggleObject.Height,
                        width = CharacterListToggleObject.Width,
                    }
                },
                new LineProfile()
                {
                    new TextProfile()
                    {
                        align = ObjectAlign.l,
                        text = "The information on this page is not shared with other players.",
                        color = TextColor.white,
                    }
                },
                new LineProfile()
                {
                    new EditFieldProfile()
                    {
                        align = ObjectAlign.l,
                        text = "Background:",
                        label = DetailsTabLabels.Background,
                    }
                },
                /*new LineProfile()
                {
                    new ButtonWithDropDownProfile()
                    {
                        align = ObjectAlign.r,
                        text = "Add Extra Details",
                        tooltip = "Click to add additional details, such as goals and current location.",
                        height = 26,
                        width = 120,
                        dataFunc = () => {
                            return GenerateDropDownData(IsFieldAdded, AddAdditionalField);
                        },
                    } 
                }, //*/
                new LineProfile()
                {
                    new PanelProfile(ObjectAlign.l)
                    {
                        label = DetailsTabLabels.AdditionalDetailsPanel
                    }
                },
            };
        }

        public static string GetLocalizedFieldName(string label)
        {
            switch (label)
            {
                case DetailsTabLabels.Goals:
                    return "Goals";
                default:
                    return label;
            }
        }

        public static CsLuaList<string> GetDefaultFields()
        {
            return new CsLuaList<string>()
            {
                DetailsTabLabels.Goals,
            };
        }

        public static IObjectProfile GetFieldProfile(string label)
        {
            return new EditFieldProfile()
            {
                align = ObjectAlign.l,
                text = GetLocalizedFieldName(label) + ":",
                label = label,
            };
        }

        private static CsLuaList<DropDownData> GenerateDropDownData(Func<string, bool> IsFieldAdded, Action<string> AddAdditionalField)
        {
            var list = new CsLuaList<DropDownData>();

            foreach (var fieldLabel in GetDefaultFields())
            {
                list.Add(new DropDownData()
                {
                    value = fieldLabel,
                    text = GetLocalizedFieldName(fieldLabel) + ":",
                    disabled = IsFieldAdded(fieldLabel),
                    onSelect = () => AddAdditionalField(fieldLabel)
                });
            }

            list.Add(new DropDownData()
            {
                value = "new",
                text = "Custom detail field...",
                onSelect = () =>
                {
                    throw new NotImplementedException();
                }
            });

            return list;
        }
    }
}
