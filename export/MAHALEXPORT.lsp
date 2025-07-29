(defun c:MAHALEXPORT ( / ss i ent txt pos mahalList titleList hatchList
                         mahalNoList mahalAdiList row col tol excelApp wb ws)

  (vl-load-com)
  (setq tol 15.0) ; tolerans (koordinat sapması için)

  ;; Seçim
  (prompt "\nTablonun tamamını (textler + hatch'ler dahil) seçin: ")
  (setq ss (ssget '((0 . "TEXT,MTEXT,HATCH"))))

  (if (not ss)
    (progn (prompt "\nNesne seçilmedi.") (exit))
  )

  ;; Nesneleri ayrıştır
  (setq mahalList '() titleList '() hatchList '())

  (repeat (setq i (sslength ss))
    (setq ent (ssname ss (setq i (1- i))))
    (setq txt (cdr (assoc 1 (entget ent))))
    (setq pos (cdr (assoc 10 (entget ent))))

    (cond
      ;; Text-Mtext ayrımı
      ((member (cdr (assoc 0 (entget ent))) '("TEXT" "MTEXT"))
        (cond
          ((wcmatch (strcase txt) "Z-*")
            (setq mahalList (cons (list 'NO txt pos) mahalList)))
          ((> (strlen txt) 3)
            (setq mahalList (cons (list 'ADI txt pos) mahalList)))
          ((and (numberp (distof txt)) (> (distof txt) 0))
            nil) ; sayıları atla
          (t
            (setq titleList (cons (list txt pos) titleList)))
        )
      )
      ((= (cdr (assoc 0 (entget ent))) "HATCH")
        (setq hatchList (cons pos hatchList)))
    )
  )

  ;; Sıralama (X: başlık, Y: mahal)
  (setq titleList (vl-sort titleList (function (lambda (a b) (< (car (cadr a)) (car (cadr b)))))))
  (setq mahalNoList (vl-sort (vl-remove-if-not '(lambda (x) (eq (car x) 'NO)) mahalList)
                             (function (lambda (a b) (< (cadr (caddr b)) (cadr (caddr a)))))))
  (setq mahalAdiList (vl-sort (vl-remove-if-not '(lambda (x) (eq (car x) 'ADI)) mahalList)
                              (function (lambda (a b) (< (cadr (caddr b)) (cadr (caddr a)))))))

  ;; Excel Başlat
  (setq excelApp (vlax-get-or-create-object "Excel.Application"))
  (vlax-put-property excelApp 'Visible :vlax-true)
  (setq wb (vlax-invoke-method (vlax-get-property excelApp 'Workbooks) 'Add))
  (setq ws (vlax-get-property wb 'ActiveSheet))

  ;; Başlık yaz
  (vlax-put-property (vlax-invoke-method ws 'Cells 1 1) 'Value "MAHAL NO")
  (vlax-put-property (vlax-invoke-method ws 'Cells 1 2) 'Value "MAHAL ADI")
  (setq col 3)
  (foreach head titleList
    (vlax-put-property (vlax-invoke-method ws 'Cells 1 col) 'Value (car head))
    (setq col (1+ col)))

  ;; Mahalleri yaz
  (setq row 2)
  (repeat (min (length mahalNoList) (length mahalAdiList))
    (setq no (nth (1- row) mahalNoList))
    (setq adi (nth (1- row) mahalAdiList))

    (setq noStr (cadr no))
    (setq adiStr (cadr adi))
    (setq y (cadr (caddr no)))

    ;; Mahal NO ve ADI
    (if (and noStr adiStr)
      (progn
        (vlax-put-property (vlax-invoke-method ws 'Cells row 1) 'Value noStr)
        (vlax-put-property (vlax-invoke-method ws 'Cells row 2) 'Value adiStr)
      )
    )

    ;; Sütunları tarayıp X işareti ekle
    (setq col 3)
    (foreach t titleList
      (setq x (car (cadr t)))
      (setq found nil)
      (foreach h hatchList
        (if (and (< (abs (- (car h) x)) tol)
                 (< (abs (- (cadr h) y)) tol))
          (setq found T)))
      (if found
        (vlax-put-property (vlax-invoke-method ws 'Cells row col) 'Value "X"))
      (setq col (1+ col))
    )
    (setq row (1+ row))
  )

  (prompt "\nExcel'e aktarma tamamlandı.")
  (princ)
)
