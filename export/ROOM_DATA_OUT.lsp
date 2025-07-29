(defun c:ROOM_DATA_OUT ( / sel file_output doc xls wks column count nb ename k_list)
	(setq
		sel (ssget "_X" '((0 . "*POLYLINE") (8 . "AREA_ROOM") (-4 . "<NOT") (-4 . "&") (70 . 120) (-4 . "NOT>")))
		file_output (strcat (getvar "DWGPREFIX") (substr (getvar "DWGNAME") 1 (- (strlen (getvar "DWGNAME")) 4))(rtos (getvar "CDATE") 2 6) ".xlsm")
		)
	(cond
		((and sel file_output)
			(setq doc (vla-get-activedocument (vlax-get-acad-object)))
			(vla-startundomark doc)
			(setq xls (vlax-get-or-create-object "Excel.Application"))
			(vlax-invoke (vlax-get xls 'workbooks) 'Add)
			(vlax-put xls 'Visible :vlax-true)
			(setq
				wks (vlax-get xls 'ActiveSheet)
				column 65
				count 1
			)
			(vlax-put (vlax-get-property wks 'range (strcat "A1:E" (itoa (sslength sel)))) 'Cells "")
			(foreach el '("HANDLE" "ROOM_NAME" "ROOM_FLOOR" "ROOM_AREA" "ROOM_PERIMETER" )
				(vlax-put (vlax-get-property wks 'range (strcat (chr column) (itoa count))) 'value el)
				(setq column (1+ column))
			)
			(repeat (setq nb (sslength sel))
				(setq
					ename (ssname sel (setq nb (1- nb)))
					k_list (list (cons "HANDLE" (strcat "'" (cdr (assoc 5 (entget ename))))))
				)
				(foreach el '("ROOM_NAME" "ROOM_FLOOR" "ROOM_AREA" "ROOM_PERIMETER" )
					(setq k_list (cons (cons el (vlax-ldata-get ename el)) k_list))
				)
				(setq
					count (1+ count)
					column 65
				)
				(foreach el (reverse (mapcar 'cdr k_list))
					(vlax-put (vlax-get-property wks 'range (strcat (chr column) (itoa count))) 'value el)
					(setq
						column (1+ column)
					)
				)
				(setq k_list nil)
			)
			(mapcar 'vlax-release-object (list wks xls))
			(gc)
			(vla-endundomark doc)
		)
	)
	(prin1)
)