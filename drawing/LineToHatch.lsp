(defun c:LineToHatch ()
  (prompt "\nKapalı bir poligon oluşturmak için çizgileri seçin.")
  
  ;; Kullanıcıdan seçim al
  (setq ss (ssget '((0 . "LINE")))) ; Sadece çizgileri seç
  
  ;; Seçim kontrolü
  (if (and ss (> (sslength ss) 0))
    (progn
      ;; Seçilen çizgileri listeye dönüştür
      (setq line-list (mapcar 'cadr (ssnamex ss)))
      
      ;; Poligon oluştur
      (vl-cmdf "_.PEDIT" (car line-list) "Y" (apply 'vl-cmdf (append line-list (list "" ""))))
      (prompt "\nPoligon oluşturuldu.")
      
      ;; Hatch işlemi
      (prompt "\nHatch uygulanıyor...")
      (vl-cmdf "_.HATCH" "_ANSI31" "" (car line-list) "")
      (prompt "\nHatch başarıyla uygulandı!")
    )
    (prompt "\nHiç çizgi seçilmedi veya seçim geçerli değil!")
  )
  (princ)
)
