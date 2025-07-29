(defun c:ScaleBlocksToPolyline ( / ss_pl ss_bl i ent_pl ent_bl pl_len bl_pos)
  (setq ss_pl (ssget '((0 . "LWPOLYLINE")(8 . "yol_ys_ızgara")))) ; polyline layer
  (setq ss_bl (ssget '((0 . "INSERT")))) ; block references

  (if (and ss_pl ss_bl)
    (progn
      (setq i 0)
      (while (< i (sslength ss_pl))
        (setq ent_pl (ssname ss_pl i))
        (setq pl_len (vlax-curve-getdistatparam ent_pl (vlax-curve-getendparam ent_pl)))

        ;; bloğu bul
        (setq j 0)
        (while (< j (sslength ss_bl))
          (setq ent_bl (ssname ss_bl j))
          (setq bl_pos (cdr (assoc 10 (entget ent_bl))))
          (if (vlax-invoke (vlax-ename->vla-object ent_pl) 'IsPointOnObject bl_pos)
            (progn
              ;; Ölçekleme işlemi
              (command "_.SCALE" ent_bl "" bl_pos "R" "1" pl_len) ; referansla scale
            )
          )
          (setq j (1+ j))
        )
        (setq i (1+ i))
      )
    )
    (prompt "\nGerekli nesneler seçilemedi.")
  )
  (princ)
)
