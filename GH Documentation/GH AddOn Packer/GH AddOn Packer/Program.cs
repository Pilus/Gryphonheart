using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.IO.Compression;
using ICSharpCode.SharpZipLib.Zip;
using FtpLib;

namespace GH_AddOn_Packer {
    class Program {
        
        static void Main(string[] args) {
            Console.WriteLine("GH AddOn Packer v.4\n");

            string dir = AppDomain.CurrentDomain.BaseDirectory;
            Packer pack;
            if (dir.Contains("World of Warcraft")) {
                pack = new Packer(dir.Substring(0,dir.IndexOf("World of Warcraft")+17));
            } else {
                Console.WriteLine(@"Program not running from a wow directory. Using C:\Games\World of Warcraft");
                pack = new Packer(@"C:\Games\World of Warcraft");
            }

            Console.WriteLine("Please enter AddOn to pack");
            string addon = Console.ReadLine();
            
            try {
                if (pack.PackAddon(addon)) {
                    Console.WriteLine("Packing Successfull");
                }
                else {
                    Console.WriteLine("Packing Failed");
                }
            }
            catch (Exception e) {
                Console.WriteLine(e.Message);
                Console.WriteLine("Packing Failed");
            }
            Console.ReadKey();
        }

        
    }
    class Packer {
        private string wowPath;
        public Packer(string path) {
            wowPath = path;
            //Console.WriteLine("path set to " + path);
        }

