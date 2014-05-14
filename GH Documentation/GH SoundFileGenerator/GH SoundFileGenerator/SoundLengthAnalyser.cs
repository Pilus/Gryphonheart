using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using CrystalMpq;
using CrystalMpq.Utility;
using OggVorbisDecoder;
using HundredMilesSoftware.UltraID3Lib;

namespace GH_SoundFileGenerator
{
    class SoundLengthAnalyser
    {

        public Func<bool> progressFunc;
        public Dictionary<double, double> mp3SoundLengths;
        public Dictionary<double, double> oggSoundLengths;
        public int failedSounds;

        public SoundLengthAnalyser()
        {
            this.mp3SoundLengths = new Dictionary<double, double>();
            this.oggSoundLengths = new Dictionary<double, double>();
            this.failedSounds = 0;
        }

        public Folder FillDuration(Folder folder)
        {
            var newFolder = new Folder();
            newFolder.name = folder.name;
            foreach (var subFolder in folder.folders)
            {
                newFolder.folders.Add(FillDuration(subFolder));
            }

            foreach (var soundFile in folder.sounds)
            {
                newFolder.sounds.Add(FillDuration(soundFile));
            }
            return newFolder;
        }

        SoundFile FillDuration(SoundFile sound)
        {
            if (sound.duration == 0)
            {
                var size = sound.file.Size;
                switch (this.GetExtensionFromPath(sound.name))
                {
                    case ".ogg":
                        sound.duration = (0.0002 * size) - 0.3996;
                        break;
                    case ".mp3":
                        sound.duration = (0.00005 * size) + 1.1362;
                        break;
                    default:
                        throw new Exception(string.Format("Can not determine duration of type {0}.", GetExtensionFromPath(sound.name)));
                }                
            }
            progressFunc();
            return sound;
        }

        private string GetExtensionFromPath(string path)
        {
            if (path.Contains("."))
            {
                return path.Substring(path.LastIndexOf(".")).ToLower();
            }
            return string.Empty;
        }

        /*
        SoundFile FillDuration(SoundFile sound)
        {
            if (sound.duration == 0)
            {
                var tempFilePath = string.Empty;
                var pathAssigned = false;
                try
                {
                    var stream = sound.file.Open();
                    tempFilePath = WriteSteamToTempFile(stream);
                    pathAssigned = true;

                    switch (GetExtensionFromPath(sound.name))
                    {
                        case ".ogg":
                            sound.duration = GetOggDuration(tempFilePath);
                            this.oggSoundLengths[sound.file.Size] = sound.duration;
                            break;
                        case ".mp3":
                            sound.duration = GetMp3Duration(tempFilePath);
                            this.mp3SoundLengths[sound.file.Size] = sound.duration;
                            break;
                        default:
                            throw new Exception(string.Format("Can not determine duration of type {0}.", GetExtensionFromPath(sound.name)));
                    }

                    
                    progressFunc();
                }
                catch (Exception)
                {
                    switch (GetExtensionFromPath(sound.name))
                    {
                        case ".ogg":
                            
                            if (this.oggSoundLengths.Keys.Contains(sound.file.Size))
                            {
                                sound.duration = this.oggSoundLengths[sound.file.Size]; 
                            }
                            else 
                            {
                                failedSounds++;
                            }   
                            break;
                        case ".mp3":
                            if (this.mp3SoundLengths.Keys.Contains(sound.file.Size))
                            {
                                sound.duration = this.mp3SoundLengths[sound.file.Size];
                            }
                            else
                            {
                                failedSounds++;
                            }
                            break;
                        default:
                            throw new Exception(string.Format("Can not determine duration of type {0}.", GetExtensionFromPath(sound.name)));
                    }
                    progressFunc();
                }
                if (pathAssigned)
                {
                    File.Delete(tempFilePath);
                }
                
            }
            return sound;
        }

        private string WriteSteamToTempFile(MpqFileStream stream)
        {
            string fileName = Path.GetRandomFileName();
            FileStream fileStream = File.Create(fileName, (int)stream.Length);
            byte[] bytesInStream = new byte[stream.Length];
            stream.Read(bytesInStream, 0, bytesInStream.Length);
            fileStream.Write(bytesInStream, 0, bytesInStream.Length);
            fileStream.Close();
            stream.Close();
            return fileName;
        }

        

        private double GetOggDuration(string oggPath)
        {
            OggVorbisMemoryStream f = OggVorbisMemoryStream.LoadFromFile(oggPath);
            return f.Duration;
        }

        UltraID3 u = new UltraID3();
        int ultraID3Usage = 0;
        private void RenewUltraID3()
        {
            try
            {
                u.Clear();
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: " + e.Message);
            }

            u = new UltraID3();
            ultraID3Usage = 0;
        }

        private double GetMp3Duration(string mp3Path)
        {
            double duration = 0;
            if (File.Exists(mp3Path))
            {
                try
                {
                    u.Read(mp3Path);
                    duration = u.Duration.TotalSeconds;
                }
                catch (ID3ZeroLengthFileException)
                {
                    throw new Exception("Empty file: " + mp3Path);
                }
                u.Clear();
            }
            else
            {
                throw new Exception("missing " + mp3Path);
            }

            ultraID3Usage++;
            if (ultraID3Usage >= 1000)
            {
                RenewUltraID3();
            }

            return duration;
        }

        public void SaveSoundLengthStatistics()
        {
            this.SaveLength(this.oggSoundLengths, "ogg.txt");
            this.SaveLength(this.mp3SoundLengths, "mp3.txt");
        }

        private void SaveLength(Dictionary<double, double> lengths, string fileName)
        {
            if (File.Exists(fileName))
            {
                File.Delete(fileName);
            }

            var writer = File.CreateText(fileName);
            foreach (var key in lengths.Keys)
            {
                writer.WriteLine(string.Format("{0:0.00}\t{1:0.00}", key, lengths[key]));
            }
            writer.Close();
        }*/
    }
}
