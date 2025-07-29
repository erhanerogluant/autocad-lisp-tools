(defun c:ReadLineData ( / line entity layer startPt endPt)
  ;; Çizgi verilerini toplamak için boş bir liste oluşturuyoruz
  (setq lineData '())

  ;; Kullanıcıdan çizgileri seçmesini isteyelim
  (setq ss (ssget '((0 . "LINE")))) ;; Yalnızca çizgiler seçilsin

  ;; Seçilen her bir çizgi için gerekli verileri topluyoruz
  (if ss
    (progn
      (setq cnt 0)
      (repeat (sslength ss)
        (setq entity (ssname ss cnt))
        (setq layer (cdr (assoc 8 (entget entity)))) ;; Layer bilgisi
        (setq startPt (cdr (assoc 10 (entget entity)))) ;; Başlangıç noktası
        (setq endPt (cdr (assoc 11 (entget entity)))) ;; Bitiş noktası

        ;; Toplanan bilgileri listeye ekliyoruz
        (setq lineData (cons (list entity layer startPt endPt) lineData))

        ;; Kontrol etmek için bilgileri yazdıralım
        (princ (strcat "\nEntity: " (rtos (car startPt) 2 2) ", " (rtos (cadr startPt) 2 2) " -> "
                          (rtos (car endPt) 2 2) ", " (rtos (cadr endPt) 2 2) ", Layer: " layer))

        (setq cnt (1+ cnt))
      )
      
      ;; Seçilen çizgilerin bilgilerini yazdıralım
      (princ "\nSeçilen çizgilerin bilgileri:")
      (foreach data lineData
        (princ (strcat "\nLayer: " (cadr data) ", Start Point: " 
                        (rtos (car (caddr data)) 2 2) ", " (rtos (cadr (caddr data)) 2 2) 
                        " -> End Point: " 
                        (rtos (car (cadddr data)) 2 2) ", " (rtos (cadr (cadddr data)) 2 2)))
      )
    )
    (princ "\nHiçbir çizgi seçilmedi.")
  )
  (princ)
)

(princ "\nLISP kodu yüklenmiştir. 'ReadLineData' komutunu çalıştırarak çizgilerin bilgilerini okuyabilirsiniz.")
(princ)