        public bool PackAddon(string name) {
            string path;
            List<string> filesIntoc;
            List<string> variables;
            string version;
            string addonShort;
            List<string> dependencies;
            string title;
            string tocPath = wowPath + @"\Interface\AddOns\" + name.ToUpper() + "\\" + name.ToLower() + ".toc";
            GetInfoFromToc(tocPath, out path, out filesIntoc, out variables, out version, out addonShort, out title, out dependencies);

            Console.WriteLine(title + " version " + version);

            int i = 0;
            while (i < dependencies.Count) {
                List<string> deps = GetDependensies(wowPath + @"\Interface\AddOns\" + dependencies[i].Trim() + "\\"+ dependencies[i].Trim() +".toc");
                foreach (string dep in deps) {
                    if (!dependencies.Contains(dep)) {
                        dependencies.Add(dep);
                    }
                }
                i++;
            }

            ChangeTocDevFlag(tocPath, false);
            foreach (string dep in dependencies) {
                ChangeTocDevFlag(wowPath + @"\Interface\AddOns\" + dep.Trim() + "\\" + dep.Trim() + ".toc",false);
            }

            List<string> files = new List<string>();
            files = GetFilesToMove(wowPath + @"\Interface\AddOns\" + name.ToUpper(), files);
            foreach (string dep in dependencies) {
                files =GetFilesToMove(wowPath + @"\Interface\AddOns\" + dep.Trim(), files);
            }
            
            string releasePath = GetLibPath(name.ToUpper(),version);

            Console.WriteLine("Compressing");

            

            CompressAddOn(releasePath + "\\" + name.ToUpper() + " v." + version + ".zip", files, wowPath + @"\Interface\AddOns\");

            ChangeTocDevFlag(tocPath, true);
            foreach (string dep in dependencies) {
                ChangeTocDevFlag(wowPath + @"\Interface\AddOns\" + dep.Trim() + "\\" + dep.Trim() + ".toc", true);
            }

            //SendAddOnToServer(files, wowPath + @"\Interface\AddOns\");

            UpdateTocVersion(tocPath,version);

            return true;
        }

        private void ChangeTocDevFlag(string tocPath, bool flag) {
            string[] file = File.ReadAllLines(tocPath);
            StringBuilder newFile = new StringBuilder();

            foreach (string line in file) {
                if (line.StartsWith("## X-DevVersion:")) {
                    newFile.Append(string.Format("## X-DevVersion: {0}\n",flag.ToString()));
                    continue;
                }
                newFile.Append(line + "\n");
            }

            File.WriteAllText(tocPath, newFile.ToString());
        }

        private void UpdateTocVersion(string tocPath,string version) {
            Console.WriteLine("Updating version for next release");

            string[] versionDetails = version.Split(".".ToCharArray());

            if (versionDetails.Count() < 3) {
                Console.WriteLine("The addon contains a version number with only two numbers or less: {0}. Updating of toc not supported", versionDetails.Count());
                return;
            }

            string[] file = File.ReadAllLines(tocPath);
            StringBuilder newFile = new StringBuilder();

            foreach (string line in file) {
                if (line.StartsWith("## Version:")) {
                    int lastVersionDiget = Convert.ToInt32(versionDetails[2]);
                    newFile.Append(string.Format("## Version: {0}.{1}.{2}\n", versionDetails[0], versionDetails[1],lastVersionDiget +1));
                    continue;
                }
                newFile.Append(line + "\n");
            }

            File.WriteAllText(tocPath, newFile.ToString());
        }

        private string GetLibPath(string addonShort, string version) {
            string[] versionDetails = version.Split(".".ToCharArray());

            if (versionDetails.Count() < 3) {
                Console.WriteLine("The addon contains a version number with only two numbers or less {0}.", versionDetails.Count());
                
            }

            string path = string.Format(@"{0}\Interface\Releases\{1}\Version {2}.{3}\Build {4}",wowPath,addonShort,versionDetails[0],versionDetails[1],versionDetails[2]);
            //Console.WriteLine("Path: " + path);
            DirectoryInfo di = new DirectoryInfo(path);
            if (!di.Exists) {
                di.Create();
            }
            return path;
        }

        private void CompressAddOn(string zipPath, List<string> filesForZip,string addOnFolder) {

            try {
                ZipFile z = ZipFile.Create(zipPath);
                z.BeginUpdate();


                foreach (string fileName in filesForZip) {
                    Console.WriteLine("     {0}", fileName);
                    z.Add(fileName, fileName.Replace(addOnFolder, ""));
                }
                Console.WriteLine("Zipping...");

                z.CommitUpdate();
                z.Close();
                Console.WriteLine("Compressing done");
            }
            catch (Exception e) {
                Console.WriteLine(e.Message);
            }
            
        }

        string currentDir = "";
        FtpFileInfo[] currentDirFileInfo; 

        private bool PutFile(FtpConnection ftp, string file) {
            string ftpPart = file.Remove(0, file.IndexOf(@"Interface\AddOns\") + (@"Interface\AddOns\").Length);
            string folderName = ftpPart.Remove(ftpPart.LastIndexOf(@"\"));
            string fileName = ftpPart.Remove(0,ftpPart.LastIndexOf(@"\")+1);

            if (!currentDir.Equals(folderName)) {
                ftp.SetCurrentDirectory(@"\" + folderName);
                currentDir = folderName;
                currentDirFileInfo = ftp.GetFiles();
            }            

            FileInfo localFileInfo = new FileInfo(file);

            FtpFileInfo ftpFileInfo = null;
            foreach (FtpFileInfo info in currentDirFileInfo) {
                if (info.Name.Equals(fileName)) ftpFileInfo = info;
            }

            if (ftpFileInfo == null) {
                ftp.PutFile(file, fileName);
                return true;
            }
            else {
                DateTime ftpTime = ftpFileInfo.LastWriteTimeUtc ?? DateTime.MinValue;
                if (ftpTime < localFileInfo.LastWriteTimeUtc) {
                    ftp.PutFile(file, fileName);
                    return true;
                }
            }

            return false;
        }

        private void SendAddOnToServer(List<string> files, String folderPath) {
            Console.WriteLine("Sending to server");
            TextReader tr = new StreamReader(@"C:\Users\Pilus\Documents\Cloud Backup\PrologueServer.txt");
            string addr = tr.ReadLine();
            string user = tr.ReadLine();
            string pass = tr.ReadLine();


            using (FtpConnection ftp = new FtpConnection(addr,user,pass)) {

                ftp.Open(); /* Open the FTP connection */
                ftp.Login(); /* Login using previously provided credentials */

                int c = 0;
                int c2 = 0;
                int transfered = 0;

                foreach (String file in files) {                    
                    try {

                        // Check if the directory exists
                        String relativeFilePath = file.Replace(folderPath, "").Replace(@"\","/");
                        String totalDirPath = relativeFilePath.Substring(0, relativeFilePath.LastIndexOf("/"));
                        String folder = totalDirPath.Substring(totalDirPath.LastIndexOf("/") + 1);
                        String topDir = "/"+totalDirPath.Replace("/" + folder, "");
                        if (!ftp.GetCurrentDirectory().Equals("/" + totalDirPath)) {
                            ftp.SetCurrentDirectory(topDir);
                            if (!ftp.DirectoryExists(folder)) {
                                ftp.CreateDirectory(folder);
                            }
                        } 



                        if (PutFile(ftp, file) == true) {
                            transfered++;
                        }

                        c++;
                        int c3 = (c / (files.Count / 20));
                        if (c3 > c2) {
                            Console.Write("{0}% ", c3*5);
                            c2 = c3;
                        }
                    }
                    catch (FtpException e) {
                        Console.WriteLine(String.Format("FTP Error: {0} {1}", e.ErrorCode, e.Message));
                    }
                }

                Console.WriteLine("{0} files created/updated.", transfered);
                

                
            }
        }

        private List<string> GetFilesToMove(string dirPath, List<string> files) {
            DirectoryInfo di = new DirectoryInfo(dirPath);
            if (!dirPath.Contains(@"\Test") && !dirPath.Contains(@"\TEST")) {
                foreach(FileInfo fi in (di.GetFiles())) {

                    if (!fi.Extension.EndsWith("bak") && !fi.Extension.EndsWith("luc") && !fi.Extension.EndsWith("iml") && !fi.Extension.EndsWith("skip")) {
                        files.Add(fi.FullName);
                    }
                }
            }
            foreach (DirectoryInfo subDi in (di.GetDirectories())) {
                if (!subDi.Name.StartsWith(".")) {
                    files = GetFilesToMove(subDi.FullName, files);
                }
            }
            return files;
        }

        private List<string> GetDependensies(string tocPath) {
            List<string> dep = new List<string>();
            string d1,d2,d3,d4;
            List<string> l1,l2;
            GetInfoFromToc(tocPath, out d1, out l1, out l2, out d2, out d3,out d4, out dep);
            return dep;
        }


        private bool GetInfoFromToc(string tocPath, out string addOnPath, out List<string> files, out List<string> variables, out string version, out string addonShort, out string title, out List<string> dependencies) {
            // setup
            addOnPath = "";
            files = new List<string>();
            variables = new List<string>();
            addonShort = "";
            version = "";
            title = "";
            dependencies = new List<string>();

            if (!tocPath.EndsWith(".toc")) {
                //Msg("Not a .toc file");
                return false;
            }

            // find addon path
            addOnPath = (tocPath.Substring(0, tocPath.LastIndexOf("\\")));

            // open toc file
            StreamReader file = new StreamReader(tocPath);
            String line = "";
            //String title = "";


            while (!file.EndOfStream) {
                line = file.ReadLine();
                if (line.StartsWith("## Title:")) {
                    title = line.Substring(10);
                }
                else if (line.StartsWith("## Version:")) {
                    version = line.Substring(12);
                }
                else if (line.StartsWith("## X-Short:")) {
                    addonShort = line.Substring(12);
                }
                else if (line.StartsWith("## SavedVariablesPerCharacter:")) {
                    string vars = line.Substring(31).Trim();
                    variables = vars.Split((",").ToCharArray()).ToList();
                }
                else if ((!line.StartsWith("##")) && line.Length > 0) {
                    // add file
                    if (!line.Contains("\\") && !line.EndsWith(".xml")) {
                        files.Add(line.Trim());
                        //Msg("Added " + line.Trim());
                    }
                }
                else if (line.StartsWith("## Dependencies:")) {
                    string vars = line.Substring(17).Trim();
                    dependencies = vars.Split((",").ToCharArray()).ToList();
                }
                else if (line.StartsWith("## RequiredDeps:")) {
                    string vars = line.Substring(17).Trim();
                    dependencies = vars.Split((",").ToCharArray()).ToList();
                }
            }
            //("Found " + variables.Count.ToString() + " saved variables.");
            //Msg("Compressing " + title + " version " + version);

            file.Close();
            return true;
        }

         
    }
}
