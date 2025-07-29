(defun c:ExportAreaAndPerimeterToCSV (/ selset ent obj-length obj-area file path)
  ;; Kullanıcıdan Polyline nesnelerini seçmesini iste
  (setq selset (ssget '((0 . "LWPOLYLINE,POLYLINE")))) ;; Sadece Polyline türlerini seç
  (if selset
    (progn
      ;; Dosya adı ve yolu oluştur
      (setq path (strcat (getvar "DWGPREFIX") "Area_Perimeter_Info.csv")) ;; Çizimin bulunduğu klasöre kaydedilecek
      (setq file (open path "w")) ;; Yazma modu ile dosyayı aç

      (if file
        (progn
          ;; Başlıkları yaz
          (write-line "Alan,Çevre" file) ;; CSV formatında başlıklar

          ;; Seçim kümesindeki her nesne için işlem yap
          (repeat (sslength selset)
            (setq ent (vlax-ename->vla-object (ssname selset 0))) ;; Seçili nesneyi al

            ;; Polyline'in çevresini ve alanını al
            (setq obj-length (vla-get-length ent)) ;; Çevre uzunluğu
            (setq obj-area (vla-get-area ent))     ;; Alan bilgisi

            ;; Alan ve çevre bilgilerini CSV formatında yaz
            (write-line (strcat (rtos obj-area 2 2) "," (rtos obj-length 2 2)) file)

            ;; Bir sonraki nesneye geç
            (setq selset (ssdel (ssname selset 0) selset))
          )

          ;; Dosyayı kapat
          (close file)
          (prompt (strcat "\nAlan ve çevre bilgileri '" path "' dosyasına kaydedildi."))
        )
        (prompt "\nCSV dosyası oluşturulamadı.")
      )
    )
    (prompt "\nBir Polyline seçilmedi ya da geçersiz seçim yapıldı!")
  )
  (princ)
)
