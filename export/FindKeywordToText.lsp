(defun c:FindKeywordInBlocksToText (/ keyword selset ent obj file path result blockRef)
  ;; Kullanıcıdan anahtar kelimeyi al
  (setq keyword (getstring "\nLütfen aramak istediğiniz anahtar kelimeyi girin: "))
  
  ;; Kullanıcıdan seçim yapmasını iste
  (setq selset (ssget))
  (if selset
    (progn
      ;; Dosya adı ve yolu oluştur
      (setq path (strcat (getvar "DWGPREFIX") "Keyword_Search_Result.txt")) ;; Çizimin bulunduğu klasöre kaydedilecek
      (setq file (open path "w")) ;; Yazma modu ile dosyayı aç

      ;; Başlıkları dosyaya yaz
      (write-line (strcat "Anahtar kelime: " keyword) file)
      (write-line "Bulunan nesneler:" file)

      ;; Seçilen nesneler arasında arama yap
      (setq result nil)
      (repeat (sslength selset)
        (setq ent (vlax-ename->vla-object (ssname selset 0))) ;; Seçili nesneyi al
        (if (= (vla-get-objectname ent) "AcDbBlockReference") ;; Blok referanslarını kontrol et
          (progn
            (setq blockRef (vlax-ename->vla-object (ssname selset 0)))
            ;; Blok içindeki metin nesnelerini kontrol et
            (vlax-for obj blockRef
              (if (or (= (vla-get-objectname obj) "AcDbText") ;; TEXT nesneleri
                      (= (vla-get-objectname obj) "AcDbMText")) ;; MTEXT nesneleri
                (if (and (vl-string-search keyword (strcase (vla-get-textstring obj))))
                  (progn
                    ;; Metin bulunursa listeye ekle
                    (setq result (cons (vla-get-handle blockRef) result))
                    ;; Dosyaya yaz
                    (write-line (strcat "Blok Referansı Handle: " (vla-get-handle blockRef)) file)
                    (write-line (strcat "Metin: " (vla-get-textstring obj)) file)
                  )
                )
              )
            )
          )
        )
        ;; Bir sonraki nesneye geç
        (setq selset (ssdel (ssname selset 0) selset))
      )

      ;; Sonuç yoksa dosyaya bilgi yaz
      (if (not result)
        (write-line "Hiçbir nesne bulunamadı." file)
      )

      ;; Dosyayı kapat
      (close file)
      (prompt (strcat "\nSonuçlar '" path "' dosyasına kaydedildi."))
    )
    (prompt "\nSeçim yapılmadı ya da geçersiz bir işlem gerçekleştirildi!")
  )
  (princ)
)
