import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.*;

/**
 * Aplikacja Swing do edycji obiektów klas:
 *   • Ksiazka       – panel:  PanelKsiazki
 *   • Pisarz        – panel:  PanelPisarza
 *   • Wydawnictwo   – panel:  PanelWydawnictwa
 * Dane są serializowane w pliku data.ser przez klasę Literatura.
 * 
 * Kompilacja i uruchomienie:
 *   javac Aplikacja.java Literatura.java
 *   java Aplikacja Ksiazka       # lub Pisarz / Wydawnictwo
 */
public class Aplikacja {
    private JFrame okno;
    private JComboBox<Object> listaObiektow;      // wybór obiektu do edycji
    private JPanel kontenerEdycji;                // tu umieszczamy aktywny panel
    private JButton przyciskZapisz;

    private Literatura.Dane dane;                 // dane z pliku
    private final String klasaDoEdycji;           // argument z linii poleceń

    private PanelEdycji aktywnyPanel;             // aktualnie wyświetlany panel

    public static void main(String[] args) {
        if (args.length == 0) {
            System.err.println("Użycie: java Aplikacja <KlasaDoEdycji>");
            System.exit(1);
        }
        SwingUtilities.invokeLater(() -> new Aplikacja(args[0]).start());
    }

    private Aplikacja(String klasa) {
        this.klasaDoEdycji = klasa;
        wczytajLubUtworzDane();
        budujUI();
    }

    private void start() { okno.setVisible(true); }

