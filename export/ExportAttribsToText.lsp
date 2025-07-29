(defun c:ExportAttribsToText (/ selset ent attribs tag prompt value file path)
  ;; Kullanıcının bir nesne seçmesini sağla (blok referansı)
  (setq selset (ssget '((0 . "INSERT")))) ;; Sadece blokları seç
  (if selset
    (progn
      ;; Seçilen nesneyi al
      (setq ent (vlax-ename->vla-object (ssname selset 0)))
      
      ;; Nesne bir BlockReference olmalı (blok referansı)
      (if (= (vla-get-objectname ent) "AcDbBlockReference")
        (progn
          ;; Nesnedeki attributeları al (gerçekten attribute nesneleri)
          (setq attribs (vla-get-attributes ent))
          
          ;; Dosya adı ve yolu oluştur
          (setq path (strcat (getvar "DWGPREFIX") "Attributes_Info.txt")) ;; Çizimin bulunduğu klasöre kaydet
          (setq file (open path "w")) ;; Yazma modu ile dosyayı aç
          
          (if file
            (progn
              ;; Her attribute için tag, prompt ve value bilgilerini yaz
              (vlax-for attrib attribs
                (setq tag (vla-get-tagstring attrib))
                (setq prompt (vla-get-promptstring attrib))
                (setq value (vla-get-textstring attrib))
                ;; Text dosyasına yazma
                (write-line (strcat "Tag: " tag " | Prompt: " prompt " | Value: " value) file)
              )
              (close file) ;; Dosyayı kapat
              (prompt (strcat "\nAttributes bilgileri '" path "' dosyasına kaydedildi."))
            )
            (prompt "\nMetin dosyası oluşturulamadı.")
          )
        )
        (prompt "\nSeçilen nesne bir blok referansı değil!")
      )
    )
    ;; Seçim yapılmazsa uyarı ver
    (prompt "\nBir blok seçilmedi ya da geçersiz seçim yapıldı!")
  )
  (princ)
)
