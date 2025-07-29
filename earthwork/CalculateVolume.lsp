(defun c:CalculateVolume ()
  (setq drawing-path (getvar "DWGPREFIX")) ;; Çizim dosyasının bulunduğu yol
  (setq output-file (strcat drawing-path "CrossSection_Report.txt")) ;; Çıkış dosyası adı

  ;; Dosyayı oluştur
  (setq file (open output-file "w"))
  (if file
    (progn
      ;; Başlıkları dosyaya yaz
      (write-line "ENKESİT ALAN VE HACİM RAPORU" file)
      (write-line "===========================" file)
      (write-line "" file)

      ;; Kullanıcıdan obje seçimi
      (prompt "\nAlanlarını hesaplamak için Line veya Polyline objelerini seçin: ")
      (setq entList (ssget '((0 . "LINE,POLYLINE,LWPOLYLINE")))) ;; Sadece line/polyline seçimi

      (if entList
        (progn
          (setq count 0 failed 0 total-area 0.0 prev-area 0.0 total-volume 0.0)
          (setq spacing (getreal "\nAra mesafeyi girin (ör. 10 metre): "))
          (if (not spacing) (setq spacing 1.0)) ;; Varsayılan mesafe: 1

          ;; Her obje için işlem
          (repeat (sslength entList)
            (setq obj (vlax-ename->vla-object (ssname entList count)))

            ;; Çizgileri extend edip kapalı polyline oluşturmayı dene
            (setq closed-poly (extend-lines-to-closed-polyline obj))

            (if closed-poly
              (progn
                ;; Alanı hesapla
                (setq area (vla-get-area (vlax-ename->vla-object closed-poly)))
                (setq total-area (+ total-area area))

                ;; Hacmi hesapla (alan * mesafe)
                (if (> count 0)
                  (setq volume (* spacing (/ (+ prev-area area) 2.0))) ;; Trapezoidal hacim hesabı
                  (setq volume 0.0)) ;; İlk alanın hacmi sıfırdır
                (setq total-volume (+ total-volume volume))

                ;; Rapor dosyasına yaz
                (write-line (strcat "Sıra: " (itoa count) " - Alan: " (rtos area 2 2) " m², Hacim: " (rtos volume 2 2) " m³") file)
                (setq prev-area area) ;; Bir sonraki işlem için alanı kaydet
              )
              (progn
                (setq failed (1+ failed))
                (write-line (strcat "Sıra: " (itoa count) " - Hesaplanamadı: Kapalı alan oluşturulamadı.") file)
              )
            )
            (setq count (1+ count))
          )
          ;; Genel sonuçları yaz
          (write-line "" file)
          (write-line (strcat "Toplam işlenen obje sayısı: " (itoa count)) file)
          (write-line (strcat "Hesaplanamayan obje sayısı: " (itoa failed)) file)
          (write-line (strcat "Toplam Alan: " (rtos total-area 2 2) " m²") file)
          (write-line (strcat "Toplam Hacim: " (rtos total-volume 2 2) " m³") file)
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

(defun extend-lines-to-closed-polyline (entity)
  ;; Verilen çizgiyi extend ederek kapalı bir polyline oluştur
  (if (and entity (or (eq (vla-get-objectname entity) "AcDbLine")
                      (eq (vla-get-objectname entity) "AcDbPolyline")))
    (progn
      ;; Extend işlemi için geçici bir seçim seti oluştur
      (setq temp-set (ssadd))
      (ssadd (vlax-vla-object->ename entity) temp-set)

      ;; Polyline oluştur ve birleştir
      (command "_.pedit" "m" temp-set "y" "j" "" "") ;; Çizgileri polyline yap ve birleştir
      (setq closed-poly (entlast)) ;; Son oluşturulan objeyi al

      ;; Eğer kapalı bir polyline oluştuysa geri döndür
      (if (and closed-poly (= (vla-get-closed (vlax-ename->vla-object closed-poly)) :vlax-true))
        closed-poly ;; Kapalı polyline'ı döndür
        nil ;; Eğer kapalı değilse nil döndür
      )
    )
    nil ;; Eğer uygun obje değilse nil döndür
  )
)
