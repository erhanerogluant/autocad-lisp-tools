(defun c:enkesit_hacim_hesap ()
  (command "_.select") ; Kullanıcıdan nesne seçmesini iste
  (setq ss (ssget)) ; Seçilen nesneleri bir listeye at

  (setq toplam_kazi 0)
  (setq toplam_dolgu 0)

  (repeat (sslength ss)
    (setq ent (ssname ss i))
    (if (= (cdr (assoc 0 (entget ent))) "TEXT")
      (progn
        (setq kot_metin (cdr (assoc 1 (entget ent)))) ; Metin içeriğini al
        (setq kot_deger (atof (vl-string-right kot_metin 5))) ; Son 5 karakteri sayıya çevir
        (setq kot_tur (if (vl-string-search "KIRMIZI" kot_metin) "KIRMIZI"
                        (if (vl-string-search "SİYAH" kot_metin) "SİYAH"
                        "TERASMAN")))
        (setq ara_mesafe (getreal "\nAra mesafeyi girin: ")) ; Her enkesit için ara mesafe alınabilir
        (setq yol_genisligi (getreal "\nYol genişliğini girin: "))

        ; Hacim hesaplama (Basit trapez formülü)
        ; ... (Bu kısım, sonraki açıklamada detaylandırılacaktır)

        (if (< kot_deger siyah_kot_deger) ; Eğer kazı ise
          (setq toplam_kazi (+ toplam_kazi hacim))
          (setq toplam_dolgu (+ toplam_dolgu hacim))
        )
      )
    )
    (setq i (1+ i))
  )

  (princ (strcat "\nToplam Kazı Hacmi: " (rtos toplam_kazi 2 2) " m³"))
  (princ (strcat "\nToplam Dolgu Hacmi: " (rtos toplam_dolgu 2 2) " m³"))
)