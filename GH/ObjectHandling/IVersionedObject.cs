namespace GH.ObjectHandling
{
    public interface IVersionedObject
    {
        long Version { get; set; }
    }
}