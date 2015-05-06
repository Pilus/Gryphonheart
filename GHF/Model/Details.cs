namespace GHF.Model
{
    using System;

    [Serializable]
    public class Details : IDetails
    {
        public string Background { get; set; }
        public string Goals { get; set; }
        public string CurrentLocation { get; set; }

    }
}