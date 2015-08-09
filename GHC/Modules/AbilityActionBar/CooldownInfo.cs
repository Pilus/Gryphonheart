namespace GHC.Modules.AbilityActionBar
{
    
    public class CooldownInfo : ICooldownInfo
    {
        public double StartTime { get; set; }
        public int Duration { get; set; }
        public bool Active { get; set; }
    }
}