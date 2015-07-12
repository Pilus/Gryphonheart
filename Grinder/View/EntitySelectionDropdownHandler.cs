namespace Grinder.View
{
    using BlizzardApi.Global;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLua.Collection;
    using Lua;

    public class EntitySelectionDropdownHandler : IEntitySelectionDropdownHandler
    {
        private IFrame menuFrame;

        public EntitySelectionDropdownHandler()
        {
            this.menuFrame = (IFrame)Global.FrameProvider.CreateFrame(FrameType.Frame, "GrinderEntitySelectionMenu", Global.Frames.UIParent, "UIDropDownMenuTemplate");
        }

        public void Show(IFrame anchor, IEntitySelection selection)
        {
            var menuTable = CreateMenuTable(selection);
            Global.FrameProvider.EasyMenu(menuTable, this.menuFrame, anchor, 0, 0, "MENU");
        }

        private static NativeLuaTable CreateMenuTable(IEntitySelection selection)
        {
            var menuTable = new NativeLuaTable();
            Table.insert(menuTable, GenerateTitleMenuTableEntry());

            foreach (var entityCategory in selection)
            {
                Table.insert(menuTable, GenerateEntryForEntityType(entityCategory.Key, entityCategory.Value));
            }

            return menuTable;
        }

        private static NativeLuaTable GenerateTitleMenuTableEntry()
        {
            var titleEntry = new NativeLuaTable();

            titleEntry["isTitle"] = true;
            titleEntry["text"] = "Select an entity to track";

            return titleEntry;
        }

        private static NativeLuaTable GenerateEntryForEntityType(string entityTypeName, CsLuaList<ITrackableEntity> entities)
        {
            var entry = new NativeLuaTable();

            entry["hasArrow"] = true;
            entry["text"] = entityTypeName;
            entry["menuList"] = GenerateMenuListForEntities(entities);

            return entry;
        }

        private static NativeLuaTable GenerateMenuListForEntities(CsLuaList<ITrackableEntity> entities)
        {
            var menuList = new NativeLuaTable();

            foreach (var entity in entities)
            {
                Table.insert(menuList, GenerateEntryForEntity(entity));
            }

            return menuList;
        }

        private static NativeLuaTable GenerateEntryForEntity(ITrackableEntity entity)
        {
            var entry = new NativeLuaTable();

            entry["text"] = entity.Name;
            entry["icon"] = entity.IconPath;
            entry["func"] = entity.OnSelect;

            return entry;
        }
    }
}