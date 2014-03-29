using CrystalMpq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GH_SoundFileGenerator
{
    class MPQLoader
    {
        public static IEnumerable<MpqArchive> LoadArchieves(string dataPath)
        {
            var archieves = new List<MpqArchive>();

            var directoryInfo = new DirectoryInfo(dataPath);

            // Load archieves in this folder.
            foreach (var file in directoryInfo.GetFiles("*.mpq"))
            {
                archieves.Add(new MpqArchive(file.FullName));
            }

            // Load archieves in the sub folder.
            foreach (var subDirectory in directoryInfo.GetDirectories())
            {
                archieves.AddRange(LoadArchieves(subDirectory.FullName));
            }

            return archieves;
        }
    }
}
