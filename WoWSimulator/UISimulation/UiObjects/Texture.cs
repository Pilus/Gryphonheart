namespace WoWSimulator.UISimulation.UiObjects
{
    using System;
    using BlizzardApi.WidgetEnums;
    using BlizzardApi.WidgetInterfaces;
    using CsLuaFramework.Wrapping;
    using XMLHandler;

    public class Texture : Region, ITexture
    {
        private DrawLayer layer;
        private string texturePath;

        public Texture(UiInitUtil util, string objectType, TextureType type, IRegion parent)
            : base(util, objectType, type, parent)
        {
            if (!string.IsNullOrEmpty(type.inherits))
            {
                this.ApplyType((TextureType)util.GetTemplate(type.inherits));
            }
            this.ApplyType(type);
        }

        private void ApplyType(TextureType type)
        {
            if (!string.IsNullOrEmpty(type.file)) this.SetTexture(type.file);
        }

        public DrawLayer GetDrawLayer()
        {
            return this.layer;
        }

        public void SetDrawLayer(DrawLayer layer)
        {
            this.layer = layer;
        }

        public AlphaMode GetBlendMode()
        {
            throw new NotImplementedException();
        }

        public IMultipleValues<double, double, double, double, double, double, double, double> GetTexCoord()
        {
            throw new NotImplementedException();
        }

        public string GetTexture()
        {
            return this.texturePath;
        }

        public IMultipleValues<double, double, double, double> GetVertexColor()
        {
            throw new NotImplementedException();
        }

        public int IsDesaturated()
        {
            throw new NotImplementedException();
        }

        public void SetBlendMode(AlphaMode mode)
        {
            throw new NotImplementedException();
        }

        public bool SetDesaturated(int flag)
        {
            throw new NotImplementedException();
        }

        public void SetGradient(Orientation orientation, double minR, double minG, double minB, double maxR, double maxG, double maxB)
        {
            throw new NotImplementedException();
        }

        public void SetGradientAlpha(Orientation orientation, double minR, double minG, double minB, double minA, double maxR, double maxG, double maxB, double maxA)
        {
            throw new NotImplementedException();
        }

        public void SetRotation(double angle)
        {
            throw new NotImplementedException();
        }

        public void SetRotation(double angle, double cx, double cy)
        {
            throw new NotImplementedException();
        }

        public void SetTexCoord(double minX, double maxX, double minY, double maxY)
        {
            //throw new System.NotImplementedException();
        }

        public void SetTexCoord(double ULx, double ULy, double LLx, double LLy, double URx, double URy, double LRx, double LRy)
        {
            throw new NotImplementedException();
        }

        public void SetTexture(string texturePath)
        {
            this.texturePath = texturePath;
        }

        public void SetTexture(double r, double g, double b)
        {
            //throw new System.NotImplementedException();
        }

        public void SetTexture(double r, double g, double b, double a)
        {
            throw new NotImplementedException();
        }


        public void SetVertexColor(double r, double g, double b)
        {
            //throw new System.NotImplementedException();
        }

        public void SetVertexColor(double r, double g, double b, double alpha)
        {
            throw new NotImplementedException();
        }
    }
}