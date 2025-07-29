(defun c:ExportTableToExcel (/ sel file path)
  ;; Kullanıcıdan tabloyu seçmesini iste
  (setq sel (entsel "\nLütfen bir tablo seçin: "))
  (if (and sel (= (cdr (assoc 0 (entget (car sel)))) "TABLE"))
    (progn
      ;; Çıktı dosyasını oluştur
      (setq path (strcat (getvar "DWGPREFIX") "Table_Export.csv"))
      (setq file (open path "w"))

      ;; Tablo satırlarını ve sütunlarını döngüyle yaz
      (vlax-for row (vlax-ename->vla-object (car sel))
        (vlax-for cell row
          (write-line (vla-get-textstring cell) file)
        )
      )

      ;; Dosyayı kapat
      (close file)
      (prompt (strcat "\nTablo '" path "' dosyasına aktarıldı."))
    )
    (prompt "\nLütfen geçerli bir tablo seçin!")
  )
  (princ)
)
