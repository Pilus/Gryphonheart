using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GH_SoundFileGenerator
{
    class Folder
    {
        public string name;
        public List<Folder> folders;
        public List<SoundFile> sounds;

        public Folder()
        {
            this.folders = new List<Folder>();
            this.sounds = new List<SoundFile>();
        }
    }
}
