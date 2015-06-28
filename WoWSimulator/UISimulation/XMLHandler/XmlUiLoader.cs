namespace WoWSimulator.UISimulation.XMLHandler
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Xml.Serialization;

    public static class XmlUiLoader
    {
        public static Ui Load(string xmlFilePath)
        {
            var stream = new FileStream(xmlFilePath, FileMode.Open, FileAccess.Read, FileShare.Read);

            var serializer = new XmlSerializer(typeof(Ui));

            var ui = (Ui)serializer.Deserialize(stream);
            stream.Close();

            return ui;
        }
    }
}