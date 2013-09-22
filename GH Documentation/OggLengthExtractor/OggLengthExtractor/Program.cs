using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.ComponentModel;
using System.IO;



namespace OggLengthExtractor {
    
    

    class Program {
        

        static void Main(string[] args) {
            //OggFileAnalyzer converter = new OggFileAnalyzer();
            //Double dur = converter.GetDuration(@"C:\Games\World of Warcraft\Interface\Old\PowerAuras\Sounds\Squeakypig.ogg");

            Console.WriteLine("GHI Sound list creator");
            Console.WriteLine("Copyright of the Gryphonheart Team. 2012");
            Console.WriteLine("Prerequirement:");
            Console.WriteLine("- Extract all sound files into C:\\Games\\WoW Sounds ...");
            Console.WriteLine("");
            Console.WriteLine("Press any key to start the sound list creation");
            Console.ReadKey();
            Console.WriteLine("");


            
            
            FolderStructure FS = new FolderStructure();

            Folder fMain = FS.CreateFolderStructure(new DirectoryInfo(@"C:\Games\WoW Sounds\Sound"));
            
            /*FS.MergeFolders(fMain, FS.CreateFolderStructure(new DirectoryInfo(@"C:\Games\WoW Sounds\base\Sound")));
            FS.MergeFolders(fMain, FS.CreateFolderStructure(new DirectoryInfo(@"C:\Games\WoW Sounds\deDE\Sound"))); 
            FS.MergeFolders(fMain, FS.CreateFolderStructure(new DirectoryInfo(@"C:\Games\WoW Sounds\enGB\Sound"))); 
            FS.MergeFolders(fMain, FS.CreateFolderStructure(new DirectoryInfo(@"C:\Games\WoW Sounds\esES\Sound")));
            FS.MergeFolders(fMain, FS.CreateFolderStructure(new DirectoryInfo(@"C:\Games\WoW Sounds\frFR\Sound"))); 
            FS.MergeFolders(fMain, FS.CreateFolderStructure(new DirectoryInfo(@"C:\Games\WoW Sounds\ruRU\Sound"))); */
            

            FolderRestructurer FR = new FolderRestructurer();
            FR.OptimizeStructure(fMain);
            
            SoundListWriter SLW = new SoundListWriter();
            SLW.WriteToFile(fMain);

            Console.ReadKey();
        }
        


    }
}

