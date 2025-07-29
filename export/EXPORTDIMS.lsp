(defun c:EXPORTDIMS (/ selset obj filePath textFile dimValue drawingPath)
  ;; Aktif çizimin olduğu klasörü al
  (setq drawingPath (getvar "DWGPREFIX"))

  ;; Dosya yolu belirle (Mevcut çizimin olduğu klasöre kaydet)
  (setq filePath (strcat drawingPath "Dimensions.csv"))

  ;; Kullanıcıya seçim yapmasını iste
  (setq selset (ssget '((0 . "DIMENSION"))))

  ;; Eğer seçim yapıldıysa devam et
  (if selset
    (progn
      ;; CSV dosyasını yazma modunda aç
      (setq textFile (open filePath "w"))

      ;; Ölçü değerlerini işle
      (repeat (sslength selset)
        (setq obj (vlax-ename->vla-object (ssname selset 0))) ;; Nesneyi al
        (setq dimValue (vla-get-TextOverride obj)) ;; Ölçü değerini al

        ;; Eğer manuel bir değer girilmemişse, gerçek ölçü değerini al
        (if (= dimValue "")
          (setq dimValue (rtos (vla-get-Measurement obj) 2 2))) ;; Ondalık format (2 basamak)

        ;; CSV formatına uygun şekilde kaydet
        (write-line dimValue textFile)

        ;; Seçim setinden nesneyi kaldır
        (setq selset (ssdel (ssname selset 0) selset))
      )

      ;; Dosyayı kapat ve kaydet
      (force-output textFile)
      (close textFile)

      ;; Kullanıcıya bilgi ver
      (princ (strcat "\nÖlçü değerleri başarıyla kaydedildi: " filePath))
    )
    (prompt "\nLütfen ölçü (Dimension) nesnelerini seçin.")
  )

  (princ)
)
