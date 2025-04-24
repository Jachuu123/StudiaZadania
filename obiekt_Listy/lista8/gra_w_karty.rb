# encoding: utf-8
# gra_w_karty.rb
# ------------------------------------------------------------
#  Gra „Wojna” – Lista 8 (Programowanie Obiektowe, 17 IV 2025)
#  Wersja DZIAŁAJĄCA, kompletna, z polskimi nazwami.
# ------------------------------------------------------------
#  ▸ Klasa `Karta`           – pojedyncza karta (Multiton/Flyweight)
#  ▸ Klasa `Talia`           – 52‑kartowa talia z tasowaniem
#  ▸ Klasy graczy            `GraczCzlowiek`, `GraczKomputer`
#  ▸ Klasa `Gra`             – silnik gry „Wojna”
# ------------------------------------------------------------
#  Uruchom:  ruby gra_w_karty.rb [ai-ai]
#            (bez argumentu – człowiek vs komputer)
# ------------------------------------------------------------

############################################
#               KLASA KARTA                #
############################################
class Karta
  include Comparable

  RANGI = [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A].freeze
  KOLORY = {
    kier: "\u2665", # ♥
    karo: "\u2666", # ♦
    trefl: "\u2663", # ♣
    pik:  "\u2660"  # ♠
  }.freeze

  @@instancje = {}

  class << self
    # Zwraca unikatowy obiekt karty (tworzy go przy 1. wywołaniu)
    def pobierz(ranga, kolor)
      klucz = [ranga, kolor]
      @@instancje[klucz] ||= new(ranga, kolor)
    end

    private :new # zapobiega duplikatom kart
  end

  attr_reader :ranga, :kolor

  def initialize(ranga, kolor)
    @ranga = ranga
    @kolor = kolor
  end

  # Porównanie kart według kolejności w RANGI
  def <=>(inna)
    RANGI.index(ranga) <=> RANGI.index(inna.ranga)
  end

  def to_s
    figura = ranga.is_a?(Symbol) ? ranga.to_s : ranga
    "#{figura}#{KOLORY[kolor]}"
  end
end

############################################
#               KLASA TALIA                #
############################################
class Talia
  include Enumerable

  def initialize(karty = self.class.standardowa_talia)
    @karty = karty.dup
  end

  def each(&blok)
    @karty.each(&blok)
  end

  def tasuj!
    @karty.shuffle!
    self
  end

  def dobierz
    @karty.shift
  end

  def pusta?
    @karty.empty?
  end

  def rozmiar
    @karty.size
  end

  # ===== Metoda klasowa
  def self.standardowa_talia
    Karta::KOLORY.keys.flat_map do |kolor|
      Karta::RANGI.map { |ranga| Karta.pobierz(ranga, kolor) }
    end
  end
end

############################################
#          INTERFEJS GRACZA (mixin)        #
############################################
module InterfejsGracza
  def nazwa;                             raise NotImplementedError; end
  def otrzymaj_karty(karty);             raise NotImplementedError; end
  def wyloz_karte;                       raise NotImplementedError; end
  def zabierz_karty_ze_stolu!(karty);    raise NotImplementedError; end
  def liczba_kart;                       raise NotImplementedError; end
end

############################################
#        KLASY GRACZY – CZŁOWIEK/BOT       #
############################################
class GraczCzlowiek
  include InterfejsGracza

  def initialize(pseudonim = 'Ty')
    @pseudonim = pseudonim
    @reka = []
  end

  def nazwa = @pseudonim

  def otrzymaj_karty(karty)
    @reka.concat(karty)
  end

  def wyloz_karte
    puts "\n#{@pseudonim}, wciśnij Enter, aby odsłonić kartę (Twoje karty: #{@reka.size})"
    STDIN.gets
    @reka.shift
  end

  def zabierz_karty_ze_stolu!(karty)
    @reka.concat(karty.shuffle)
  end

  def liczba_kart = @reka.size
end

class GraczKomputer
  include InterfejsGracza

  def initialize(pseudonim = 'Bot')
    @pseudonim = pseudonim
    @reka = []
  end

  def nazwa = @pseudonim

  def otrzymaj_karty(karty)
    @reka.concat(karty)
  end

  def wyloz_karte
    #sleep 0.2 # krótka pauza dla czytelności
    @reka.shift
  end

  def zabierz_karty_ze_stolu!(karty)
    @reka.concat(karty.shuffle)
  end

  def liczba_kart = @reka.size
