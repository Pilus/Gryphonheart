using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Globalization;

namespace OggLengthExtractor {
    class SoundListWriter {

        string SoundFileToString(SoundFile sound) {
            return string.Format(new CultureInfo("en-US"),"[\"{0}\"] = {1:00.00},", sound.name, sound.duration);
        }

        List<string> GetFolderAsLuaTable(Folder folder) {
            List<string> list = new List<string>();
            list.Add(String.Format("[\"{0}\"] = ",folder.name)+"{");
            foreach (Folder subFolder in folder.folders) {
                List<string> subList = GetFolderAsLuaTable(subFolder);
                foreach (string line in subList) {
                    list.Add("\t" + line);
                }
            }
            foreach (SoundFile sound in folder.sounds) {
                list.Add("\t" + SoundFileToString(sound));
            }

            list.Add("},");

            return list;
        }

        public void WriteToFile(Folder folder) {
            StreamReader  templateFile = new StreamReader (@"C:\Games\WoW Sounds\SoundFileTemplate.lua");
            StreamWriter outputFile = new StreamWriter(@"C:\Games\WoW Sounds\GHM_SoundList.lua",false);

            string s = templateFile.ReadLine();
            while (s != "--LIST--") {
                outputFile.WriteLine(s);
                s = templateFile.ReadLine();
            }

            outputFile.WriteLine("\tGHM_SoundList = {");
            List<string> list = GetFolderAsLuaTable(folder);
            foreach (string line in list) {
                outputFile.WriteLine("\t\t" + line);
            }
            outputFile.WriteLine("\t};");

            s = templateFile.ReadLine();
            while (s != null) {
                outputFile.WriteLine(s);
                s = templateFile.ReadLine();
            }

            outputFile.Close();
            Console.WriteLine("Sound list file created");
        }
    }
}
