(defun c:CALCSECTIONAREA ( / line1 line2 start1 end1 start2 end2 area )
  (setq area 0)

  ;; Kullanıcıdan yol kenar çizgilerini seçme
  (princ "\nYol kenar çizgilerini seçin (Birden fazla seçim yapın, sonrasında Enter'a basın):")
  (setq line1 (list)) ; Yol kenar çizgileri için boş liste başlatıyoruz
  (while (setq obj (car (entsel)))
    (setq line1 (cons obj line1))) ; Yol kenar çizgilerini listeye ekliyoruz

  ;; Kullanıcıdan kaldırım kenar çizgilerini seçme
  (princ "\nKaldırım kenar çizgilerini seçin (Birden fazla seçim yapın, sonrasında Enter'a basın):")
  (setq line2 (list)) ; Kaldırım kenar çizgileri için boş liste başlatıyoruz
  (while (setq obj (car (entsel)))
    (setq line2 (cons obj line2))) ; Kaldırım kenar çizgilerini listeye ekliyoruz

  ;; Çizgilerin koordinatlarını alma
  (setq start1 (vlax-curve-getstartpoint (vlax-ename->vla-object (car line1))))
  (setq end1 (vlax-curve-getendpoint (vlax-ename->vla-object (car line1))))
  (setq start2 (vlax-curve-getstartpoint (vlax-ename->vla-object (car line2))))
  (setq end2 (vlax-curve-getendpoint (vlax-ename->vla-object (car line2))))

  ;; Alan hesaplama
  (setq area (+ area (* (distance start1 end1) (distance start2 end2))))

  ;; Sonucu yazdırma
  (princ (strcat "\nToplam Enkesit Alanı: " (rtos area 2 2) " m²"))
  (princ)
)

(princ "\nYol Enkesit Alanı Hesaplama Komutu Yüklenmiştir!")
(princ)
