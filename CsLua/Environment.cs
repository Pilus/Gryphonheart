namespace CsLua
{
    using System;

    public static class Environment
    {
        public static bool IsExecutingInGame {
            get {
                return false;
            }
        }

        public static void ExecuteLuaCode(string code)
        {
            throw new Exception("Lua code an only be executed in-game.");
        }
    }
}