namespace GHF.Model.MSP
{
    using System;
    using Lua;

    public interface ILibMSPWrapper
    {
        bool Update();
        /// <summary>
        /// Request fields from a player.
        /// </summary>
        /// <param name="player">Player name to query; if from a different realm, format should be "Name-Realm"</param>
        /// <param name="fields">Table of strings. Field to requests from the player.</param>
        /// <returns>Returns true if we sent them a request, and false if we didn't (because we either have it 
        /// recently cached already, or they didn't respond to our last request so might not support MSP).</returns>
        bool Request(string player, NativeLuaTable fields);
        bool Request(string player, string field);
        bool Request(string player);

        void SetMy(IMSPFields values);
        IMSPFields GetOthers(string player);
        void AddReceivedAction(Action<string> received);
        IMSPFields GetEmptyFieldsObj();
    }
}