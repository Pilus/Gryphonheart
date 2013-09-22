using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GH_UnitTest {
    class TestList {
        private String wowDir;
        public FilePairDirectory fileDir;
        private UnitTestRunner runner;

        private void RunTest(FilePair pair) {
            runner.RunTest();
        }


        private void MatchFiles(String path, List<FileInfo> unitTestsList,List<FileInfo> codeFileList) {
            fileDir = new FilePairDirectory(path);

            foreach (FileInfo codeFile in codeFileList) {
                FilePair filePair = new FilePair();
                filePair.codeFile = codeFile;

                foreach (FileInfo testFile in unitTestsList) {
                    if (testFile.Name.Equals(codeFile.Name)) {
                        filePair.unitTestFile = testFile;
                        break;
                    }
                }
                RunTest(filePair);

                fileDir.Add(filePair);

            }
            foreach (FileInfo testFile in unitTestsList) {
                FilePair filePair = new FilePair();
                filePair.unitTestFile = testFile;

                RunTest(filePair);
                fileDir.Add(filePair);

            }

            
        }

        private void GetAllTests(DirectoryInfo dir, List<FileInfo> list) {
            foreach (DirectoryInfo subDir in dir.GetDirectories()) {
                GetAllTests(subDir, list);                        
            }
            foreach (FileInfo file in dir.GetFiles()) {
                if (file.Extension.Equals(".lua")) {
                    list.Add(file);
                }
            }
        }

        public void Update() {
            String testDirPath = wowDir + @"\Interface\AddOns\GHP\TEST";

            List<FileInfo> unitTestsList;
            List<FileInfo> codeFileList;

            DirectoryInfo testDir;
            testDir = new DirectoryInfo(testDirPath);

            unitTestsList = new List<FileInfo>();
            GetAllTests(testDir, unitTestsList);

            codeFileList = new List<FileInfo>();
            GetInfoFromToc(wowDir + @"\Interface\AddOns\GHP\GHP.toc", codeFileList);

            MatchFiles(wowDir + @"\Interface\AddOns\GHP", unitTestsList, codeFileList);
        }

        public TestList() {
            String dir = AppDomain.CurrentDomain.BaseDirectory;
            

            if (dir.Contains("World of Warcraft")) {
                wowDir = dir.Substring(0, dir.IndexOf("\\", dir.IndexOf("World of Warcraft")));
            }
            else {
                // Program not running from a wow directory. Using C:\Games\World of Warcraft
                wowDir = @"C:\Games\World of Warcraft";
            }

            runner = new UnitTestRunner(wowDir + @"\Interface\AddOns\GHP\TEST");

            Update();
        }


        private void GetInfoFromToc(string tocPath, List<FileInfo> files) {
            StreamReader file = new StreamReader(tocPath);
            String line;


            String addOnPath = (tocPath.Substring(0, tocPath.LastIndexOf("\\")));

            while (!file.EndOfStream) {
                line = file.ReadLine();
                if ((!line.StartsWith("##")) && line.Length > 0) {
                    // add file
                    if (!line.EndsWith(".xml")) {
                        files.Add(new FileInfo(addOnPath + @"\" + line));
                    }
                }
            }

            file.Close();
            return;
        }



        // UI Functions
 
    }


    public class FilePairDirectory {
        String _path;
        public List<FilePair> files = new List<FilePair>();
        public Dictionary<String, FilePairDirectory> dirs = new Dictionary<String, FilePairDirectory>();
        public String Name;

        public FilePairDirectory(String path) {
            _path = path;
            Name = path.Remove(0, path.LastIndexOf("\\") + 1);
        }

        public void Add(FilePair pair) {
            FileInfo file = pair.codeFile;
            if (file == null) file = pair.unitTestFile;
            String remainingPath = file.FullName.Remove(0,_path.Length+1);

            if (remainingPath.Contains("\\")) {
                String subDirPath = file.FullName.Remove(_path.Length + 1 + remainingPath.IndexOf("\\"));

                if (!dirs.ContainsKey(subDirPath)) dirs[subDirPath] = new FilePairDirectory(subDirPath);

                dirs[subDirPath].Add(pair);
            }
            else {
                files.Add(pair);
            }
        }

    }

    public struct FilePair {
        public FileInfo codeFile;
        public FileInfo unitTestFile;
    }
}
