namespace LuaFileCloner
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Text.RegularExpressions;

    class Program
    {
        static void Main(string[] args)
        {
            var path = @".\..\..\..\..";
            var dir = new DirectoryInfo(path);

            //var outPath = @".\..\..\..\..\..\Cloned\GHI";
            //var outDir = new DirectoryInfo(outPath);

            CloneLuaInDirectory(dir); //, outDir);
        }

        static void CloneLuaInDirectory(DirectoryInfo dir) //, DirectoryInfo outDir)
        {
            foreach (var file in dir.GetFiles("*.lua", SearchOption.AllDirectories))
            {
                //var newFileName = file.FullName.Replace(dir.FullName, outDir.FullName);
                FixLuaFile(file); //, new FileInfo(newFileName));
                //ChangeEncoding(file);
            }
        }

        static Regex regex = new Regex("======+");

        static void FixLuaFile(FileInfo file) //, FileInfo outFile)
        {
            System.Console.WriteLine(file.Name);
            var text = File.ReadAllText(file.FullName);
            /*
            if (!outFile.Directory.Exists)
            {
                outFile.Directory.Create();
            }*/

            //if (!outFile.Exists)
            //{
            //    var sr = outFile.CreateText();
            //    sr.Write(text.Replace("====", ""));
            //    sr.Close();
            //}
            //else
            //{
            if (regex.IsMatch(text))
            {
                File.WriteAllText(file.FullName, regex.Replace(text, ""), Encoding.UTF8);
            }
                
            //}
        }

        private static Random random;
        private static string RandomString(int Size)
        {
            if (random == null)
            {
                random = new Random();
            }

            string input = "abcdefghijklmnopqrstuvwxyz0123456789    ";
            var chars = Enumerable.Range(0, Size)
                                   .Select(x => input[random.Next(0, input.Length)]);
            return new string(chars.ToArray());
        }
    }
}
