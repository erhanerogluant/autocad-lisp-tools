(defun c:ExportPerimetersToCSV (/ selset ent obj-length file path)
  ;; Kullanıcıdan Polyline nesnelerini seçmesini iste
  (setq selset (ssget '((0 . "LWPOLYLINE,POLYLINE")))) ;; Sadece Polyline türlerini seç
  (if selset
    (progn
      ;; Dosya adı ve yolu oluştur
      (setq path (strcat (getvar "DWGPREFIX") "Perimeter_Info.csv")) ;; Çizimin bulunduğu klasöre kaydedilecek
      (setq file (open path "w")) ;; Yazma modu ile dosyayı aç

      (if file
        (progn
          ;; Başlığı yaz
          (write-line "Çevre" file) ;; Çevre başlığı

          ;; Seçim kümesindeki her nesne için işlem yap
          (repeat (sslength selset)
            (setq ent (vlax-ename->vla-object (ssname selset 0))) ;; Seçili nesneyi al

            ;; Polyline'in çevresini al
            (setq obj-length (vla-get-length ent)) ;; Çevre uzunluğu

            ;; Çevre bilgisini dosyaya yaz
            (write-line (rtos obj-length 2 2) file)

            ;; Bir sonraki nesneye geç
            (setq selset (ssdel (ssname selset 0) selset))
          )

          ;; Dosyayı kapat
          (close file)
          (prompt (strcat "\nÇevre bilgileri '" path "' dosyasına kaydedildi."))
        )
        (prompt "\nCSV dosyası oluşturulamadı.")
      )
    )
    (prompt "\nBir Polyline seçilmedi ya da geçersiz seçim yapıldı!")
  )
  (princ)
)
