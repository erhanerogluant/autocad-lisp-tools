(defun c:OffsetWithDirection ()
  (prompt "\nOfset uygulamak istediğiniz çizgiyi seçin.")
  
  ;; Kullanıcıdan çizgi veya nesne seçmesini iste
  (setq obj (entsel "\nÇizgiyi seçin: "))
  
  ;; Eğer nesne seçildiyse işlemlere devam et
  (if obj
    (progn
      ;; Kullanıcıya seçenek sun
      (prompt "\nOfset mesafesini seçin: 1) 0.08 (8 cm), 2) 0.10 (10 cm).")
      
      ;; Kullanıcının mesafe seçimini al
      (setq choice (getint "\nSeçiminiz (1 veya 2): "))
      
      ;; Ofset mesafesini belirle
      (setq distance 
            (cond
              ((= choice 1) 0.08)  ; 1. seçenek: 0.08 (8 cm)
              ((= choice 2) 0.10)  ; 2. seçenek: 0.10 (10 cm)
              (T nil)))            ; Geçersiz seçim için nil
      
      ;; Eğer geçerli bir mesafe seçildiyse devam et
      (if distance
        (progn
          ;; Kullanıcıdan yön belirlemek için bir nokta seçmesini iste
          (setq pickPoint (getpoint "\nOfset yönünü belirlemek için bir nokta seçin: "))
          
          ;; Eğer nokta seçildiyse ofset işlemini uygula
          (if pickPoint
            (progn
              ;; Ofset işlemini çalıştır
              (vl-cmdf "_.OFFSET" (rtos distance 2 3) obj pickPoint "")
              (prompt (strcat "\nOfset işlemi başarıyla tamamlandı: " (rtos distance 2 3) " birim."))
            )
            (prompt "\nYön belirlemek için nokta seçilmedi, işlem iptal edildi!")
          )
        )
        (prompt "\nHatalı seçim yaptınız, işlem iptal edildi!")
      )
    )
    (prompt "\nNesne seçilmedi, işlem iptal edildi!")
  )
  (princ)
)
