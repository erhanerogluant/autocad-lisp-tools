(defun c:ExportRooms ( / ss i blk atts att tag val name number file fpath dwgname)

  ;; Aktif DWG dosyasının adı ve yolu
  (setq dwgname (getvar "DWGNAME"))
  (setq fpath (strcat (getvar "DWGPREFIX")
                      (vl-filename-base dwgname)
                      "_Rooms.txt"))

  ;; Blokları seçtir
  (setq ss (ssget '((0 . "INSERT"))))

  (if ss
    (progn
      (setq file (open fpath "w"))
      (setq i 0)

      (repeat (sslength ss)
        (setq blk (vlax-ename->vla-object (ssname ss i)))
        (setq atts (vlax-invoke blk 'GetAttributes))
        (setq name "")
        (setq number "")

        ;; attribute’ları tara
        (foreach att atts
          (setq tag (strcase (vla-get-TagString att)))
          (setq val (vla-get-TextString att))

          (if (= tag "ROOMOBJECTS:NAME")
            (setq name val)
          )
          (if (= tag "ROOMOBJECTS:NUMBER")
            (setq number val)
          )
        )

        ;; Eğer ikisi de boş değilse yaz
        (if (and (/= name "") (/= number ""))
          (progn
            (write-line name file)
            (write-line number file)
          )
        )

        (setq i (1+ i))
      )

      (close file)
      (princ (strcat "\nExport tamamlandı: " fpath))
    )
    (princ "\nHerhangi bir block seçilmedi.")
  )
  (princ)
)
