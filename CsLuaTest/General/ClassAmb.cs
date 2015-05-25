namespace CsLuaTest.General
{
    public class ClassAmb
    {
        private string ambValue;

        public ClassAmb(string ambValue)
        {
            this.ambValue = ambValue;
        }

        public string GetAmbValue()
        {
            return this.ambValue;
        }

        public void SetAmbValue(string ambValue)
        {
            this.ambValue = ambValue;
        }
    }
}