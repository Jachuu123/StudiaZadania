using System;
using System.Collections.Generic;

namespace Zadanie3
{
    public class LazyPrimeList : LazyIntList
    {
        public LazyPrimeList() : base() // dziedziczymy pusta tablice data
        {
        }

        public override int element(int i) // virtual pozwala
        {
            if (i < 1)
                throw new ArgumentException("Indeks powinien być >= 1.");

            if (data.Count < i)
            {
                int start = 2;
                if (data.Count > 0)
                {
                    start = data[data.Count - 1] + 1;
                }

                while (data.Count < i)
                {
                    if (IsPrime(start))
                    {
                        data.Add(start);
                    }
                    start++;
                }
            }

            return data[i - 1];
        }

        private bool IsPrime(int x)
        {
            if (x < 2) return false;
            if (x == 2) return true;
            if (x % 2 == 0) return false;
            int limit = (int)Math.Sqrt(x);
            for (int i = 3; i <= limit; i += 2)
            {
                if (x % i == 0) return false;
            }
            return true;
        }
    }
}
