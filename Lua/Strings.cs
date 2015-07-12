
namespace Lua
{
    using System;
    using System.Globalization;
    using System.Text.RegularExpressions;

    public static class Strings
    {
        /// <summary>
        /// Return a formatted string using values passed in.
        /// </summary>
        /// <param name="formatstring"></param>
        /// <param name="objs"></param>
        /// <returns></returns>
        public static string format(string formatstring, params object[] objs)
        {
            return string.Format(CsStyleFormatString(formatstring), objs);
        }

        private static string CsStyleFormatString(string luaFormatString)
        {
            var c = -1;
            return Regex.Replace(luaFormatString, @"%([^%])(\.(\d+))?", (match) =>
            {
                c++;
                return string.Format(CultureInfo.InvariantCulture, "{{{0}:{1}{2}}}", c, match.Groups[1], match.Groups.Count > 3 ? match.Groups[3].ToString() : string.Empty);
            });
        }

        /// <summary>
        /// Globally substitute pattern for replacement in string.
        /// </summary>
        /// <param name="str"></param>
        /// <param name="pattern"></param>
        /// <param name="replacement"></param>
        /// <returns></returns>
        public static string gsub(string str, string pattern, string replacement)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Globally substitute pattern for replacement in string.
        /// </summary>
        /// <param name="str"></param>
        /// <param name="pattern"></param>
        /// <param name="replacement"></param>
        /// <param name="limitCount"></param>
        /// <returns></returns>
        public static string gsub(string str, string pattern, string replacement, int limitCount)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Returns the internal numeric code of the 1st character of string
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static int strbyte(string str)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Returns the internal numeric code of the i-th character of string
        /// </summary>
        /// <param name="str"></param>
        /// <param name="i"></param>
        /// <returns></returns>
        public static int strbyte(string str, int i)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Convert obj to a string.
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static string tostring(object obj)
        {
            if (obj == null)
            {
                return "nil";
            }
            return obj.ToString();
        }

        /// <summary>
        /// Returns a concatenation of all number/string arguments passed.
        /// </summary>
        /// <param name="a">First string</param>
        /// <param name="b">Second string</param>
        /// <returns>First and second string concatenated.</returns>
        public static string strconcat(string a, string b)
        {
            return a + b;
        }

        /// <summary>
        /// Returns a concatenation of all number/string arguments passed.
        /// </summary>
        /// <param name="a">First string</param>
        /// <param name="b">Second string</param>
        /// <param name="c">Third string</param>
        /// <returns>All strings concatenated.</returns>
        public static string strconcat(string a, string b, string c)
        {
            return a + b + c;
        }

        /// <summary>
        /// Returns a concatenation of all number/string arguments passed.
        /// </summary>
        /// <param name="a">First string</param>
        /// <param name="b">Second string</param>
        /// <param name="c">Third string</param>
        /// <param name="d">Third string</param>
        /// <returns>All strings concatenated.</returns>
        public static string strconcat(string a, string b, string c, string d)
        {
            return a + b + c + d;
        }

        /// <summary>
        /// Return length of the string.
        /// </summary>
        /// <param name="s">The string</param>
        /// <returns>The length.</returns>
        public static int strlen(string s)
        {
            return s.Length;
        }

        /// <summary>
        /// Return a substring of string starting at index
        /// </summary>
        /// <param name="str">The string</param>
        /// <param name="index">The start index</param>
        /// <returns>The substring.</returns>
        public static string strsub(string str, int index)
        {
            return str.Substring(index);
        }

        /// <summary>
        /// Return a substring of string starting at index
        /// </summary>
        /// <param name="str">The string</param>
        /// <param name="index">The start index</param>
        /// <param name="endIndex">The end index</param>
        /// <returns>The substring.</returns>
        public static string strsub(string str, int index, int endIndex)
        {
            return str.Substring(index, endIndex);
        }

