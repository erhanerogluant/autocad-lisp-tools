(defun c:OffsetByMeasurement ()
  (prompt "\nOfset uygulamak istediğiniz çizgiyi seçin.")
  
  ;; Kullanıcıdan çizgi veya nesne seçmesini iste
  (setq obj (entsel "\nÇizgiyi veya nesneyi seçin: "))
  
  ;; Eğer nesne seçildiyse işlemlere devam et
  (if obj
    (progn
      ;; Kullanıcıya seçenek sun
      (prompt "\nOfset mesafesini seçin: 1) 0.08 (8 cm), 2) 0.10 (10 cm).")
      
      ;; Kullanıcının seçimini al
      (setq choice (getint "\nSeçiminiz (1 veya 2): "))
      
      ;; Ofset mesafesini belirle
      (setq distance 
            (cond
              ((= choice 1) 0.08)  ; 1. seçenek: 0.08 (8 cm)
              ((= choice 2) 0.10)  ; 2. seçenek: 0.10 (10 cm)
              (T nil)))            ; Geçersiz seçim için nil
      
      ;; Eğer geçerli bir mesafe seçildiyse ofset işlemini uygula
      (if distance
        (progn
          ;; Ofset işlemini çalıştır
          (vl-cmdf "_.OFFSET" (rtos distance 2 3) obj "")
          (prompt (strcat "\nOfset işlemi başarıyla tamamlandı: " (rtos distance 2 3) " birim."))
        )
        (prompt "\nHatalı seçim yaptınız, işlem iptal edildi!")
      )
    )
    (prompt "\nNesne seçilmedi, işlem iptal edildi!")
  )
  (princ)
)
