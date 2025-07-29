(defun c:KAZIDOLGUHESAPLA ()
  ;; Kullanıcıdan Kırmızı Kotları seçmesini iste
  (princ "\nKırmızı Kot Textlerini seçin: ")
  (setq kırmızı-kotlar (ssget '((0 . "TEXT")))) ;; Sadece TEXT seç
  (if (not kırmızı-kotlar)
    (progn
      (princ "\nHiçbir Kırmızı Kot seçilmedi. Çıkılıyor...")
      (exit))) ;; Eğer seçim yapılmadıysa işlemi sonlandır

  ;; Kullanıcıdan Terasman Kotları seçmesini iste
  (princ "\nTerasman Kot Textlerini seçin: ")
  (setq terasman-kotlar (ssget '((0 . "TEXT")))) ;; Sadece TEXT seç
  (if (not terasman-kotlar)
    (progn
      (princ "\nHiçbir Terasman Kot seçilmedi. Çıkılıyor...")
      (exit))) ;; Eğer seçim yapılmadıysa işlemi sonlandır

  ;; Kullanıcıdan Siyah Kotları seçmesini iste
  (princ "\nSiyah Kot Textlerini seçin: ")
  (setq siyah-kotlar (ssget '((0 . "TEXT")))) ;; Sadece TEXT seç
  (if (not siyah-kotlar)
    (progn
      (princ "\nHiçbir Siyah Kot seçilmedi. Çıkılıyor...")
      (exit))) ;; Eğer seçim yapılmadıysa işlemi sonlandır

  ;; Kullanıcıdan ara mesafe ve yol genişliği iste
  (setq ara-mesafe (getreal "\nAra mesafeyi girin (örnek: 5.0): "))
  (if (not ara-mesafe)
    (progn
      (princ "\nGeçersiz ara mesafe girdiniz. Çıkılıyor...")
      (exit))) ;; Eğer geçerli değer girilmediyse işlemi sonlandır

  (setq yol-genislik (getreal "\nYol genişliğini girin (örnek: 100.0): "))
  (if (not yol-genislik)
    (progn
      (princ "\nGeçersiz yol genişliği girdiniz. Çıkılıyor...")
      (exit))) ;; Eğer geçerli değer girilmediyse işlemi sonlandır

  ;; Hacim hesaplama değişkenleri
  (setq kazı-hacmi 0.0)
  (setq dolgu-hacmi 0.0)

  ;; Kırmızı ve Terasman kotları arasında dolgu hesaplama
  (repeat (min (sslength kırmızı-kotlar) (sslength terasman-kotlar)))
    ;; Sol baştan sağa kadar seçim yapılacak
    (setq kırmızı-kot (atof (cdr (assoc 1 (entget (ssname kırmızı-kotlar 0)))))) ;; Kırmızı kotu al
    (setq terasman-kot (atof (cdr (assoc 1 (entget (ssname terasman-kotlar 0)))))) ;; Terasman kotu al

    ;; Dolgu hacmi hesaplama
    (if (> kırmızı-kot terasman-kot)
      (setq dolgu-hacmi (+ dolgu-hacmi (* (- kırmızı-kot terasman-kot) yol-genislik)))

    ;; Kotlar silin
    (setq kırmızı-kotlar (ssdel (ssname kırmızı-kotlar 0) kırmızı-kotlar))
    (setq terasman-kotlar (ssdel (ssname terasman-kotlar 0) terasman-kotlar)))

    ;; Terasman ve Siyah kotları arasında kazı hesaplama
    (repeat (min (sslength terasman-kotlar) (sslength siyah-kotlar))
    ;; Sol selece be just
