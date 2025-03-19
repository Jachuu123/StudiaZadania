using System;
using System.Collections.Generic;

public abstract class Formula
{
    public abstract bool Oblicz(Dictionary<string, bool> slownik);

    public abstract Formula Simplify();
}

public class Stala : Formula
{
    private bool wartosc;

    public Stala(bool wartosc)
    {
        this.wartosc = wartosc;
    }

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
            return new Stala(!st.Oblicz(null));
        }

        return new Not(uproszczona);
    }

    public override string ToString()
    {
        return $"¬({podformula})";
    }
}

public class And : Formula
{
    private Formula lewa;
    private Formula prawa;

    public And(Formula lewa, Formula prawa)
    {
        this.lewa = lewa;
        this.prawa = prawa;
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
            return new Stala(false);
        }
        if (prawaU is Stala stPrawa && !stPrawa.Oblicz(null))
        {
            return new Stala(false);
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
            return new Stala(true);
        }
        if (prawaU is Stala stPrawa && stPrawa.Oblicz(null))
        {
            return new Stala(true);
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
}

public class Program
{
    public static void Main()
    {
        // Przykładowa formuła: ¬x ∨ (y ∧ true)
        Formula form = new Or(new Not(new Zmienna("x")),new And(new Zmienna("y"), new Stala(true)));

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

        Console.ReadLine();
    }
}
