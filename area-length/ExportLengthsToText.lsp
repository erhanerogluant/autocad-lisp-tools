(defun c:ExportLengthsToText (/ selset ent obj-length file path)
  ;; Kullanıcıdan Line veya Polyline seçmesini iste
  (setq selset (ssget '((0 . "LINE,POLYLINE,LWPOLYLINE")))) ;; Sadece Line ve Polyline'lar
  (if selset
    (progn
      ;; Dosya adı ve yolu oluştur
      (setq path (strcat (getvar "DWGPREFIX") "Lengths_Info.txt")) ;; Çizimin bulunduğu klasöre kaydedilecek
      (setq file (open path "w")) ;; Yazma modu ile dosyayı aç

      (if file
        (progn
          ;; Seçim kümesindeki her nesne için işlem yap
          (repeat (sslength selset)
            (setq ent (vlax-ename->vla-object (ssname selset 0))) ;; Seçili nesneyi al
            ;; Uzunluğu al
            (setq obj-length 
                  (cond
                    ((= (vla-get-objectname ent) "AcDbLine") ;; Eğer Line ise
                     (distance (vlax-safearray->list (vlax-variant-value (vla-get-startpoint ent)))
                               (vlax-safearray->list (vlax-variant-value (vla-get-endpoint ent)))))
                    ((or (= (vla-get-objectname ent) "AcDbPolyline") ;; Eğer Polyline ise
                         (= (vla-get-objectname ent) "AcDb2dPolyline"))
                     (vla-get-length ent))
                    (t 0) ;; Desteklenmeyen türler için uzunluk 0
                  )
            )
            ;; Uzunluğu dosyaya yaz
            (write-line (strcat "Object Length: " (rtos obj-length 2 2)) file)
            ;; Bir sonraki nesneye geç
            (setq selset (ssdel (ssname selset 0) selset))
          )
          ;; Dosyayı kapat
          (close file)
          (prompt (strcat "\nUzunluk bilgileri '" path "' dosyasına kaydedildi."))
        )
        (prompt "\nMetin dosyası oluşturulamadı.")
      )
    )
    (prompt "\nBir Line veya Polyline seçilmedi ya da geçersiz seçim yapıldı!")
  )
  (princ)
)
