
namespace GHG.Model
{
    using Lua;
    using System;

    [Serializable]
    class LogEvent
    {
        public LogEvent(LogEventType type, string author, string[] args)
        {
            this.Type = type;
            this.Author = author;
            this.Args = args;
            this.TimeStamp = Core.time();
        }

        public LogEventType Type
        {
            get;
            private set;
        }

        public double TimeStamp
        {
            get;
            private set;
        }

        public string Author
        {
            get;
            private set;
        }

        public string[] Args
        {
            get;
            private set;
        }
    }
}
