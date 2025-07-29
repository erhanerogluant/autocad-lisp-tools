(defun c:BatchPEDITtoENK_Y3_K ()
  (prompt "\nEn kesit çizgilerinizi seçin...")

  ;; Kullanıcıdan seçim seti al
  (setq objSet (ssget))

  ;; Eğer seçim seti varsa
  (if objSet
    (progn
      ;; Hedef layer adı
      (setq targetLayer "ENK_Y3_K")

      ;; Hedef layer mevcut değilse oluştur
      (if (not (tblsearch "layer" targetLayer))
        (progn
          (command "_.LAYER" "M" targetLayer "") ; Yeni layer oluştur
          (prompt (strcat "\nLayer oluşturuldu: " targetLayer))
        )
      )

      ;; Seçim setindeki tüm nesneler için işlem yap
      (repeat (sslength objSet)
        (setq obj (ssname objSet 0)) ; İlk nesneyi al

        ;; Eğer nesne bir çizgi (LINE) ise
        (if (= (cdr (assoc 0 (entget obj))) "LINE")
          (progn
            ;; Nesneyi hedef layer'a taşı
            (vla-put-Layer (vlax-ename->vla-object obj) targetLayer)

            ;; Nesneyi polyline yap
            (command "_.PEDIT" obj "Y" "") ; PEDIT uygula ve "Y" ile polyline yapmayı onayla
          )
        )

        ;; İşlenen nesneyi seçim setinden kaldır
        (ssdel obj objSet)
      )

      ;; İşlem tamamlandığında bilgi ver
      (prompt "\nTüm çizgiler ENK_Y3_K layer'ına taşındı ve polyline'a dönüştürüldü!")
    )
    ;; Eğer seçim yapılmadıysa uyarı ver
    (prompt "\nHiçbir çizgi seçilmedi, işlem iptal edildi!")
  )
  (princ) ; Çıkış
)
