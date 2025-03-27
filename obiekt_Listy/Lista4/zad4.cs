using System;
using System.Collections;
using System.Collections.Generic;

public abstract class Formula : IEnumerable<Formula>
{
    public abstract bool Oblicz(Dictionary<string, bool> slownik);

    public abstract Formula Simplify();

    public abstract override string ToString();

    public abstract override bool Equals(object obj);

    public abstract override int GetHashCode();

    public static Formula operator &(Formula left, Formula right)
    {
        return new And(left, right);
    }

    public static Formula operator |(Formula left, Formula right)
    {
        return new Or(left, right);
    }

    public static Formula operator !(Formula formula)
    {
        return new Not(formula);
    }

    public abstract IEnumerator<Formula> GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }
}

public class Stala : Formula
{
    private bool wartosc;

    private static readonly Stala trueInstance = new Stala(true);
    private static readonly Stala falseInstance = new Stala(false);

    private Stala(bool wartosc)
    {
        this.wartosc = wartosc;
    }

    public static Stala True => trueInstance;
    public static Stala False => falseInstance;

    public override bool Oblicz(Dictionary<string, bool> slownik)
    {
        return wartosc;
    }

    public override Formula Simplify()
    {
        return this;
    }

    public override string ToString()
    {
        return wartosc ? "true" : "false";
    }

    public override bool Equals(object obj)
    {
        if (obj is Stala other)
        {
            return wartosc == other.wartosc;
        }
        return false;
    }

    public override int GetHashCode()
    {
        return wartosc.GetHashCode();
    }


    public override IEnumerator<Formula> GetEnumerator()
    {
        yield return this;
    }
}

public class Zmienna : Formula
{
    private string nazwa;

    public Zmienna(string nazwa)
    {
        this.nazwa = nazwa;
    }

    public override bool Oblicz(Dictionary<string, bool> slownik)
    {
        if (!slownik.ContainsKey(nazwa))
            throw new ArgumentException($"Brak wartości zmiennej: {nazwa}");

        return slownik[nazwa];
    }

    public override Formula Simplify()
    {
        return this;
    }

    public override string ToString()
    {
        return nazwa;
    }

    public override bool Equals(object obj)
    {
        if (obj is Zmienna other)
        {
            return nazwa == other.nazwa;
        }
        return false;
    }

    public override int GetHashCode()
    {
        return nazwa.GetHashCode();
    }
    

    public override IEnumerator<Formula> GetEnumerator()
    {
        yield return this;
    }
}

public class Not : Formula
{
    private Formula podformula;

    public Not(Formula podformula)
    {
        this.podformula = podformula;
    }

    public override bool Oblicz(Dictionary<string, bool> slownik)
    {
        return !podformula.Oblicz(slownik);
    }

    public override Formula Simplify()
    {
        Formula uproszczona = podformula.Simplify();

        if (uproszczona is Stala st)
        {
            return st == Stala.True ? Stala.False : Stala.True;
        }

        return new Not(uproszczona);
    }

    public override string ToString()
    {
        return $"¬({podformula})";
    }

    public override bool Equals(object obj)
    {
        if (obj is Not other)
        {
            return podformula.Equals(other.podformula);
        }
        return false;
    }

    public override int GetHashCode()
    {
        return podformula.GetHashCode();
    }

    public override IEnumerator<Formula> GetEnumerator()
    {
        yield return this;
        foreach (var subformula in podformula)
        {
            yield return subformula;
        }
    }
}

public class And : Formula
{
    private Formula lewa;
    private Formula prawa;

    public And(Formula lewa, Formula prawa)
    {
        this.lewa = lewa;
        this.pr    public override bool Equals(object obj)
    {
        if (obj is And other)
        {
            return lewa.Equals(other.lewa) && prawa.Equals(other.prawa);
        }
        return false;
    }awa = prawa;
    }    public override bool Equals(object obj)
    {
        if (obj is And other)
        {
            return lewa.Equals(other.lewa) && prawa.Equals(other.prawa);
        }
        return false;
    }
    public override bool Equals(object obj)
    {
        if (obj is And other)
        {
            return lewa.Equals(other.lewa) && prawa.Equals(other.prawa);
        }
        return false;
    }
    public override bool Oblicz(Dictionary<string, bool> slownik)
    {
        return lewa.Oblicz(slownik) && prawa.Oblicz(slownik);
    }

