(defun c:ExportHatchAreas (/ ss i obj area file-path file)
  ;; Kullanıcıya Hatch nesnelerini seçmesi için uyarı
  (prompt "\nAlanlarını dışa aktarmak için Hatch objelerini seçin...\n")
  
  ;; Sadece Hatch türü nesneleri seçmek için seçim seti oluştur
  (setq ss (ssget '((0 . "HATCH")))) ; Sadece Hatch objelerini seç
  
  ;; Eğer seçim seti boş değilse işlemleri başlat
  (if ss
    (progn
      ;; Kullanıcıdan dosya kaydetme yolu iste
      (setq file-path (getfiled "Text dosyasını kaydetmek için yol seçin" "" "txt" 1))
      (if file-path
        (progn
          ;; Dosyayı yazma modunda aç
          (setq file (open file-path "w"))
          ;; Başlık satırı yaz
          (write-line "Hatch Alan Raporu" file)
          (write-line "===================" file)
          
          ;; Seçim setindeki her Hatch objesi için işlem yap
          (setq i 0) ; İndeksi başlat
          (repeat (sslength ss)
            (setq obj (vlax-ename->vla-object (ssname ss i))) ; Seçim setinden objeyi al
            (setq area (vla-get-area obj)) ; Hatch alanını al
            ;; Alanı text dosyasına yaz
            (write-line (strcat "Sıra: " (itoa (1+ i)) " - Alan: " (rtos area 2 2)) file)
            (setq i (1+ i)) ; İndeksi artır
          )
          ;; İşlem tamamlandığında dosyayı kapat
          (close file)
          ;; İşlem bitti mesajı
          (prompt (strcat "\nHatch alanları başarıyla dışa aktarıldı: " file-path "\n"))
        )
        ;; Eğer dosya yolu seçilmezse bilgi ver
        (prompt "\nDosya kaydetme yolu seçilmedi. İşlem iptal edildi.\n")
      )
    )
    ;; Eğer seçim yapılmadıysa bilgi ver
    (prompt "\nHiç Hatch objesi seçilmedi!\n")
  )
  (princ) ; Sessiz modda bekle
)
