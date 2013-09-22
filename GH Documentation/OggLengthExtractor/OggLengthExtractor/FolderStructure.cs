using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using HundredMilesSoftware.UltraID3Lib;
using System.Text.RegularExpressions;

namespace OggLengthExtractor {

    struct SoundFile {
        public string name;
        public double duration;
    }

    struct Folder {
        public string name;
        public List<Folder> folders;
        public List<SoundFile> sounds;
    }

    class FolderStructure {
        
        DurationAnalyzer durationAnalyzer = new DurationAnalyzer();
        int totalAdded = 0;
        int lastPrintout = 0;

        public Folder CreateFolderStructure(DirectoryInfo dir) {
            
            Folder folder = new Folder();
            folder.folders = new List<Folder>();
            folder.sounds = new List<SoundFile>();
            folder.name = dir.Name+"\\\\";

            foreach (DirectoryInfo subDir in dir.GetDirectories()) {
                folder.folders.Add(CreateFolderStructure(subDir));
            }

            foreach (FileInfo file in dir.GetFiles()) {
                string fileName = file.Name.Replace(file.Extension, "");

                bool exists = false;
                foreach (SoundFile sound in folder.sounds) {
                    if (sound.name.ToLower().Equals(fileName.ToLower())) {
                        exists = true;
                        break;
                    }
                }

                if (exists == false && file.Extension.ToLower().Equals(".ogg")) {
                    SoundFile sf = new SoundFile();
                    sf.duration = durationAnalyzer.GetOggDuration(file.FullName);
                    sf.name = fileName; 
                    folder.sounds.Add(sf);
                }
                else if (exists == false &&  file.Extension.ToLower().Equals(".mp3")) {
                    
                    SoundFile sf = new SoundFile();
                    sf.duration = durationAnalyzer.GetMp3Duration(file.FullName);
                    sf.name = fileName;
                    folder.sounds.Add(sf);
                }
            }

            totalAdded += folder.sounds.Count;
            if (totalAdded - lastPrintout >= 1000) {
                Console.WriteLine(totalAdded);
                lastPrintout = totalAdded;
            }
            
            return folder;
        }

        public void MergeFolders(Folder folderA, Folder folderB) {
            foreach (Folder fB in folderB.folders) {
                bool found = false;
                foreach (Folder fA in folderA.folders) {
                    if (fA.name.ToLower().Equals(fB.name.ToLower())) {
                        found = true;

                        MergeFolders(fA, fB);

                        break;
                    }
                }
                if (found == false) {
                    folderA.folders.Add(fB);
                }
            }
            foreach (SoundFile sB in folderB.sounds) {
                bool found = false;
                foreach (SoundFile sA in folderA.sounds) {
                    if (sA.name.ToLower().Equals(sB.name.ToLower())) {
                        found = true;
                        break;
                    }
                }
                if (found == false) {
                    folderA.sounds.Add(sB);
                }
            }

        }
    }
}
