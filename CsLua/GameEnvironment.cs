namespace CsLua
{
    using System;

    public static class GameEnvironment
    {
        public static bool IsExecutingInGame {
            get {
                return false;
            }
        }

        public static void ExecuteLuaCode(string code)
        {
            throw new Exception("Lua code can only be executed in-game.");
        }
    }
}