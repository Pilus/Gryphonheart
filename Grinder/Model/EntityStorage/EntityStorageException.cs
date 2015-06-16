namespace Grinder.Model.EntityStorage
{
    using CsLua;

    public class EntityStorageException : CsException
    {
        public EntityStorageException(string msg) : base(msg) { }
    }
}