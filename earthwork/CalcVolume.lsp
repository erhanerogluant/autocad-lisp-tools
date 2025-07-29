(defun c:CalcVolume (/ redKotLeft redKotRight blackKotLeft blackKotRight axisKotLeft axisKotRight terasmanKotLeft terasmanKotRight distance width volume leftHeight rightHeight)
  (princ "\n--- Yol Hacmi Hesaplama ---")

  ;; Kırmızı kotları al
  (setq redKotLeft (car (entsel "\nKırmızı kot (sol) textini seçin: ")))
  (if redKotLeft
    (setq redKotLeftValue (vla-get-textstring (vlax-ename->vla-object redKotLeft)))
    (progn
      (princ "\nSeçim yapılmadı. Lütfen geçerli bir metin nesnesi seçin.")
      (return) ;; Programı sonlandırma
    )
  )

  (setq redKotRight (car (entsel "\nKırmızı kot (sağ) textini seçin: ")))
  (if redKotRight
    (setq redKotRightValue (vla-get-textstring (vlax-ename->vla-object redKotRight)))
    (progn
      (princ "\nSeçim yapılmadı. Lütfen geçerli bir metin nesnesi seçin.")
      (return) ;; Programı sonlandırma
    )
  )

  ;; Siyah kotları al
  (setq blackKotLeft (car (entsel "\nSiyah kot (sol) textini seçin: ")))
  (if blackKotLeft
    (setq blackKotLeftValue (vla-get-textstring (vlax-ename->vla-object blackKotLeft)))
    (progn
      (princ "\nSeçim yapılmadı. Lütfen geçerli bir metin nesnesi seçin.")
      (return) ;; Programı sonlandırma
    )
  )

  (setq blackKotRight (car (entsel "\nSiyah kot (sağ) textini seçin: ")))
  (if blackKotRight
    (setq blackKotRightValue (vla-get-textstring (vlax-ename->vla-object blackKotRight)))
    (progn
      (princ "\nSeçim yapılmadı. Lütfen geçerli bir metin nesnesi seçin.")
      (return) ;; Programı sonlandırma
    )
  )

  ;; Eksen kotlarını al
  (setq axisKotLeft (car (entsel "\nEksendeki kot (sol) textini seçin: ")))
  (if axisKotLeft
    (setq axisKotLeftValue (vla-get-textstring (vlax-ename->vla-object axisKotLeft)))
    (progn
      (princ "\nSeçim yapılmadı. Lütfen geçerli bir metin nesnesi seçin.")
      (return) ;; Programı sonlandırma
    )
  )

  (setq axisKotRight (car (entsel "\nEksendeki kot (sağ) textini seçin: ")))
  (if axisKotRight
    (setq axisKotRightValue (vla-get-textstring (vlax-ename->vla-object axisKotRight)))
    (progn
      (princ "\nSeçim yapılmadı. Lütfen geçerli bir metin nesnesi seçin.")
      (return) ;; Programı sonlandırma
    )
  )

  ;; Terasman kotlarını al
  (setq terasmanKotLeft (car (entsel "\nTerasman kot (sol) textini seçin: ")))
  (if terasmanKotLeft
    (setq terasmanKotLeftValue (vla-get-textstring (vlax-ename->vla-object terasmanKotLeft)))
    (progn
      (princ "\nSeçim yapılmadı. Lütfen geçerli bir metin nesnesi seçin.")
      (return) ;; Programı sonlandırma
    )
  )

  (setq terasmanKotRight (car (entsel "\nTerasman kot (sağ) textini seçin: ")))
  (if terasmanKotRight
    (setq terasmanKotRightValue (vla-get-textstring (vlax-ename->vla-object terasmanKotRight)))
    (progn
      (princ "\nSeçim yapılmadı. Lütfen geçerli bir metin nesnesi seçin.")
      (return) ;; Programı sonlandırma
    )
  )

  ;; Yolun enkesitinin geometrik hesaplaması için kot farkları
  (setq leftHeight (- (atof redKotLeftValue) (atof axisKotLeftValue)))
  (setq rightHeight (- (atof redKotRightValue) (atof axisKotRightValue)))
  
  ;; Yolun enkesitindeki kot farklarını hesapla
  ;; Sağ ve sol kot farklarını alarak hacmi hesaplamak
  ;; Basit örnek: Yol hacmi hesaplaması için dikdörtgen hacmi
  ;; Hacim hesaplama: Yükseklik farkı * Mesafe * Genişlik
  
  (setq distance (getreal "\nAra mesafeyi girin (metre cinsinden): "))
  (setq width (getreal "\nYol genişliğini girin (metre cinsinden): "))

  ;; Hacim hesaplaması
  (setq volume (+ (* leftHeight distance width) (* rightHeight distance width))) ;; Sağ ve sol için hacmi topla
  
  ;; Sonuçları yazdır
  (princ (strcat "\nHacim: " (rtos volume 2 2) " m³"))
  
  (princ)
)

(princ "\nYol hacmi hesaplama komutunu çalıştırmak için 'CalcVolume' yazın.")
(princ)
