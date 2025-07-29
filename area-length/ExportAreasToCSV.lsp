(defun c:ExportAreasToCSV (/ selset ent obj-area file path)
  ;; Kullanıcıdan Polyline nesnelerini seçmesini iste
  (setq selset (ssget '((0 . "LWPOLYLINE,POLYLINE")))) ;; Sadece Polyline türlerini seç
  (if selset
    (progn
      ;; Dosya adı ve yolu oluştur
      (setq path (strcat (getvar "DWGPREFIX") "Area_Info.csv")) ;; Çizimin bulunduğu klasöre kaydedilecek
      (setq file (open path "w")) ;; Yazma modu ile dosyayı aç

      (if file
        (progn
          ;; Başlığı yaz
          (write-line "Alan" file) ;; Alan başlığı

          ;; Seçim kümesindeki her nesne için işlem yap
          (repeat (sslength selset)
            (setq ent (vlax-ename->vla-object (ssname selset 0))) ;; Seçili nesneyi al

            ;; Polyline'in alanını al
            (setq obj-area (vla-get-area ent)) ;; Alan bilgisi

            ;; Alan bilgisini dosyaya yaz
            (write-line (rtos obj-area 2 2) file)

            ;; Bir sonraki nesneye geç
            (setq selset (ssdel (ssname selset 0) selset))
          )

          ;; Dosyayı kapat
          (close file)
          (prompt (strcat "\nAlan bilgileri '" path "' dosyasına kaydedildi."))
        )
        (prompt "\nCSV dosyası oluşturulamadı.")
      )
    )
    (prompt "\nBir Polyline seçilmedi ya da geçersiz seçim yapıldı!")
  )
  (princ)
)
