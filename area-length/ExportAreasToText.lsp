(defun c:ExportAreasToText (/ selset count ent areas file path)
  ;; Kullanıcının Polyline'ları seçmesini sağla
  (setq selset (ssget '((0 . "LWPOLYLINE")))) ;; Sadece Polyline'ları seç
  (if selset
    (progn
      ;; Alanları saklamak için bir liste oluştur
      (setq areas '())
      ;; Seçim setindeki her Polyline'ı işleme al
      (setq count 0)
      (while (< count (sslength selset))
        ;; Seçilen her Polyline nesnesini al
        (setq ent (vlax-ename->vla-object (ssname selset count)))
        ;; Alanı kontrol et ve listeye ekle
        (if (and (vlax-property-available-p ent 'Area) (> (vla-get-area ent) 0))
          (setq areas (append areas (list (rtos (vla-get-area ent) 2 2)))) ;; Alanı listeye ekle, 2 ondalık basamak
        )
        (setq count (1+ count)) ;; Sonraki nesneye geç
      )
      ;; Dosya adı ve yolu oluştur
      (setq path (strcat (getvar "DWGPREFIX") "Polyline_Areas.txt")) ;; Çizimin bulunduğu klasöre kaydet
      (setq file (open path "w")) ;; Yazma modu ile dosyayı aç
      (if file
        (progn
          ;; Alanları dosyaya yaz
          (foreach area areas
            (write-line area file)
          )
          (close file) ;; Dosyayı kapat
          (prompt (strcat "\nToplam " (itoa (length areas)) " Polyline alanı '" path "' dosyasına kaydedildi."))
        )
        (prompt "\nMetin dosyası oluşturulamadı.")
      )
    )
    ;; Seçim yapılmazsa uyarı ver
    (prompt "\nPolyline seçilmedi ya da geçersiz seçim yapıldı!")
  )
  (princ)
)
