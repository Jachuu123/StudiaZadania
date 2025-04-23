import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.io.*;

// Rozszerzony interfejs Obserwator o metodę getPriority(), rozszerza Serializable
interface Obserwator extends Serializable {
    void powiadomienie(Ksiazka k);
    int getPriority();
}

class Ksiazka implements Serializable {
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

class Pisarz implements Serializable {
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
        List<Obserwator> sorted = new ArrayList<>(obserwatorzy);
        // Sortowanie obserwatorów wg priorytetu (im mniejszy, tym wyższy priorytet)
        sorted.sort((o1, o2) -> Integer.compare(o1.getPriority(), o2.getPriority()));
        for (Obserwator o : sorted) {
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
    private int rokZalozenia = 2025;
    
    public Wydawnictwo(String nazwa) {
        this.nazwa = nazwa;
    }
    
    public String getNazwa() {
        return nazwa;
    }
    
    public int getRokZalozenia() {
        return rokZalozenia;
    }
    
    public void setRokZalozenia(int rok) {
        this.rokZalozenia = rok;
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
    public int getPriority() {
        return 2;
    }
    
    @Override
    public String toString() {
        return "Wydawnictwo: " + nazwa + " (rok założenia: " + rokZalozenia + ")";
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
    public int getPriority() {
        return 3;
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
    public int getPriority() {
        return 4;
    }
    
    @Override
    public String toString() {
        return "Bibliotekarz: " + imie;
    }
}

class Krytyk implements Obserwator {
    private String imie;
    
    public Krytyk(String imie) {
        this.imie = imie;
    }
    
    @Override
    public void powiadomienie(Ksiazka k) {
        System.out.println("Krytyk " + imie + " ocenia książkę: " + k);
    }
    
    @Override
    public int getPriority() {
        return 1;
    }
    
    @Override
    public String toString() {
        return "Krytyk: " + imie;
    }
}

public class Literatura {
    public static void main(String[] args) {
        File dataFile = new File("data.ser");
        if (dataFile.exists()) {
            // Odczyt danych z pliku
            try {
                ObjectInputStream ois = new ObjectInputStream(new FileInputStream(dataFile));
                Dane dane = (Dane) ois.readObject();
                ois.close();

                //dane.ksiazki.add(new Ksiazka("Nowa Książka", Arrays.asList(pisarz1)));


                Pisarz pisarzLitwos = null;
                for (Pisarz p : dane.pisarze) {
                    if (p.getPseudonim().equals("Litwos")) {
                        pisarzLitwos = p;
                        break;
                    }
                }
                Pisarz.napiszKsiazke("Dziady", pisarzLitwos);
                

                System.out.println("Dane odczytane z pliku:");
                System.out.println("Pisarze:");
                for (Pisarz p : dane.pisarze) {
                    System.out.println(p);
                }
                System.out.println("\nKsiazki:");
                for (Ksiazka k : dane.ksiazki) {
                    System.out.println(k);
                }
                System.out.println("\nWydawnictwo:");
                System.out.println(dane.wydawnictwo);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Tworzenie przykładowych danych
            Wydawnictwo wydawnictwo = new Wydawnictwo("Tomasz");
            wydawnictwo.setRokZalozenia(2020);
            
            Czytelnik czytelnik = new Czytelnik("Jan");
            Bibliotekarz bibliotekarz = new Bibliotekarz("Anna");
            Krytyk krytyk = new Krytyk("Adam");
            
            Pisarz pisarz1 = new Pisarz("Adam Mickiewicz");
            Pisarz pisarz2 = new Pisarz("Henryk Sienkiewicz");
            Pisarz pisarz3 = new Pisarz("Bolesław Prus");
            
            // Dodajemy obserwatorów – kolejność powiadamiania ustali się wg priorytetu:
            pisarz1.dodajObserwatora(krytyk);
            pisarz1.dodajObserwatora(wydawnictwo);
            pisarz1.dodajObserwatora(czytelnik);
            pisarz1.dodajObserwatora(bibliotekarz);
            
            pisarz2.dodajObserwatora(krytyk);
            pisarz2.dodajObserwatora(wydawnictwo);
            pisarz2.dodajObserwatora(czytelnik);
            
            pisarz1.napisz("Pan Tadeusz");
            Pisarz.napiszKsiazke("Quo vadis", pisarz2);
            Pisarz.napiszKsiazke("Lalka", pisarz3);
            
            System.out.println("\nKsiążki napisane przez " + pisarz1.getPseudonim() + ":");
            for (Ksiazka k : pisarz1.getKsiazki()) {
                System.out.println(k);
            }
            
            System.out.println("\nKsiążki napisane przez " + pisarz2.getPseudonim() + ":");
            for (Ksiazka k : pisarz2.getKsiazki()) {
                System.out.println(k);
            }
            
            // Zebranie danych do serializacji
            List<Pisarz> pisarze = new ArrayList<>();
            pisarze.add(pisarz1);
            pisarze.add(pisarz2);
            pisarze.add(pisarz3);
            
            List<Ksiazka> ksiazki = new ArrayList<>();
            ksiazki.addAll(pisarz1.getKsiazki());
            for (Ksiazka k : pisarz2.getKsiazki()) {
                if (!ksiazki.contains(k)) {
                    ksiazki.add(k);
                }
            }
            
            Dane dane = new Dane(pisarze, ksiazki, wydawnictwo);
            try {
                ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(dataFile));
                oos.writeObject(dane);
                oos.close();
                System.out.println("\nDane zapisane do pliku.");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    // Klasa pomocnicza przechowująca kolekcje obiektów do serializacji
    static class Dane implements Serializable {
         List<Pisarz> pisarze;
         List<Ksiazka> ksiazki;
         Wydawnictwo wydawnictwo;
         
         public Dane(List<Pisarz> pisarze, List<Ksiazka> ksiazki, Wydawnictwo wydawnictwo) {
             this.pisarze = pisarze;
             this.ksiazki = ksiazki;
             this.wydawnictwo = wydawnictwo;
         }
    }
}
