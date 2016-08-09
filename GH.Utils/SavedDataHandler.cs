namespace GH.Utils
{
    using BlizzardApi.Global;
    using Lua;

    public class SavedDataHandler : ISavedDataHandler
    {
        private readonly string tableName;
        private readonly string subTableName;

        public SavedDataHandler(string tableName)
        {
            this.tableName = tableName;
            this.subTableName = null;
        }

        public SavedDataHandler(string tableName, string subTableName)
        {
            this.tableName = tableName;
            this.subTableName = subTableName;
        }

        public NativeLuaTable GetVar(object index)
        {
            var dataTable = this.GetAll();
            return dataTable[index] as NativeLuaTable;
        }

        public void SetVar(object index, NativeLuaTable obj)
        {
            var dataTable = this.GetAll();
            dataTable[index] = obj;
        }

        public NativeLuaTable GetAll()
        {
            var dataTable = Global.Api.GetGlobal(this.tableName) as NativeLuaTable;
            if (dataTable == null)
            {
                dataTable = new NativeLuaTable();
                Global.Api.SetGlobal(this.tableName, dataTable);
            }

            if (this.subTableName == null)
            {
                return dataTable;
            }

            if (dataTable[this.subTableName] == null)
            {
                dataTable[this.subTableName] = new NativeLuaTable();
            }

            return (NativeLuaTable) dataTable[this.subTableName];            
        }
    }
}