using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GH_SoundFileGenerator
{
    class FolderRestructurer
    {
        Folder GetSubfolder(Folder folder, string subfolderName)
        {
            foreach (Folder subFolder in folder.folders)
            {
                if (subFolder.name.ToLower().Equals(subfolderName.ToLower()))
                {
                    return subFolder;
                }
            }
            Folder newFolder = new Folder();
            newFolder.name = subfolderName;
            newFolder.folders = new List<Folder>();
            newFolder.sounds = new List<SoundFile>();
            folder.folders.Add(newFolder);
            return newFolder;
        }

        void OptimizeFolder(Folder folder)
        {
            List<Folder> foldersToRemove = new List<Folder>();
            for (int i = 0; i < folder.folders.Count; i++)
            {
                Folder subFolder = folder.folders[i];

                if (subFolder.folders.Count == 1 && subFolder.sounds.Count == 0)
                {
                    Folder newSubfolder = subFolder.folders[0];
                    newSubfolder.name = subFolder.name + newSubfolder.name;
                    folder.folders[i] = newSubfolder;
                }

                subFolder = folder.folders[i];
                OptimizeFolder(subFolder);

                if (subFolder.folders.Count == 0 && subFolder.sounds.Count == 1)
                {
                    SoundFile soundFile = subFolder.sounds[0];
                    soundFile.name = subFolder.name + soundFile.name;
                    folder.sounds.Add(soundFile);
                    foldersToRemove.Add(subFolder);
                }
            }
            foreach (Folder subFolder in foldersToRemove)
            {
                folder.folders.Remove(subFolder);
            }
        }

        void CreateSubfoldersFromUnderscore(Folder folder)
        {
            List<SoundFile> SoundsToRemove = new List<SoundFile>();

            foreach (SoundFile sound in folder.sounds)
            {
                if (sound.name.Contains("_"))
                {
                    int splitI = sound.name.IndexOf("_") + 1;
                    string newSubName = sound.name.Substring(0, splitI);

                    SoundFile newSound = new SoundFile();
                    newSound.name = sound.name.Substring(splitI);
                    newSound.duration = sound.duration;

                    Folder newFolder = GetSubfolder(folder, newSubName);
                    newFolder.sounds.Add(newSound);
                    SoundsToRemove.Add(sound);
                }
            }
            foreach (SoundFile sound in SoundsToRemove)
            {
                folder.sounds.Remove(sound);
            }

            foreach (Folder subFolder in folder.folders)
            {
                CreateSubfoldersFromUnderscore(subFolder);
            }
        }

        void RemoveEmptyFolder(Folder folder)
        {
            List<Folder> foldersToBeRemoved = new List<Folder>();
            foreach (Folder subfolder in folder.folders)
            {
                RemoveEmptyFolder(subfolder);
                if (subfolder.folders.Count == 0 && subfolder.sounds.Count == 0)
                {
                    foldersToBeRemoved.Add(subfolder);
                }
            }
            foreach (Folder subFolder in foldersToBeRemoved)
            {
                folder.folders.Remove(subFolder);
            }
        }

        public void OptimizeStructure(Folder folder)
        {
            CreateSubfoldersFromUnderscore(folder);
            OptimizeFolder(folder);
        }
    }
}
