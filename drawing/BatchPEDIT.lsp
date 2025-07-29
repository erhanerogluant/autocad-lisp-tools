(defun c:BatchPEDIT ()
  (prompt "\nPEDIT için çizgileri seçin...")
  
  ;; Kullanıcıdan seçim al
  (setq objSet (ssget))
  
  ;; Eğer bir seçim yapılmışsa
  (if objSet
    (progn
      ;; PEDIT işlemi için başlangıç
      (prompt "\nSeçilen çizgiler PEDIT işlemine hazırlanıyor...")
      
      ;; Seçim setindeki her bir nesneyi işlemden geçir
      (repeat (sslength objSet)
        (setq obj (ssname objSet 0))  ; İlk nesneyi seç
        (command "_.PEDIT" obj "Y" "") ; PEDIT uygula ve "Y" ile Polyline yapmayı onayla
        (ssdel obj objSet) ; İşlenen nesneyi seçim setinden kaldır
      )
      
      ;; İşlem tamamlandığında bilgi ver
      (prompt "\nTüm seçilen çizgiler başarıyla polyline'a dönüştürüldü!")
    )
    ;; Eğer seçim yapılmadıysa uyarı ver
    (prompt "\nHiçbir çizgi seçilmedi, işlem iptal edildi!")
  )
  (princ) ; Çıkış
)
