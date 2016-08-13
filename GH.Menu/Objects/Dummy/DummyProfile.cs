
namespace GH.Menu.Objects.Dummy
{

    public class DummyProfile : IObjectProfile
    {
        public string type { get { return DummyObject.Type; } }
        public string label { get; set; }
        public ObjectAlign align { get; set; }

        public double? height { get; set; }

        public double? width { get; set; }
    }
}
