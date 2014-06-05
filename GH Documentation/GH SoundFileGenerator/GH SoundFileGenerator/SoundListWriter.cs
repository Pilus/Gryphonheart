using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GH_SoundFileGenerator
{
    class SoundListWriter
    {
        private string wowFolder;

        public SoundListWriter(string wowFolder)
        {
            this.wowFolder = wowFolder;
        }

        string SoundFileToString(SoundFile sound)
        {
            return string.Format(CultureInfo.InvariantCulture, "[\"{0}\"] = {1:00.00},", sound.name, sound.duration);
        }

        List<string> GetFolderAsLuaTable(Folder folder)
        {
            List<string> list = new List<string>();
            list.Add(String.Format("[\"{0}\"] = ", folder.name) + "{");
            foreach (Folder subFolder in folder.folders)
            {
                List<string> subList = GetFolderAsLuaTable(subFolder);
                foreach (string line in subList)
                {
                    list.Add("\t" + line);
                }
            }
            foreach (SoundFile sound in folder.sounds)
            {
                list.Add("\t" + SoundFileToString(sound));
            }

            list.Add("},");

            return list;
        }

        public void WriteToFile(Folder folder)
        {
            StreamReader templateFile = new StreamReader(string.Format(@"{0}\Interface\AddOns\GH Documentation\SoundFileTemplate.lua", this.wowFolder));
            StreamWriter outputFile = new StreamWriter(string.Format(@"{0}\Interface\AddOns\GHM\Objects\GHM_SoundList.lua", this.wowFolder), false);

            string s = templateFile.ReadLine();
            while (s != "--LIST--")
            {
                outputFile.WriteLine(s);
                s = templateFile.ReadLine();
            }

            outputFile.WriteLine("\tGHM_SoundList = {");
            List<string> list = GetFolderAsLuaTable(folder);
            foreach (string line in list)
            {
                outputFile.WriteLine("\t\t" + line);
            }
            outputFile.WriteLine("\t};");

            s = templateFile.ReadLine();
            while (s != null)
            {
                outputFile.WriteLine(s);
                s = templateFile.ReadLine();
            }

            outputFile.Close();
        }
    }
}