    // --------------------------------------------------
    //  Wczytywanie pliku data.ser (lub jego regeneracja)
    // --------------------------------------------------
    private void wczytajLubUtworzDane() {
        File plik = new File("data.ser");
        boolean regeneracja = !plik.exists();
        if (!regeneracja) {
            try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(plik))) {
                dane = (Literatura.Dane) ois.readObject();
            } catch (Exception ex) {
                System.err.println("Nie udało się wczytać data.ser → regeneruję: " + ex.getMessage());
                regeneracja = true;
            }
        }
        if (regeneracja) {
            if (plik.exists()) plik.delete();
            Literatura.main(new String[0]); // wygeneruje przykładowe dane
            try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(plik))) {
                dane = (Literatura.Dane) ois.readObject();
            } catch (Exception ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(null, "Krytyczny błąd przy odczycie danych", "Błąd", JOptionPane.ERROR_MESSAGE);
                System.exit(2);
            }
        }
    }

    // --------------------------------------------------
    //  Budowa interfejsu
    // --------------------------------------------------
    private void budujUI() {
        okno = new JFrame("Edytor " + klasaDoEdycji);
        okno.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        okno.setLayout(new BorderLayout());

        java.util.List<?> obiekty = pobierzListeObiektow(klasaDoEdycji);
        if (obiekty.isEmpty()) {
            JOptionPane.showMessageDialog(okno, "Brak obiektów typu " + klasaDoEdycji, "Info", JOptionPane.INFORMATION_MESSAGE);
            System.exit(0);
        }

        listaObiektow = new JComboBox<>(obiekty.toArray());
        listaObiektow.addActionListener(e -> odswiezPanel());

        kontenerEdycji = new JPanel(new BorderLayout());
        odswiezPanel();

        przyciskZapisz = new JButton("Zapisz");
        przyciskZapisz.addActionListener(e -> zapiszDoPliku());

        okno.add(listaObiektow, BorderLayout.NORTH);
        okno.add(kontenerEdycji, BorderLayout.CENTER);
        okno.add(przyciskZapisz, BorderLayout.SOUTH);
        okno.setPreferredSize(new Dimension(650, 400));
        okno.pack();
    }

    private java.util.List<?> pobierzListeObiektow(String nazwa) {
        return switch (nazwa) {
            case "Ksiazka"      -> dane.ksiazki;
            case "Pisarz"       -> dane.pisarze;
            case "Wydawnictwo" -> Collections.singletonList(dane.wydawnictwo);
            default              -> Collections.emptyList();
        };
    }

    private void odswiezPanel() {
        kontenerEdycji.removeAll();
        Object wybrany = listaObiektow.getSelectedItem();
        if (wybrany instanceof Ksiazka k) {
            aktywnyPanel = new PanelKsiazki(k, dane.pisarze);
        } else if (wybrany instanceof Pisarz p) {
            aktywnyPanel = new PanelPisarza(p);
        } else if (wybrany instanceof Wydawnictwo w) {
            aktywnyPanel = new PanelWydawnictwa(w);
        } else {
            aktywnyPanel = null;
        }
        if (aktywnyPanel != null) kontenerEdycji.add((Component) aktywnyPanel, BorderLayout.CENTER);
        kontenerEdycji.revalidate();
        kontenerEdycji.repaint();
    }

    private void zapiszDoPliku() {
        if (aktywnyPanel != null && !aktywnyPanel.zastosujZmiany()) {
            JOptionPane.showMessageDialog(okno, "Nie zapisano – błędne dane", "Błąd", JOptionPane.ERROR_MESSAGE);
            return;
        }
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("data.ser"))) {
            oos.writeObject(dane);
            JOptionPane.showMessageDialog(okno, "Dane zapisane", "OK", JOptionPane.INFORMATION_MESSAGE);
        } catch (Exception ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(okno, "Błąd zapisu: " + ex.getMessage(), "Błąd", JOptionPane.ERROR_MESSAGE);
        }
    }

    // ==================================================
    //  Interfejs wspólny dla paneli edycyjnych
    // ==================================================
    private interface PanelEdycji { boolean zastosujZmiany(); }

    // ==================================================
    //  1) PanelKsiazki – tytuł + lista autorów
    // ==================================================
    private static class PanelKsiazki extends JPanel implements PanelEdycji {
        private final Ksiazka ksiazka;
        private final JTextField poleTytulu = new JTextField(28);
        private final JList<Pisarz> listaAutorow;

        PanelKsiazki(Ksiazka k, java.util.List<Pisarz> wszyscyPisarze) {
            super(new BorderLayout());
            this.ksiazka = k;

            // Tytuł
            poleTytulu.setText(k.getTytul());
            add(wiersz("tytuł", poleTytulu), BorderLayout.NORTH);

            // Autorzy
            listaAutorow = new JList<>(wszyscyPisarze.toArray(new Pisarz[0]));
            listaAutorow.setVisibleRowCount(Math.min(8, wszyscyPisarze.size()));
            listaAutorow.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
            int[] idx = k.getAutorzy().stream().mapToInt(wszyscyPisarze::indexOf).toArray();
            listaAutorow.setSelectedIndices(idx);
            add(wiersz("autorzy", new JScrollPane(listaAutorow)), BorderLayout.CENTER);
        }

        @Override public boolean zastosujZmiany() {
            ksiazka.getAutorzy().clear();
            ksiazka.getAutorzy().addAll(listaAutorow.getSelectedValuesList());
            try {
                var pole = ksiazka.getClass().getDeclaredField("tytul");
                pole.setAccessible(true);
                pole.set(ksiazka, poleTytulu.getText());
                return true;
            } catch (Exception ex) {
                ex.printStackTrace();
                return false;
            }
        }

        private JPanel wiersz(String etykieta, Component komponent) {
            JPanel p = new JPanel(new BorderLayout());
            p.add(new JLabel(etykieta), BorderLayout.WEST);
            p.add(komponent, BorderLayout.CENTER);
            return p;
        }
    }

    // ==================================================
    // 2) PanelPisarza – pseudonim
    // ==================================================
    private static class PanelPisarza extends JPanel implements PanelEdycji {
        private final Pisarz pisarz;
        private final JTextField polePseudonimu = new JTextField(28);

        PanelPisarza(Pisarz p) {
            super(new BorderLayout());
            this.pisarz = p;
            polePseudonimu.setText(p.getPseudonim());
            add(wiersz("pseudonim", polePseudonimu), BorderLayout.NORTH);
        }

        @Override public boolean zastosujZmiany() {
            try {
                var pole = pisarz.getClass().getDeclaredField("pseudonim");
                pole.setAccessible(true);
                pole.set(pisarz, polePseudonimu.getText());
                return true;
            } catch (Exception ex) {
                ex.printStackTrace();
                return false;
            }
        }

        private JPanel wiersz(String etykieta, Component komponent) {
            JPanel p = new JPanel(new BorderLayout());
            p.add(new JLabel(etykieta), BorderLayout.WEST);
            p.add(komponent, BorderLayout.CENTER);
            return p;
        }
    }

    // ==================================================
    // 3) PanelWydawnictwa – nazwa + rok
    // ==================================================
    private static class PanelWydawnictwa extends JPanel implements PanelEdycji {
        private final Wydawnictwo wydawnictwo;
        private final JTextField poleNazwy = new JTextField(28);
        private final JTextField poleRoku  = new JTextField(8);

        PanelWydawnictwa(Wydawnictwo w) {
            super(new GridLayout(2, 1));
            this.wydawnictwo = w;
            poleNazwy.setText(w.getNazwa());
            poleRoku.setText(String.valueOf(w.getRokZalozenia()));
            add(wiersz("nazwa", poleNazwy));
            add(wiersz("rokZałożenia", poleRoku));
        }

        @Override public boolean zastosujZmiany() {
            try {
                var poleNazwa = wydawnictwo.getClass().getDeclaredField("nazwa");
                poleNazwa.setAccessible(true);
                poleNazwa.set(wydawnictwo, poleNazwy.getText());
                int rok = Integer.parseInt(poleRoku.getText());
                wydawnictwo.setRokZalozenia(rok);
                return true;
            } catch (Exception ex) {
                ex.printStackTrace();
                return false;
            }
        }

        private JPanel wiersz(String etykieta, Component komponent) {
            JPanel p = new JPanel(new BorderLayout());
            p.add(new JLabel(etykieta), BorderLayout.WEST);
            p.add(komponent, BorderLayout.CENTER);
            return p;
        }
    }
}
