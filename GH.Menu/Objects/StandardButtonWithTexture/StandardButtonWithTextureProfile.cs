namespace GH.Menu.Objects.StandardButtonWithTexture
{
    using System;

    public class StandardButtonWithTextureProfile : IObjectProfile
    {
        public StandardButtonWithTextureProfile()
        {
            this.align = ObjectAlign.l;
        }

        public string type { get { return "StandardButtonWithTexture"; } }

        public string label { get; set; }

        public ObjectAlign align { get; set; }

        public string tooltip { get; set; }

        public string texture { get; set; }

        public double[] texCoord { get; set; }

        public Action onClick { get; set; }
    }
}
