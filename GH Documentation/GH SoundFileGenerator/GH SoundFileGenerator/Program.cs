using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CrystalMpq;
using CrystalMpq.Utility;

namespace GH_SoundFileGenerator
{
    class Program
    {
        static void Main(string[] args)
        {
            try {
                Console.WriteLine("Gryphonheart AddOns - Sound File Generator");

                var wowInstallation = WoWInstallation.Find();
                if (wowInstallation == null)
                {
                    throw new Exception("No wow installation found");
                }

                Console.WriteLine("Loading archieves.");
                var archieves = MPQLoader.LoadArchieves(wowInstallation.DataPath);

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
                var soundListWriter = new SoundListWriter(wowInstallation.Path);
                soundListWriter.WriteToFile(soundFolder);

                Console.WriteLine("Sound list file created.");

                Console.WriteLine("Done");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            Console.WriteLine("Press any key to exit.");
            Console.ReadKey();
        }
    }
}
