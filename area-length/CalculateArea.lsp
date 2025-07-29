(defun c:CalculateArea ()
  (setq drawing-path (getvar "DWGPREFIX")) ;; Çizim dosyasının bulunduğu yol
  (setq output-file (strcat drawing-path "Area_Calculation_Report.txt")) ;; Çıkış dosyası adı

  ;; Dosyayı oluştur
  (setq file (open output-file "w"))
  (if file
    (progn
      (write-line "ALAN HESAPLAMA RAPORU" file)
      (write-line "====================" file)
      (write-line "" file)

      ;; Kullanıcıdan obje seçimi
      (prompt "\nKapalı alanları oluşturmak için Line objelerini seçin: ")
      (setq entList (ssget '((0 . "LINE")))) ;; Seçim seti (sadece LINE objeleri)

      (if entList
        (progn
          (setq count 0 failed 0)
          (repeat (sslength entList)
            (setq obj (vlax-ename->vla-object (ssname entList count)))

            ;; LINE objelerini extend ederek kapalı bir alan oluşturmayı dene
            (setq extended-poly (extend-lines-to-closed-polyline (ssget '((0 . "LINE")))))

            (if extended-poly
              (progn
                (setq area (vla-get-area (vlax-ename->vla-object extended-poly)))
                (write-line (strcat "Sıra: " (itoa count) " - Alan: " (rtos area 2 2) " m²") file)
              )
              (progn
                (setq failed (1+ failed))
                (write-line (strcat "Sıra: " (itoa count) " - Hesaplanamadı: Kapalı alan oluşturulamadı.") file)
              )
            )
            (setq count (1+ count))
          )
          (write-line "" file)
          (write-line (strcat "Toplam işlenen obje sayısı: " (itoa count)) file)
          (write-line (strcat "Hesaplanamayan obje sayısı: " (itoa failed)) file)
        )
        (write-line "\nHiç uygun obje seçilmedi!" file)
      )
      (close file)
      (princ (strcat "\nRapor oluşturuldu: " output-file))
    )
    (prompt "\nDosya oluşturulamadı!")
  )
  (princ)
)

(defun extend-lines-to-closed-polyline (selSet)
  ;; Çizgileri birbirine extend ederek kapalı bir polyline oluştur
  (if selSet
    (progn
      (command "_.pedit" "m" selSet "y" "j" "" "") ;; Çizgileri polyline yap ve birleştir
      (setq closed-poly (entlast)) ;; Son oluşturulan objeyi al
      (if (and closed-poly (= (vla-get-closed (vlax-ename->vla-object closed-poly)) :vlax-true))
        closed-poly ;; Kapalı polyline'ı döndür
        nil ;; Eğer kapalı değilse nil döndür
      )
    )
    nil ;; Eğer seçim yoksa nil döndür
  )
)
