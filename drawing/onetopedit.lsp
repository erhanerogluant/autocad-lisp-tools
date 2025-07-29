(defun c:PEDITLINES (/ ss i ename)
  ;; Kullanıcıya bir seçim seti oluşturması için uyarı
  (prompt "\nPolyline yapmak istediğiniz Line objelerini seçin...\n")
  
  ;; Kullanıcının seçim yapmasını iste
  (setq ss (ssget '((0 . "LINE")))) ; Sadece Line türü objeleri seç

  ;; Seçim seti varsa işlem yap
  (if ss
    (progn
      (setq i 0) ; İndeksi başlat
      ;; Her bir seçili Line objesi için işlem
      (repeat (sslength ss)
        (setq ename (ssname ss i)) ; Her bir nesneyi al
        (command "_.PEDIT" ename "Y" "") ; PEDIT komutuyla Polyline yap
        (setq i (1+ i)) ; İndeksi artır
      )
      ;; İşlem tamamlandığında bilgi ver
      (prompt (strcat "\n" (itoa (sslength ss)) " Line objesi Polyline'a dönüştürüldü.\n"))
    )
    ;; Eğer seçim yapılmadıysa bilgi ver
    (prompt "\nHiç Line objesi seçilmedi!")
  )
  (princ) ; Sessiz modda bekle
)
