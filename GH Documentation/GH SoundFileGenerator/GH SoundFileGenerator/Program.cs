using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CrystalMpq;
using CrystalMpq.Utility;
using System.Reflection;

namespace GH_SoundFileGenerator
{
    class Program
    {
        static void Main(string[] args)
        {
            try {
                Console.WriteLine("Gryphonheart AddOns - Sound File Generator");

                var wowPath = "";
                var wowDataPath = "";
                try
                {
                    var wowInstallation = WoWInstallation.Find();
                    wowPath = wowInstallation.Path;
                    wowDataPath = wowInstallation.DataPath;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception when locating wow installation");
                    Console.WriteLine(ex.Message);

                    var WOWString = "World of Warcraft";
                    var exePath = Assembly.GetExecutingAssembly().Location;
                    if (!exePath.Contains(WOWString))
                    {
                        throw new Exception("Could not locate wow installation. Try executing the program within the wow directory");
                    }

                    wowPath = exePath.Substring(0, exePath.IndexOf(WOWString) + WOWString.Length);
                    wowDataPath = wowPath + @"\\Data";

                    Console.WriteLine("Assuming wow installation to be at " + wowPath);
                }               

                Console.WriteLine("Loading archieves.");
                var archieves = MPQLoader.LoadArchieves(wowDataPath);

                Console.WriteLine("Generating sound structure from MPQ.");
                var mpqReader = new MPQReader();
                Console.WriteLine("");
                var soundFolder = mpqReader.GenerateSoundFolders(archieves);
                Console.WriteLine("");

                Console.WriteLine("Analysing Sound Length.");
                Console.WriteLine("");
                var progressBar = new ProgressBar(mpqReader.soundsFound);
                var lengthAnalyser = new SoundLengthAnalyser();
                lengthAnalyser.progressFunc = progressBar.GetProgressFunc();

                soundFolder = lengthAnalyser.FillDuration(soundFolder);
                
                var fr = new FolderRestructurer();
                fr.OptimizeStructure(soundFolder);

                Console.WriteLine("Writing sound list.");
                var soundListWriter = new SoundListWriter(wowPath);
                soundListWriter.WriteToFile(soundFolder);

                Console.WriteLine("Sound list file created.");

                Console.WriteLine("Done");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception:");
                Console.WriteLine(ex.Message);
            }
            Console.WriteLine("Press any key to exit.");
            Console.ReadKey();
        }
    }
}
