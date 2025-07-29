(defun c:EXPORTTEXTCONTENTSTOTEXT (/ selset obj filePath txt objType row textFile)
  (setq selset (ssget)) ; Seçim yap
  (if selset
    (progn
      ;; Kullanıcıya dosya konumu seçtirmek
      (setq filePath (getfiled "Kaydetmek için Metin dosyası seçin" "C:\\Users\\Public\\TextContents.txt" "txt" 1))
      (if filePath
        (progn
          ;; Metin dosyasını aç
          (setq textFile (open filePath "w"))
          
          ;; Başlık satırını yaz
          (write-line "Text Contents" textFile)
          
          ;; Seçilen nesneleri kontrol et
          (repeat (sslength selset)
            (setq obj (vlax-ename->vla-object (ssname selset 0)))
            
            ;; Nesne tipini kontrol et (Text veya MText)
            (setq objType (vla-get-ObjectName obj))
            (cond
              ((or (equal objType "AcDbText") (equal objType "AcDbMText"))
               ;; Text veya MText içeriğini al
               (setq txt (if (vlax-property-available-p obj 'TextString)
                             (vla-get-TextString obj)
                             ""))
               
               ;; Text dosyasına yaz
               (write-line txt textFile)
              )
              (t (princ (strcat "\nAtlanan obje tipi: " objType))) ;; Diğer nesne türlerini atla
            )
            
            ;; Seçim setinden nesneyi kaldır
            (setq selset (ssdel (ssname selset 0) selset))
          )
          
          ;; Dosyayı kapat
          (close textFile)
          
          ;; Kullanıcıya bilgi ver
          (princ (strcat "\nMetin içeriği başarıyla kaydedildi: " filePath))
        )
        (princ "\nKaydetme işlemi iptal edildi.")
      )
    )
    (prompt "\nLütfen nesneleri seçin.")
  )
  (princ)
)
