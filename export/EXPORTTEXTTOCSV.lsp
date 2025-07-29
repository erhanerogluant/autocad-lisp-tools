(defun c:EXPORTTEXTTOCSV (/ selset obj filePath txt objType textFile cleanText cleanList finalText)

  ;; Kullanıcıdan metinleri seçmesini iste
  (setq selset (ssget '((0 . "TEXT,MTEXT"))))

  (if selset
    (progn
      ;; Dosya kaydetme konumunu sor
      (setq filePath (getfiled "CSV dosyasını kaydet" "C:\\Users\\Public\\TextContents.csv" "csv" 1))
      (if filePath
        (progn
          ;; CSV dosyasını yazma modunda aç
          (setq textFile (open filePath "w"))

          ;; Seçilen nesneleri işle
          (repeat (sslength selset)
            (setq obj (vlax-ename->vla-object (ssname selset 0)))
            (setq objType (vla-get-ObjectName obj))

            ;; Text veya MText içeriğini al
            (setq txt (if (vlax-property-available-p obj 'TextString)
                         (vla-get-TextString obj)
                         ""))

            ;; Temizleme işlemleri
            (setq cleanText (vl-string-subst " " "ƒ" txt))  ;; "ƒ" yerine boşluk koy
            (setq cleanText (vl-string-subst "" "ÿ" cleanText)) ;; "ÿ" tamamen kaldır
            (setq cleanText (vl-string-subst "" "l=" cleanText))  ;; "l=" kısmını kaldır
            (setq cleanText (vl-string-subst "" "mon." cleanText)) ;; "mon." kaldır
            (setq cleanText (vl-string-subst "" "gov." cleanText)) ;; "gov." kaldır
            (setq cleanText (vl-string-subst "" "etr." cleanText)) ;; "etr." kaldır
            (setq cleanText (vl-string-subst "" "/12" cleanText))  ;; "/12" kaldır

            ;; Veriyi liste olarak ayır (boşluk karakterlerine göre böl)
            (setq cleanList (vl-remove "" (vl-string-split cleanText " ")))

            ;; Eğer en az 3 eleman varsa, CSV formatına uygun şekilde yaz
            (if (>= (length cleanList) 3)
              (progn
                (setq finalText (strcat (nth 0 cleanList) "," (nth 1 cleanList) "," (nth 2 cleanList))) ;; CSV formatı
                (write-line finalText textFile)
              )
            )

            ;; Seçim setinden nesneyi kaldır
            (setq selset (ssdel (ssname selset 0) selset))
          )

          ;; Dosyayı kapat
          (close textFile)

          ;; Kullanıcıya bilgi ver
          (princ (strcat "\nVeriler başarıyla CSV formatında kaydedildi: " filePath))
        )
        (princ "\nKaydetme işlemi iptal edildi.")
      )
    )
    (prompt "\nLütfen metin nesnelerini seçin.")
  )
  (princ)
)
