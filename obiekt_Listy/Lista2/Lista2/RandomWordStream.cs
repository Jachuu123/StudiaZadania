using System;
using System.Text;

namespace Zadanie1
{
    public class RandomWordStream
    {
        private FibStream fibStream;
        private Random random;

        public RandomWordStream()
        {
            fibStream = new FibStream();
            random = new Random();
        }

        public string Next()
        {
            // Gdy FibStream się skończy, możesz zwracać pusty napis
            if (fibStream.Eos())
                return string.Empty;

            int length = fibStream.Next();
            return GenerateRandomString(length);
        }

        public bool Eos()
        {
            return fibStream.Eos();
        }

        public void Reset()
        {
            fibStream.Reset();
            random = new Random();
        }

        private string GenerateRandomString(int length)
        {
            StringBuilder sb = new StringBuilder(length);
            for (int i = 0; i < length; i++)
            {
                char c = (char)random.Next('a', 'z' + 1);
                sb.Append(c);
            }
            return sb.ToString();
        }
    }
}