end

############################################
#                 KLASA GRA                #
############################################
class Gra
  KARTY_ZAKRYTE = 3 # ile kart dokładamy przy remisie

  def initialize(gracze)
    raise ArgumentError, 'Potrzebnych jest co najmniej 2 graczy' if gracze.size < 2

    @gracze = gracze
    @stol   = [] # wyłożone karty

    talia = Talia.new.tasuj!
    rozdaj(talia)
  end

  # ---------- API PUBLICZNE ----------
  def uruchom
    nr_rundy = 1
    until koniec?
      puts "\n=== Runda ##{nr_rundy} ==="
      rozegraj_runde
      nr_rundy += 1
    end
    oglos_wynik
  end

  private

  # ------- rozdawanie kart po kolei
  def rozdaj(talia)
    i = 0
    until talia.pusta?
      @gracze[i % @gracze.size].otrzymaj_karty([talia.dobierz])
      i += 1
    end
  end

  def rozegraj_runde
    @stol.clear

    odkryte = @gracze.map do |g|
      karta = g.wyloz_karte
      raise "#{g.nazwa} nie ma kart!" unless karta
      puts "#{g.nazwa} wykłada #{karta}"
      karta
    end

    @stol.concat(odkryte)
    rozstrzygnij_konflikt(odkryte)
  end

  # ------- rekurencyjnie rozwiązuje remisy
  def rozstrzygnij_konflikt(odkryte)
    najlepsza_ranga = odkryte.map(&:ranga).max_by { |r| Karta::RANGI.index(r) }
    zwyciezcy_idx   = odkryte.each_index.select { |i| odkryte[i].ranga == najlepsza_ranga }
    zwyciezcy       = zwyciezcy_idx.map { |i| @gracze[i] }

    if zwyciezcy.size == 1
      gracz = zwyciezcy.first
      gracz.zabierz_karty_ze_stolu!(@stol)
      puts "-> #{gracz.nazwa} zabiera #{@stol.size} kart (ma #{gracz.liczba_kart})"
    else
      puts "==> WOJNA! Remis: #{zwyciezcy.map(&:nazwa).join(', ')}"

    brakujacy = zwyciezcy.select { |g| g.liczba_kart.zero? }
    unless brakujacy.empty?
      wygrany = (@gracze - brakujacy).first
      wygrany.zabierz_karty_ze_stolu!(@stol.shuffle)
      puts "-> #{wygrany.nazwa} wygrywa, bo przeciwnikowi zabrakło kart!"
      return
      end

      zwyciezcy.each do |g|
        zakryte = [g.liczba_kart - 1, KARTY_ZAKRYTE].min
        zakryte.times { @stol << g.wyloz_karte }
        karta_wojny = g.wyloz_karte
        @stol << karta_wojny
        puts "#{g.nazwa} odsłania kartę wojny: #{karta_wojny} (pozostało #{g.liczba_kart})"
      end

      @stol.compact!   # usuwa ewentualne nil-e, gdyby jakimś cudem się pojawiły
      rozstrzygnij_konflikt(@stol.last(zwyciezcy.size))
    end
  end

  def koniec?
    @gracze.count { |g| g.liczba_kart.positive? } <= 1
  end

  def zwyciezca
    @gracze.max_by(&:liczba_kart)
  end

  def oglos_wynik
    if zwyciezca.liczba_kart.zero?
      puts "\n>>> REMIS – skończyły się wszystkie karty!"
    else
      puts "\n>>> ZWYCIĘZCĄ ZOSTAJE #{zwyciezca.nazwa}! Zebrał(a) #{zwyciezca.liczba_kart} kart."
    end
  end
end # koniec klasy Gra

# ---------------------
# Sekcja uruchomieniowa
# ---------------------
if __FILE__ == $PROGRAM_NAME
  tryb = (ARGV[0] || 'czlowiek-komputer').downcase

  gracze = case tryb
           when 'ai-ai', 'komputer-komputer', 'komp-komp'
             [GraczKomputer.new('Bot-A'), GraczKomputer.new('Bot-B')]
           else                         # domyślnie: człowiek vs komputer
             [GraczCzlowiek.new('Ty'),  GraczKomputer.new('RubyBot')]
           end

  Gra.new(gracze).uruchom
end
