(defun c:MAHALEXPORT ( / ss excelApp wb ws row col ent i j eData txtIns txtVal colTitles mahalNo mahalAdi dataTable hatchList)
  (vl-load-com)
  ;; 1. Kullanıcıdan tabloyu seçmesini iste
  (setq ss (ssget "_:L" '((0 . "INSERT,TEXT,MTEXT,HATCH"))))
  (if (not ss)
    (progn (princ "\nSeçim yapılmadı.") (exit))
  )

  ;; 2. Excel başlat
  (setq excelApp (vlax-get-or-create-object "Excel.Application"))
  (vlax-put-property excelApp 'Visible :vlax-true)
  (setq wb (vlax-invoke-method (vlax-get-property excelApp 'Workbooks) 'Add))
  (setq ws (vlax-get-property wb 'ActiveSheet))

  (setq row 2) ; Veriler 2. satırdan başlar
  (setq colTitles '())
  (setq dataTable '())

  ;; 3. Nesneleri sırala ve konumlarına göre ayır
  (repeat (setq i (sslength ss))
    (setq ent (ssname ss (setq i (1- i))))
    (setq eData (entget ent))
    (cond
      ((= (cdr (assoc 0 eData)) "TEXT")
        (setq txtVal (cdr (assoc 1 eData)))
        (setq txtIns (cdr (assoc 10 eData)))

        ;; Mahal No veya Adı mı?
        (cond
          ((wcmatch (strcase txtVal) "Z-*")
           (setq mahalNo (cons (list txtVal txtIns) mahalNo))
          )
          ((wcmatch (strcase txtVal) "*HOL*")
           (setq mahalAdi (cons (list txtVal txtIns) mahalAdi))
          )
          (t ;; Sütun başlığı olabilir
           (setq colTitles (cons (list txtVal txtIns) colTitles))
          )
        )
      )
      ((= (cdr (assoc 0 eData)) "HATCH")
        (setq hatchList (cons (cdr (assoc 10 eData)) hatchList))
      )
    )
  )

  ;; 4. Başlıkları sıraya koy ve yaz
  (vlax-put-property (vlax-invoke-method ws 'Cells 1 1) 'Value "MAHAL NO")
  (vlax-put-property (vlax-invoke-method ws 'Cells 1 2) 'Value "MAHAL ADI")
  (setq col 3)

  ;; Sütun başlıklarını X koordinatına göre sırala
  (setq colTitles (vl-sort colTitles (function (lambda (a b) (< (car (cdr a)) (car (cdr b)))))))
  (foreach ct colTitles
    (vlax-put-property (vlax-invoke-method ws 'Cells 1 col) 'Value (car ct))
    (setq col (1+ col))
  )

  ;; 5. Satırları Y koordinatına göre sırala ve her hücreye veri yaz
  (setq mahalNo (vl-sort mahalNo (function (lambda (a b) (< (cadr (cdr b)) (cadr (cdr a)))))))
  (setq mahalAdi (vl-sort mahalAdi (function (lambda (a b) (< (cadr (cdr b)) (cadr (cdr a)))))))

  (setq i 0)
  (while (< i (min (length mahalNo) (length mahalAdi)))
    (setq no (nth i mahalNo))
    (setq ad (nth i mahalAdi))

    (vlax-put-property (vlax-invoke-method ws 'Cells row 1) 'Value (car no))
    (vlax-put-property (vlax-invoke-method ws 'Cells row 2) 'Value (car ad))

    ;; Şimdi sütun başlıklarını dolaş
    (setq col 3)
    (foreach colh colTitles
      (setq x (car (cdr colh)))
      (setq y (cadr (cdr no)))
      (setq found nil)

      ;; Bu koordinata yakın bir hatch var mı?
      (foreach h hatchList
        (if (and (< (abs (- (car h) x)) 10.0)
                 (< (abs (- (cadr h) y)) 10.0))
          (setq found t)
        )
      )
      (if found
        (vlax-put-property (vlax-invoke-method ws 'Cells row col) 'Value "X")
      )
      (setq col (1+ col))
    )
    (setq row (1+ row))
    (setq i (1+ i))
  )
  (princ "\nVeriler Excel'e aktarıldı.")
  (princ)
)
