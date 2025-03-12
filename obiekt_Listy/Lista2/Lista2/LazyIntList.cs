using System;
using System.Collections.Generic;

namespace Zadanie3
{
    public class LazyIntList
    {
        protected List<int> data;

        public LazyIntList()
        {
            data = new List<int>();
        }

        public virtual int element(int i)
        {
            if (i < 1)
                throw new ArgumentException("Indeks powinien być >= 1.");


            if (data.Count < i)
            {
                for (int n = data.Count; n < i; n++)
                {
                    data.Add(n);
                }
            }

            return data[i - 1];
        }

        public int size()
        {
            return data.Count;
        }
    }
}
