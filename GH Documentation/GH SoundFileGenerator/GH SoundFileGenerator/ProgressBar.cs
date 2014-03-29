using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GH_SoundFileGenerator
{
    class ProgressBar
    {
        static int barSize = 30;
        static char progressCharacter = '\u25A0';

        private int maxVal;
        private int progress;

        public ProgressBar(int maxVal)
        {
            this.maxVal = maxVal;
            this.progress = 0;
        }        

        public Func<bool> GetProgressFunc()
        {
            return delegate()
            {
                progress++;
                this.DrawProgressBar(progress);
                return true;
            };
        }

        private void DrawProgressBar(int complete)
        {
            Console.CursorVisible = false;
            int left = Console.CursorLeft;
            decimal perc = (decimal)complete / (decimal)maxVal;
            int chars = (int)Math.Floor(perc / ((decimal)1 / (decimal)barSize));
            string p1 = String.Empty, p2 = String.Empty;

            for (int i = 0; i < chars; i++) p1 += progressCharacter;
            for (int i = 0; i < barSize - chars; i++) p2 += progressCharacter;

            Console.ForegroundColor = ConsoleColor.Green;
            Console.Write(p1);
            Console.ForegroundColor = ConsoleColor.DarkGreen;
            Console.Write(p2);

            Console.ResetColor();
            Console.Write(" {0}%", (perc * 100).ToString("N2"));
            Console.CursorLeft = left;
        }
    }
}
