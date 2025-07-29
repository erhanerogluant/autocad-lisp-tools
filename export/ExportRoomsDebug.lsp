(defun c:ExportRoomsDebug ( / ss i ent att attdata tag val file fpath dwgname)

  ;; Aktif DWG dosyasının adı ve yolu
  (setq dwgname (getvar "DWGNAME"))
  (setq fpath (strcat (getvar "DWGPREFIX")
                      (vl-filename-base dwgname)
                      "_Rooms_Debug.txt"))

  ;; Blokları seçtir
  (setq ss (ssget '((0 . "INSERT"))))

  (if ss
    (progn
      (setq file (open fpath "w"))
      (setq i 0)

      (repeat (sslength ss)
        (setq ent (ssname ss i))
        (setq att (entnext ent))

        (while att
          (setq attdata (entget att))
          (if (= (cdr (assoc 0 attdata)) "ATTRIB")
            (progn
              (setq tag (cdr (assoc 2 attdata)))
              (setq val (cdr (assoc 1 attdata)))
              (write-line (strcat "TAG: " tag " | VALUE: " val) file)
            )
          )
          (setq att (entnext att))
        )
        (setq i (1+ i))
      )

      (close file)
      (princ (strcat "\nDebug export tamamlandı: " fpath))
    )
    (princ "\nHerhangi bir block seçilmedi.")
  )
  (princ)
)
