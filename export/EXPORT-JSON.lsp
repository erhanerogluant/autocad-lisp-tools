(defun c:EXPORT-JSON ()
  (setq jsonData "[") ; JSON array başlangıcı
  (setq ss (ssget "_X")) ; Tüm nesneleri seç

  (if ss
    (progn
      (repeat (setq i (sslength ss))
        (setq ent (ssname ss (setq i (1- i))))
        (setq entData (entget ent))
        (setq objType (cdr (assoc 0 entData)))
        (setq objHandle (cdr (assoc 5 entData)))
        (setq objLayer (cdr (assoc 8 entData)))
        (setq objLength 0)
        (setq objArea 0)
        (setq blockName "")
        (setq attributes "{}")

        ; Geometri Hesaplama
        (cond
          ((= objType "LINE")
            (setq p1 (cdr (assoc 10 entData)))
            (setq p2 (cdr (assoc 11 entData)))
            (setq objLength (distance p1 p2))
          )
          ((= objType "LWPOLYLINE")
            (command "_.AREA" "_O" ent "")
            (setq objLength (getvar "PERIMETER"))
            (setq objArea (getvar "AREA"))
          )
          ((= objType "CIRCLE")
            (setq radius (cdr (assoc 40 entData)))
            (setq objLength (* 2 pi radius)) ; Çevre
            (setq objArea (* pi radius radius))
          )
          ((= objType "INSERT")
            (setq blockName (cdr (assoc 2 entData)))
            ; Blok özniteliklerini oku
            (setq attribs (entnext ent))
            (setq attribList "{")
            (while (and attribs (= (cdr (assoc 0 (entget attribs))) "ATTRIB"))
              (setq tag (cdr (assoc 2 (entget attribs))))
              (setq value (cdr (assoc 1 (entget attribs))))
              (setq attribList (strcat attribList "\"" tag "\":\"" value "\","))
              (setq attribs (entnext attribs))
            )
            (if (> (strlen attribList) 1)
              (setq attribList (substr attribList 1 (1- (strlen attribList)))) ; Son virgülü sil
            )
            (setq attributes (strcat attribList "}"))
          )
        )

        ; JSON Nesnesi Oluştur
        (setq jsonObj (strcat
          "{\n"
          "  \"handle\": \"" objHandle "\",\n"
          "  \"type\": \"" objType "\",\n"
          "  \"layer\": \"" objLayer "\",\n"
          "  \"length\": " (rtos objLength 2 2) ",\n"
          "  \"area\": " (rtos objArea 2 2) ",\n"
          "  \"block\": \"" blockName "\",\n"
          "  \"attributes\": " attributes "\n"
          "}"
        ))

        ; JSON Array'e Ekle
        (if (= jsonData "[")
          (setq jsonData (strcat jsonData jsonObj))
          (setq jsonData (strcat jsonData "," jsonObj))
        )
      )
      (setq jsonData (strcat jsonData "]"))

      ; Dosyaya Yaz
      (setq dosya (open "C:/proje_data.json" "w"))
      (write-line jsonData dosya)
      (close dosya)
      (princ "\nJSON dosyası oluşturuldu: C:/proje_data.json")
    )
    (princ "\Nesne bulunamadı!")
  )
  (princ)
)