        /// <summary>
        /// Returns a string with length equal to number of arguments, with each character assigned the internal code for that argument.
        /// </summary>
        /// <param name="byte1"></param>
        /// <returns></returns>
        public static string strchar(int byte1)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Returns a string with length equal to number of arguments, with each character assigned the internal code for that argument.
        /// </summary>
        /// <param name="byte1"></param>
        /// <param name="byte2"></param>
        /// <returns></returns>
        public static string strchar(int byte1, int byte2)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Returns a string with length equal to number of arguments, with each character assigned the internal code for that argument.
        /// </summary>
        /// <param name="byte1"></param>
        /// <param name="byte2"></param>
        /// <param name="byte3"></param>
        /// <returns></returns>
        public static string strchar(int byte1, int byte2, int byte3)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Returns a string with length equal to number of arguments, with each character assigned the internal code for that argument.
        /// </summary>
        /// <param name="byte1"></param>
        /// <param name="byte2"></param>
        /// <param name="byte3"></param>
        /// <param name="byte4"></param>
        /// <returns></returns>
        public static string strchar(int byte1, int byte2, int byte3, int byte4)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Return a list of substrings separated by occurrences of the delimiter.
        /// </summary>
        /// <param name="delimiter"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        public static NativeLuaTable strsplittotable(string delimiter, string str)
        {
            var elements = str.Split(delimiter.ToCharArray());
            var t = new NativeLuaTable();

            var i = 1;
            foreach (var element in elements)
            {
                t[i] = element;
                i++;
            }
            return t;
        }

        /// <summary>
        /// Join table of strings into a single string, separated by delimiter.
        /// </summary>
        /// <param name="delimiter"></param>
        /// <param name="t"></param>
        /// <returns></returns>
        public static string strjoinfromtable(string delimiter, NativeLuaTable t)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Join string arguments into a single string, separated by delimiter.
        /// </summary>
        /// <param name="delimiter"></param>
        /// <param name="str1"></param>
        /// <returns></returns>
        public static string strjoin(string delimiter, string str1)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Join string arguments into a single string, separated by delimiter.
        /// </summary>
        /// <param name="delimiter"></param>
        /// <param name="str1"></param>
        /// <param name="str2"></param>
        /// <returns></returns>
        public static string strjoin(string delimiter, string str1, string str2)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Join string arguments into a single string, separated by delimiter.
        /// </summary>
        /// <param name="delimiter"></param>
        /// <param name="str1"></param>
        /// <param name="str2"></param>
        /// <param name="str3"></param>
        /// <returns></returns>
        public static string strjoin(string delimiter, string str1, string str2, string str3)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Returns the number of characters in a UTF8-encoded string.
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static int strlenutf8(string str)
        {
            return str.Length;
        }

        public static string strsubutf8(string str, int a)
        {
            return str.Substring(a);
        }

        public static string strsubutf8(string str, int a, int b)
        {
            return str.Substring(a, b);
        }

        public static int strfind(string str, string pattern)
        {
            return str.IndexOf(pattern, StringComparison.Ordinal);
        }

        public static int strfind(string str, string pattern, int initPos)
        {
            return str.Substring(initPos).IndexOf(pattern, StringComparison.Ordinal);
        }

        public static int strfind(string str, string pattern, int initPos, bool plain)
        {
            return str.Substring(initPos).IndexOf(pattern, StringComparison.Ordinal);
        }

        /// <summary>
        /// Return a string which is count copies of seed.
        /// </summary>
        /// <param name="seed"></param>
        /// <param name="count"></param>
        /// <returns></returns>
        public static string strrep(string seed, int count)
        {
            var s = string.Empty;
            while (count > 0)
            {
                s += seed;
                count--;
            }
            return s;
        }

    /*

strlower(string) - Return string with all upper case changed to lower case.
strmatch(string, pattern[, initpos]) - Similar to strfind but only returns the matches, not the string positions.
strrev(string) - Reverses a string; alias of string.reverse.

strupper(string) - Return string with all lower case changed to upper case.
tonumber(arg[, base]) - Return a number if arg can be converted to number. Optional argument specifies the base to interpret the numeral. Bases other than 10 accept only unsigned integers.



strtrim(string[, chars]) - Trim leading and trailing spaces or the characters passed to chars from string.



tostringall(...) - Converts all arguments to strings and returns them in the same order that they were passed.
         */
    }
}
