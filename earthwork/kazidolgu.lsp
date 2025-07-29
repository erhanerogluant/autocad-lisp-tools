(defun c:kazidolgu ()
  "Kazı ve dolgu hacimlerini hesaplayan Lisp fonksiyonu"

  ; Kullanıcıdan renk seçimini iste
  (setq renk (getstring "\nRenk seçiniz (Kırmızı/Siyah): "))
  (cond
    ((or (strcasecomp renk "Kırmızı") (strcasecomp renk "K"))
     (setq renk-kod 1))
    ((or (strcasecomp renk "Siyah") (strcasecomp renk "S"))
     (setq renk-kod 7))
    (t
     (princ "\nGeçersiz renk seçimi! (Kırmızı/Siyah)")
     (exit)))

  ; Kotları seçme ve değerleri listeye alma
  (princ (strcat "\n" renk " kotları seçin (Seçimi bitirdikten sonra Enter'a basın):"))
  (setq kotlar (ssget '((0 . "TEXT") (62 . renk-kod))))
  (setq kot-sayisi (sslength kotlar))
  (setq kot-listesi nil)
  (repeat kot-sayisi
    (setq nesne (ssname kotlar i))
    (setq deger (cdr (assoc 1 (entget nesne))))
    (if (numberp (atof deger))
      (setq kot-listesi (append kot-listesi (list (atof deger))))
      (princ (strcat "\nHata: " nesne " nesnesi bir sayı içermiyor.")))
    (setq i (1+ i))
  )

  ; Terasman kotlarını seçme (benzer şekilde)
  (princ "\nTerasman kotlarını seçin (Seçimi bitirdikten sonra Enter'a basın):")
  (setq terasman-kotlar (ssget '((0 . "TEXT") (62 . 2))))
  ; ... (terasman kotlarının işlenmesi, kot-listesi'ne eklenmesi)

  ; Yol genişliği ve uzunluğunu al
  (setq yol-genisligi (getreal "\nYol genişliğini giriniz: "))
  (setq yol-uzunlugu (getreal "\nYol uzunluğunu giriniz: "))

  ; Hacim hesaplama fonksiyonu
  (defun hesapla-hacim (kirmizi-kot siyah-kot terasman-kot)
    (setq dolgu (- terasman-kot kirmizi-kot))
    (setq kazı (- siyah-kot terasman-kot))
    (list (* dolgu yol-genisligi yol-uzunlugu) (* kazı yol-genisligi yol-uzunlugu))
  )

  ; Toplam hacim hesaplaması
  (setq toplam-dolgu 0)
  (setq toplam-kazi 0)
  (repeat kot-sayisi
    (setq hacimler (hesapla-hacim (nth (1- i) kot-listesi)
                                 (nth (1- i) siyah-kotlar)
                                 (nth (1- i) terasman-kotlar)))
    (setq toplam-dolgu (+ toplam-dolgu (car hacimler)))
    (setq toplam-kazi (+ toplam-kazi (cadr hacimler)))
  )

  ; Sonuçları yazdırma
  (princ (strcat "\nToplam Dolgu Hacmi: " (rtos toplam-dolgu 2 2) " m³"))
  (princ (strcat "\nToplam Kazı Hacmi: " (rtos toplam-kazi 2 2) " m³"))
)
(load "kazidolgu.lsp") ; Dosyayı yüklemek için
(c:kazidolgu) ; Fonksiyonu çalıştırmak için