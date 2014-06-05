using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CrystalMpq;
using CrystalMpq.Utility;

namespace GH_SoundFileGenerator
{
    class MPQReader
    {
        private string[] soundFileFormats = { ".mp3", ".wav", ".ogg" };

        public int soundsFound = 0;

        private Func<bool> progressFunc;

        public Folder GenerateSoundFolders(IEnumerable<MpqArchive> archieves)
        {
            var progressBar = new ProgressBar(this.CountSoundFiles(archieves));
            progressFunc = progressBar.GetProgressFunc();

            var folder = new Folder();

            foreach (var archive in archieves)
            {
                var folderFromArchieve = GenerateSoundFolders(archive);
                MergeFolders(folder, folderFromArchieve);
            }

            return folder;
        }

        private int CountSoundFiles(IEnumerable<MpqArchive> archieves)
        {
            var c = 0;
            foreach (var archieve in archieves)
            {
                foreach (var file in archieve.Files)
                {
                    if (soundFileFormats.Contains(GetExtensionFromPath(file.Name)))
                    {
                        c++;
                    }
                }
            }
            return c;
        }

        public Folder GenerateSoundFolders(MpqArchive archive)
        {
            var folder = new Folder();

            var soundFiles = archive.Files.Where(file => soundFileFormats.Contains(GetExtensionFromPath(file.Name)));           

            foreach (var file in soundFiles)
            {
                AddSoundToFolderSystem(folder, file, 0);
                progressFunc();
            }
            
            return folder;
        }


        private string GetExtensionFromPath(string path)
        {
            if (path.Contains("."))
            {
                return path.Substring(path.LastIndexOf(".")).ToLower();
            }
            return string.Empty;
        }

        private void AddSoundToFolderSystem(Folder folder, MpqFile file, int offset)
        {
            if (file.Name.IndexOf("\\", offset) >= 0)
            {
                var splitOffset = file.Name.IndexOf("\\", offset);
                var folderName = file.Name.Substring(offset, splitOffset - offset);
                var subFolder = folder.folders.Where(f => f.name == folderName).FirstOrDefault();
                if (subFolder == null)
                {
                    subFolder = new Folder();
                    subFolder.name = folderName + "\\\\";
                    folder.folders.Add(subFolder);
                }
                var remainingPath = file.Name.Substring(file.Name.IndexOf("\\") + 1);
                AddSoundToFolderSystem(subFolder, file, splitOffset + 1);
            }
            else
            {
                var soundFile = new SoundFile();
                soundFile.name = file.Name.Substring(offset);
                soundFile.file = file;
                folder.sounds.Add(soundFile);
                soundsFound++;
            }
        }

        private void MergeFolders(Folder folderA, Folder folderB)
        {
            foreach (Folder fB in folderB.folders)
            {
                bool found = false;
                foreach (Folder fA in folderA.folders)
                {
                    if (fA.name.ToLower().Equals(fB.name.ToLower()))
                    {
                        found = true;

                        MergeFolders(fA, fB);

                        break;
                    }
                }
                if (found == false)
                {
                    folderA.folders.Add(fB);
                }
            }
            foreach (SoundFile sB in folderB.sounds)
            {
                bool found = false;
                foreach (SoundFile sA in folderA.sounds)
                {
                    if (sA.name.ToLower().Equals(sB.name.ToLower()))
                    {
                        found = true;
                        break;
                    }
                }
                if (found == false)
                {
                    folderA.sounds.Add(sB);
                }
            }

        }
    }
}