    public override Formula Simplify()
    {
        Formula lewaU = lewa.Simplify();
        Formula prawaU = prawa.Simplify();

        // 1) false ∧ p = false
        if (lewaU is Stala stLewa && !stLewa.Oblicz(null))
        {
            return Stala.False;
        }
        if (prawaU is Stala stPrawa && !stPrawa.Oblicz(null))
        {
            return Stala.False;
        }

        // 2) true ∧ p = p
        if (lewaU is Stala stL && stL.Oblicz(null))
        {
            return prawaU;
        }
        if (prawaU is Stala stP && stP.Oblicz(null))
        {
            return lewaU;
        }

        return new And(lewaU, prawaU);
    }

    public override string ToString()
    {
        return $"({lewa} ∧ {prawa})";
    }

    public override bool Equals(object obj)
    {
        if (obj is And other)
        {
            return lewa.Equals(other.lewa) && prawa.Equals(other.prawa);
        }
        return false;
    }

    public override int GetHashCode()
    {
        return lewa.GetHashCode() ^ prawa.GetHashCode();
    }

    public override IEnumerator<Formula> GetEnumerator()
    {
        yield return this;
        foreach (var subformula in lewa)
        {
            yield return subformula;
        }
        foreach (var subformula in prawa)
        {
            yield return subformula;
        }
    }
}

public class Or : Formula
{
    private Formula lewa;
    private Formula prawa;

    public Or(Formula lewa, Formula prawa)
    {
        this.lewa = lewa;
        this.prawa = prawa;
    }

    public override bool Oblicz(Dictionary<string, bool> slownik)
    {
        return lewa.Oblicz(slownik) || prawa.Oblicz(slownik);
    }

    public override Formula Simplify()
    {
        Formula lewaU = lewa.Simplify();
        Formula prawaU = prawa.Simplify();

        // 1) true ∨ p = true
        if (lewaU is Stala stLewa && stLewa.Oblicz(null))
        {
            return Stala.True;
        }
        if (prawaU is Stala stPrawa && stPrawa.Oblicz(null))
        {
            return Stala.True;
        }

        // 2) false ∨ p = p
        if (lewaU is Stala stL && !stL.Oblicz(null))
        {
            return prawaU;
        }
        if (prawaU is Stala stP && !stP.Oblicz(null))
        {
            return lewaU;
        }

        return new Or(lewaU, prawaU);
    }

    public override string ToString()
    {
        return $"({lewa} ∨ {prawa})";
    }

    public override bool Equals(object obj)
    {
        if (obj is Or other)
        {
            return lewa.Equals(other.lewa) && prawa.Equals(other.prawa);
        }
        return false;
    }

    public override int GetHashCode()
    {
        return lewa.GetHashCode() ^ prawa.GetHashCode();
    }

    public override IEnumerator<Formula> GetEnumerator()
    {
        yield return this;
        foreach (var subformula in lewa)
        {
            yield return subformula;
        }
        foreach (var subformula in prawa)
        {
            yield return subformula;
        }
    }
}

public class Program
{
    public static void Main()
    {
        // Przykładowa formuła: ¬x ∨ (y ∧ true)
        Formula form = new Or(new Not(new Zmienna("x")), new And(new Zmienna("y"), Stala.True));

        var slownik = new Dictionary<string, bool>
        {
            { "x", false },
            { "y", true }
        };

        Console.WriteLine("Formuła: " + form);
        Console.WriteLine("Wartość formuły: " + form.Oblicz(slownik));

        Formula uproszczona = form.Simplify();
        Console.WriteLine("Uproszczona formuła: " + uproszczona);
        Console.WriteLine("Wartość uproszczonej formuły: " + uproszczona.Oblicz(slownik));

        // Testowanie metody Equals
        Formula form1 = new Or(new Not(new Zmienna("x")), new And(new Zmienna("y"), Stala.True));
        Formula form2 = new Or(new Not(new Zmienna("x")), new And(new Zmienna("y"), Stala.True));
        Formula form3 = new Or(new Not(new Zmienna("x")), new And(new Zmienna("z"), Stala.True));

        Console.WriteLine("form1.Equals(form2): " + form1.Equals(form2)); // powinno być true
        Console.WriteLine("form1.Equals(form3): " + form1.Equals(form3)); // powinno być false

        // Testowanie przeciążonych operatorów
        Formula expr1 = Stala.True & new Zmienna("x");
        Formula expr2 = new Zmienna("y") | new Zmienna("z");
        Formula expr3 = !new Zmienna("x");

        Console.WriteLine("expr1: " + expr1); // powinno być (true ∧ x)
        Console.WriteLine("expr2: " + expr2); // powinno być (y ∨ z)
        Console.WriteLine("expr3: " + expr3); // powinno być ¬(x)

        // Testowanie iteracji
        Console.WriteLine("Iteracja po elementach formuły:");
        foreach (var element in form)
        {
            Console.WriteLine(element);
        }

        Console.ReadLine();
    }
}
