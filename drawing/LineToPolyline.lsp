(defun c:LineToPolyline (/ ss i obj)
  ;; Kullanıcıya nesneleri seçmesi için uyarı
  (prompt "\nPolyline'e dönüştürmek için Line objelerini seçin...\n")
  
  ;; Sadece Line türü nesneleri seçmek için seçim seti oluştur
  (setq ss (ssget '((0 . "LINE")))) ; Sadece Line objelerini seç
  
  ;; Eğer seçim seti boş değilse işlemleri başlat
  (if ss
    (progn
      (setq i 0) ; İndeksi başlat
      ;; Seçim setindeki her Line objesi için işlem yap
      (repeat (sslength ss)
        (setq obj (ssname ss i)) ; Seçim setinden objeyi al
        ;; AutoCAD'in PEDIT komutunu kullanarak işlem yap
        (command "_.PEDIT" obj "Y" "") ; "Y" ile Line objesini Polyline yap
        (setq i (1+ i)) ; İndeksi artır
      )
      ;; İşlem tamamlandığında bilgi mesajı ver
      (prompt (strcat "\n" (itoa (sslength ss)) " Line objesi Polyline'a dönüştürüldü.\n"))
    )
    ;; Eğer seçim yapılmadıysa bilgi ver
    (prompt "\nHiç Line objesi seçilmedi!\n")
  )
  (princ) ; Sessiz modda bekle
)
