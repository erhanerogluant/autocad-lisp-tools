(defun c:ExtendAndHatch ()
  (prompt "\nSiyah çizgiyi sınır olarak seçin.")
  
  ;; Kullanıcıdan siyah çizgiyi sınır olarak seçmesini iste
  (setq boundary (entsel "\nBir siyah çizgi seçin: "))
  
  ;; Sınır seçildiyse
  (if boundary
    (progn
      ;; Çizgi seçimini al
      (prompt "\nUzatılacak terasman çizgilerini seçin.")
      (setq ss (ssget '((0 . "LINE")))) ; Sadece LINE türündeki nesneleri seç
      
      ;; Çizgiler seçildiyse
      (if (and ss (> (sslength ss) 0))
        (progn
          ;; Boundary ve seçilen çizgiler üzerinde extend işlemi
          (foreach line (mapcar 'cadr (ssnamex ss))
            (vl-cmdf "_.EXTEND" (car boundary) "" line "")
          )
          
          ;; Poligon oluşturma
          (prompt "\nPoligon oluşturuluyor...")
          (setq polyline (vl-cmdf "_.PLINE" "")) ; Poligon oluştur
          
          ;; Hatch işlemi
          (prompt "\nHatch uygulanıyor...")
          (vl-cmdf "_.HATCH" "_ANSI31" "" polyline "")
          (prompt "\nHatch başarıyla uygulandı!")
        )
        (prompt "\nHiçbir çizgi seçilmedi veya seçim geçerli değil!")
      )
    )
    (prompt "\nSiyah çizgi sınır olarak seçilmedi!")
  )
  (princ)
)
