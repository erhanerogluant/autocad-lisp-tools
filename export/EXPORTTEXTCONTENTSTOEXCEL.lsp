(defun c:T2E (/ *error* main)

  (defun *error* (msg)
    (if excel-app
      (progn
        (if workbook (vlax-invoke-method workbook 'Close :vlax-false))
        (vlax-invoke-method excel-app 'Quit)
        (mapcar 'vlax-release-object (list worksheet workbook workbooks excel-app))
      )
    )
    (princ (strcat "\nHata: " msg))
    (princ)
  )

  (defun main (/ selset excel-app workbooks workbook worksheet row cnt success)
    (vl-load-com)
    
    (setq selset (ssget '((0 . "*TEXT"))))
    (if (not selset) (exit))
    
    (setq excel-app (vlax-get-or-create-object "Excel.Application"))
    (vlax-put-property excel-app 'Visible :vlax-true)
    (vlax-put-property excel-app 'DisplayAlerts :vlax-false)
    
    (setq workbooks (vlax-get-property excel-app "Workbooks"))
    (setq workbook (vlax-invoke-method workbooks "Add"))
    (setq worksheet (vlax-get-property workbook "Sheets" 1))
    
    ;; Excel başlıkları
    (vlax-invoke-method (vlax-get-property worksheet "Range" "A1:C1")
                        'Value2
                        (vlax-make-variant (vlax-safearray-fill (vlax-make-safearray vlax-vb-string '(0 . 2))
                                                                '("ADET" "ÇAP" "BOY")) 8192))
    
    (setq row 2 cnt 0)
    
    (vlax-for obj (vla-get-ActiveSelectionSet (vla-get-ActiveDocument (vlax-get-acad-object)))
      (if (wcmatch (vla-get-ObjectName obj) "*Text")
        (progn
          (setq txt (vla-get-TextString obj)
                res (parse-text txt))
          
          (if res
            (progn
              (vlax-put-property (vlax-get-property worksheet "Cells" row 1) "Value2" (nth 0 res))
              (vlax-put-property (vlax-get-property worksheet "Cells" row 2) "Value2" (nth 1 res))
              (vlax-put-property (vlax-get-property worksheet "Cells" row 3) "Value2" (nth 2 res))
              (setq cnt (1+ cnt))
            )
            (princ (strcat "\nParse hatası: " txt))
          )
          (setq row (1+ row))
        )
      )
    )
    
    (if (> cnt 0)
      (progn
        (setq filePath (getfiled "Kaydet" (strcat (getvar "DWGPREFIX") "veri.xlsx") "xlsx" 1))
        (when filePath
          (vlax-invoke-method workbook "SaveAs" filePath -4143)
          (princ (strcat "\n" (itoa cnt) " kayıt Excel'e aktarıldı"))
        )
      )
      (princ "\nİşlenebilir veri bulunamadı")
    )
    
    (vlax-invoke-method workbook "Close")
    (vlax-invoke-method excel-app "Quit")
    (mapcar 'vlax-release-object (list worksheet workbook workbooks excel-app))
    (princ)
  )

  ;; Gelişmiş parse fonksiyonu
  (defun parse-text (txt / nums lst)
    (setq txt (vl-string-translate "ƒÿ/" "   " txt))  ; Özel karakterleri temizle
    (setq txt (vl-string-subst "" "l=" txt))          ; l= ifadesini kaldır
    (setq lst (split-string txt))
    
    (setq nums (mapcar '(lambda (x)
                          (if (setq n (distof x))
                            (rtos n 2 0)
                            (if (wcmatch x "*#*")
                              (vl-list->string (vl-remove-if-not 'digit-char-p (vl-string->list x)))
                              ""
                            )
                          ))
                        lst))
    
    (setq nums (vl-remove-if '(lambda (x) (= x "")) nums))
    
    (cond
      ((>= (length nums) 3)
       (list (car nums) (cadr nums) (caddr nums)))
      ((= (length nums) 2)
       (list (car nums) (cadr nums) ""))
      ((= (length nums) 1)
       (list (car nums) "" ""))
      (t nil)
    )
  )

  ;; Gelişmiş string split
  (defun split-string (str / i c word lst)
    (setq str (vl-string-trim " " str) i 0)
    (while (< i (strlen str))
      (setq c (substr str i 1))
      (if (member c '(" " "\t" "\n"))
        (progn
          (if word (setq lst (cons word lst) word nil))
          (while (member (substr str (setq i (1+ i)) 1) '(" " "\t" "\n"))))
        (setq word (strcat word c) i (1+ i))
      )
    )
    (if word (setq lst (cons word lst)))
    (reverse lst)
  )

  (main)
)