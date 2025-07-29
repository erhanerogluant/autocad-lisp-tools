(defun c:CalculateExcavationArea (/ ss line1 line2 pt1 pt2 pt3 pt4 extPt1 extPt2 extLine1 extLine2 intersection area)
  ;; Kullanıcıdan çizgileri seçmesini iste
  (setq ss (ssget '((0 . "LINE")))) ; Sadece çizgiler seçilebilir

  ;; Seçilen çizgileri al
  (setq line1 (entget (ssname ss 0)))
  (setq line2 (entget (ssname ss 1)))

  ;; Çizgilerin başlangıç ve bitiş noktalarını al (Yalnızca X ve Y koordinatları)
  (setq pt1 (list (cdr (assoc 10 line1)) (cdr (assoc 20 line1)))) ; X ve Y al
  (setq pt2 (list (cdr (assoc 11 line1)) (cdr (assoc 21 line1)))) ; X ve Y al
  (setq pt3 (list (cdr (assoc 10 line2)) (cdr (assoc 20 line2)))) ; X ve Y al
  (setq pt4 (list (cdr (assoc 11 line2)) (cdr (assoc 21 line2)))) ; X ve Y al

  ;; Çizgileri manuel olarak uzatma (Yalnızca X ve Y koordinatları kullanılarak)
  (setq extPt1 (list (+ (car pt1) 100) (cadr pt1))) ; 100 birim kadar uzatma
  (setq extPt2 (list (+ (car pt2) 100) (cadr pt2)))

  ;; Uzatılan çizgileri oluştur
  (setq extLine1 (list pt1 extPt1))
  (setq extLine2 (list pt3 extPt2))

  ;; Alan hesaplaması: iki nokta arasındaki mesafe
  (setq area (distance pt1 pt3))

  ;; Sonuçları yazdır
  (princ (strcat "\nKazı alanı hesaplandı: " (rtos area 2 2) " birim."))
)

(princ "\nKodu yüklemek için Enter'a basın.")
