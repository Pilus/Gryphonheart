namespace GHC.Modules.AbilityActionBar
{
    
    public interface ICooldownInfo
    {
        double StartTime { get; }
        int Duration { get; }
        bool Active { get; }
    }
}
