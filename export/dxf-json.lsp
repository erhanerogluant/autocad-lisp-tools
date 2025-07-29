(defun dxf->json (dxfCode)
  ;; DXF kodlarını okunabilir isimlere dönüştür
  (cond
    ((= dxfCode 0) "entityType")
    ((= dxfCode 1) "textValue")
    ((= dxfCode 2) "name")
    ((= dxfCode 8) "layer")
    ((= dxfCode 10) "coordinates")
    ((= dxfCode 40) "radius")
    ((= dxfCode 62) "color")
    ((= dxfCode 70) "flags")
    (t (strcat "dxf_" (itoa dxfCode)))
  )
)

(defun list->json-array (lst)
  ;; LISP listesini JSON array'e dönüştür
  (strcat "[" (vl-string-right-trim "," (apply 'strcat (mapcar '(lambda (x) (strcat (vl-prin1-to-string x) ",")) lst))) "]")
)

(defun process-entity (ent / entData jsonObj subEnt attribs)
  (setq entData (entget ent))
  (setq jsonObj "{")
  
  ;; Temel DXF verilerini işle
  (foreach dxfItem entData
    (setq dxfKey (dxf->json (car dxfItem)))
    (setq dxfVal (cdr dxfItem))
    
    ;; Koordinatları ve listeleri JSON array'e dönüştür
    (if (listp dxfVal)
      (setq dxfVal (list->json-array dxfVal))
      (setq dxfVal (vl-prin1-to-string dxfVal))
    )
    
    (setq jsonObj (strcat jsonObj "\"" dxfKey "\":" dxfVal ","))
  )
  
  ;; Özel verileri ekle
  (cond
    ;; INSERT (Blok) Öznitelikleri
    ((= (cdr (assoc 0 entData)) "INSERT")
      (setq subEnt (entnext ent))
      (setq attribs "{")
      (while (and subEnt (= (cdr (assoc 0 (entget subEnt))) "ATTRIB"))
        (setq attribData (entget subEnt))
        (setq tag (cdr (assoc 2 attribData)))
        (setq value (cdr (assoc 1 attribData)))
        (setq attribs (strcat attribs "\"" tag "\":\"" value "\","))
        (setq subEnt (entnext subEnt))
      )
      (if (> (strlen attribs) 1)
        (setq attribs (substr attribs 1 (1- (strlen attribs))))
      )
      (setq jsonObj (strcat jsonObj "\"attributes\":{" attribs "},"))
    )
    
    ;; HATCH (Tarama) Sınırları
    ((= (cdr (assoc 0 entData)) "HATCH")
      (setq boundary (list->json-array (vlax-get (vlax-ename->vla-object ent) 'Boundaries)))
      (setq jsonObj (strcat jsonObj "\"boundaries\":" boundary ","))
    )
    
    ;; DIMENSION (Ölçüler)
    ((wcmatch (cdr (assoc 0 entData)) "*DIMENSION")
      (setq measurement (cdr (assoc 42 entData)))
      (setq jsonObj (strcat jsonObj "\"measurement\":" (rtos measurement 2 2) ","))
    )
  )
  
  ;; Sonlandır
  (setq jsonObj (vl-string-right-trim "," jsonObj))
  (strcat jsonObj "}")
)

(defun c:EXPORT-FULL-JSON (/ ss i ent jsonData file)
  (setq ss (ssget "_X")) ; Tüm nesneler
  (setq jsonData "[")
  
  (if ss
    (progn
      (repeat (setq i (sslength ss))
        (setq ent (ssname ss (setq i (1- i))))
        (setq jsonEntity (process-entity ent))
        (setq jsonData 
          (if (= jsonData "[")
            (strcat jsonData jsonEntity)
            (strcat jsonData "," jsonEntity)
          )
        )
      )
      (setq jsonData (strcat jsonData "]"))
      
      ;; Dosyaya yaz
      (setq file (open "C:/autocad_full_export.json" "w"))
      (write-line jsonData file)
      (close file)
      (princ "\nJSON dosyası oluşturuldu: C:/autocad_full_export.json")
    )
    (princ "\nNesne bulunamadı!")
  )
  (princ)
)