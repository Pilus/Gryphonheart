namespace GH.ObjectHandling.Storage
{
    public class DataNotLoadedException : BaseException
    {
        public DataNotLoadedException() : base("It is not possible to interact with objects before the saved data is loaded.")
        {
        }
    }
}