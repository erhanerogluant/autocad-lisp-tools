(defun c:CreatePolyHatch ()
  (prompt "\nPoligon oluşturma ve Hatch işlemi başlıyor...")
  
  ;; Kullanıcıdan noktaları toplama
  (defun get-points (points)
    (setq p (getpoint "\nNokta seçin (Bittiğinde ENTER): "))
    (if p
      (get-points (append points (list p)))
      points
    )
  )
  
  (setq points (get-points '()))
  
  ;; Eğer yeterli nokta yoksa işlemi sonlandır
  (if (< (length points) 3)
    (prompt "\nPoligon oluşturmak için en az 3 nokta gerekiyor!")
    
    ;; Poligon oluştur
    (progn
      (setq poly (vl-cmdf "_.PLINE"))
      (foreach pt points
        (vl-cmdf pt)
      )
      (vl-cmdf "C")  ; Poligonu kapat
      
      ;; Hatch işlemi
      (prompt "\nPoligon oluşturuldu. Hatch uygulanıyor...")
      (vl-cmdf "_.HATCH" "_ANSI31" "" poly "")
      
      (prompt "\nHatch başarıyla uygulandı!")
    )
  )
  (princ)
)
