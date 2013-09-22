using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.IO;
using OggVorbisDecoder;
using HundredMilesSoftware.UltraID3Lib;

namespace OggLengthExtractor {
    class DurationAnalyzer {

        public DurationAnalyzer() {
        }

        public double GetOggDuration(String oggPath) {
            OggVorbisMemoryStream f = OggVorbisMemoryStream.LoadFromFile(oggPath);
            return f.Duration;
        }

        UltraID3 u = new UltraID3();
        int ultraID3Usage = 0;
        void RenewUltraID3() {
            try {
                u.Clear();
            }
            catch (Exception e) {
                Console.WriteLine("Exception: " + e.Message);
            }

            u = new UltraID3();
            ultraID3Usage = 0;
        }

        public double GetMp3Duration(String mp3Path) {
            double duration = 0;
            if (File.Exists(mp3Path)) {
                try {
                    u.Read(mp3Path);
                    duration = u.Duration.TotalSeconds;
                }
                catch (ID3ZeroLengthFileException e) {
                    Console.WriteLine("Empty file: " + mp3Path);
                }
                catch (Exception e) {
                    Console.WriteLine("Exception: " + e.Message);
                }
                u.Clear();
            }
            else {
                Console.WriteLine("missing " + mp3Path);
            }

            ultraID3Usage++;
            if (ultraID3Usage >= 1000) {
                RenewUltraID3();
            }

            return duration;
        }
    }
}
