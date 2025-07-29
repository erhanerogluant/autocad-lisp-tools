(defun c:BatchPEDIT_LayerSync ()
  (prompt "\nÇizgileri seçin...")
  
  ;; Kullanıcıdan çizgi seçimi al
  (setq objSet (ssget))
  
  ;; Eğer seçim yapılmışsa
  (if objSet
    (progn
      ;; Kullanıcıdan hedef layer adını al
      (setq targetLayer (getstring "\nHedef Layer Adını Girin: "))
      (if (= targetLayer "")
        (setq targetLayer "0") ; Boş girilirse varsayılan layer "0"
      )

      ;; Hedef layer mevcut değilse oluştur
      (if (not (tblsearch "layer" targetLayer))
        (progn
          (command "_.LAYER" "M" targetLayer "") ; Yeni layer oluştur
          (prompt (strcat "\nLayer oluşturuldu: " targetLayer))
        )
      )

      ;; Seçim setindeki her bir nesne için işlem
      (repeat (sslength objSet)
        (setq obj (ssname objSet 0)) ; İlk nesneyi seç
        
        ;; Nesneyi hedef layer'a taşı
        (vla-put-Layer (vlax-ename->vla-object obj) targetLayer)
        
        ;; Nesneyi polyline yap
        (command "_.PEDIT" obj "Y" "") ; PEDIT uygula ve "Y" ile Polyline yapmayı onayla
        
        ;; İşlenen nesneyi seçim setinden kaldır
        (ssdel obj objSet)
      )

      ;; İşlem tamamlandığında bilgi ver
      (prompt "\nTüm çizgiler hedef layer'a taşındı ve polyline'a dönüştürüldü!")
    )
    ;; Eğer seçim yapılmadıysa uyarı ver
    (prompt "\nHiçbir çizgi seçilmedi, işlem iptal edildi!")
  )
  (princ) ; Çıkış
)
