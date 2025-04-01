import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

interface Obserwator {
    void powiadomienie(Ksiazka k);
}

class Ksiazka {
    private String tytul;
    private List<Pisarz> autorzy;
    
    public Ksiazka(String tytul, List<Pisarz> autorzy) {
        this.tytul = tytul;
        this.autorzy = new ArrayList<>(autorzy);
    }
    
    public String getTytul() {
        return tytul;
    }
    
    public List<Pisarz> getAutorzy() {
        return autorzy;
    }
    
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Ksiazka: ").append(tytul).append(" (autorzy: ");
        for (int i = 0; i < autorzy.size(); i++) {
            sb.append(autorzy.get(i).getPseudonim());
            if (i < autorzy.size() - 1) {
                sb.append(", ");
            }
        }
        sb.append(")");
        return sb.toString();
    }
}

class Pisarz {
    private String pseudonim;
    private List<Obserwator> obserwatorzy;
    private List<Ksiazka> ksiazki;
    
    public Pisarz(String pseudonim) {
        this.pseudonim = pseudonim;
        this.obserwatorzy = new ArrayList<>();
        this.ksiazki = new ArrayList<>();
    }
    
    public String getPseudonim() {
        return pseudonim;
    }
    
    public List<Ksiazka> getKsiazki() {
        return ksiazki;
    }
    
    public void dodajObserwatora(Obserwator o) {
        if (!obserwatorzy.contains(o)) {
            obserwatorzy.add(o);
        }
    }
    
    public void usunObserwatora(Obserwator o) {
        obserwatorzy.remove(o);
    }
    
    public void napisz(String tytul) {
        Ksiazka k = new Ksiazka(tytul, Arrays.asList(this));
        ksiazki.add(k);
        powiadomObserwatorow(k);
    }
    
    public static void napiszKsiazke(String tytul, Pisarz... autorzy) {
        Ksiazka k = new Ksiazka(tytul, Arrays.asList(autorzy));
        for (Pisarz p : autorzy) {
            p.ksiazki.add(k);
            p.powiadomObserwatorow(k);
        }
    }
    
    private void powiadomObserwatorow(Ksiazka k) {
        for (Obserwator o : obserwatorzy) {
            o.powiadomienie(k);
        }
    }
    
    @Override
    public String toString() {
        return "Pisarz: " + pseudonim;
    }
}

class Wydawnictwo implements Obserwator {
    private String nazwa;
    
    public Wydawnictwo(String nazwa) {
        this.nazwa = nazwa;
    }
    
    public void wydajKsiazke(Ksiazka k) {
        System.out.println("Wydawnictwo " + nazwa + " wydaje książkę: " + k);
    }
    
    @Override
    public void powiadomienie(Ksiazka k) {
        if (k.getTytul().charAt(0) == nazwa.charAt(0)) {
            wydajKsiazke(k);
        }
    }
    
    @Override
    public String toString() {
        return "Wydawnictwo: " + nazwa;
    }
}

class Czytelnik implements Obserwator {
    private String imie;
    
    public Czytelnik(String imie) {
        this.imie = imie;
    }
    
    @Override
    public void powiadomienie(Ksiazka k) {
        System.out.println("Czytelnik " + imie + " otrzymał powiadomienie o nowej książce: " + k);
    }
    
    @Override
    public String toString() {
        return "Czytelnik: " + imie;
    }
}

class Bibliotekarz implements Obserwator {
    private String imie;
    
    public Bibliotekarz(String imie) {
        this.imie = imie;
    }
    
    @Override
    public void powiadomienie(Ksiazka k) {
        System.out.println("Bibliotekarz " + imie + " odnotował nową książkę: " + k);
    }
    
    @Override
    public String toString() {
        return "Bibliotekarz: " + imie;
    }
}

public class Literatura {
    public static void main(String[] args) {
        Wydawnictwo wydawnictwo = new Wydawnictwo("Tomasz");
        Czytelnik czytelnik = new Czytelnik("Jan");
        Bibliotekarz bibliotekarz = new Bibliotekarz("Anna");
        
        Pisarz pisarz1 = new Pisarz("Litwos");
        Pisarz pisarz2 = new Pisarz("Kowalski");
        
        pisarz1.dodajObserwatora(wydawnictwo);
        pisarz1.dodajObserwatora(czytelnik);
        pisarz1.dodajObserwatora(bibliotekarz);
        
        pisarz2.dodajObserwatora(wydawnictwo);
        pisarz2.dodajObserwatora(czytelnik);
        
        pisarz1.napisz("Trylogia");
        
        Pisarz.napiszKsiazke("AiSD", pisarz1, pisarz2);
        
        System.out.println("\nKsiążki napisane przez " + pisarz1.getPseudonim() + ":");
        for (Ksiazka k : pisarz1.getKsiazki()) {
            System.out.println(k);
        }
        
        System.out.println("\nKsiążki napisane przez " + pisarz2.getPseudonim() + ":");
        for (Ksiazka k : pisarz2.getKsiazki()) {
            System.out.println(k);
        }
    }
}