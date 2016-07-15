namespace WoWSimulator.UISimulation.XMLHandler
{
    using System.IO;
    using System.Xml;
    using System.Xml.Serialization;

    public static class XmlUiLoader
    {
        private static StringWriter stringWriter;
        public static Ui Load(string xmlFilePath)
        {
            var stream = new FileStream(xmlFilePath, FileMode.Open, FileAccess.Read, FileShare.Read);

            var serializer = new XmlSerializer(typeof(Ui));
            serializer.UnknownAttribute += Serializer_UnknownAttribute;
            serializer.UnknownElement += Serializer_UnknownElement;
            serializer.UnknownNode += serializer_UnknownNode;

            stringWriter = new StringWriter();

            var ui = (Ui)serializer.Deserialize(stream);
            stream.Close();

            var errors = stringWriter.ToString();
            if (errors.Length > 0)
            {
                throw new UiSimuationException(string.Format("Errors loading xml:\nFile: {0}\n{1}", xmlFilePath, errors));
            }

            return ui;
        }

        private static void Serializer_UnknownElement(object sender, XmlElementEventArgs e)
        {

            stringWriter.WriteLine("Unknown Element");
            stringWriter.WriteLine(e.Element.Name + " " + e.Element.InnerXml);
            stringWriter.WriteLine("LineNumber: " + e.LineNumber);
            stringWriter.WriteLine("LinePosition: " + e.LinePosition);
            stringWriter.WriteLine(sender.ToString());
            stringWriter.WriteLine("");
        }

        private static void Serializer_UnknownAttribute(object sender, XmlAttributeEventArgs e)
        {
            if(e.Attr.Name.Equals("xsi:schemaLocation"))
            {
                return;
            }

            stringWriter.WriteLine("Unknown Attribute");
            stringWriter.WriteLine(e.Attr.Name + " " + e.Attr.InnerXml);
            stringWriter.WriteLine("LineNumber: " + e.LineNumber);
            stringWriter.WriteLine("LinePosition: " + e.LinePosition);
            stringWriter.WriteLine(sender.ToString());
            stringWriter.WriteLine("");
        }

        private static void serializer_UnknownNode(object sender, XmlNodeEventArgs e)
        {
            if (e.Name.Equals("xsi:schemaLocation"))
            {
                return;
            }

            stringWriter.WriteLine("UnknownNode Name: {0}", e.Name);
            stringWriter.WriteLine("UnknownNode LocalName: {0}", e.LocalName);
            stringWriter.WriteLine("UnknownNode Namespace URI: {0}", e.NamespaceURI);
            stringWriter.WriteLine("UnknownNode Text: {0}", e.Text);

            XmlNodeType myNodeType = e.NodeType;
            stringWriter.WriteLine("NodeType: {0}", myNodeType);

            stringWriter.WriteLine();
        }
    }
}