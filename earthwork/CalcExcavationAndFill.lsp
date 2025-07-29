(defun c:CALCEXCAVATIONANDFILL ( / red-left red-right black-left black-right terrace-left terrace-right width distance fill-volume excavation-volume )
  (setq distance 20) ; Ara mesafe
  (setq fill-volume 0)
  (setq excavation-volume 0)

  ;; Kullanıcıdan kırmızı kotları seçme
  (princ "\nKırmızı kot (sağ) textlerini seçin (Birden fazla seçim yapın, sonrasında Enter'a basın):")
  (setq red-right (list)) ; Sağdaki kırmızı kotlar için boş liste başlatıyoruz
  (while (setq obj (car (entsel)))
    (setq red-right (cons obj red-right))) ; Sağdaki kırmızı kotları listeye ekliyoruz

  (princ "\nKırmızı kot (sol) textlerini seçin (Birden fazla seçim yapın, sonrasında Enter'a basın):")
  (setq red-left (list)) ; Soldaki kırmızı kotlar için boş liste başlatıyoruz
  (while (setq obj (car (entsel)))
    (setq red-left (cons obj red-left))) ; Soldaki kırmızı kotları listeye ekliyoruz

  ;; Kullanıcıdan siyah kotları seçme
  (princ "\nSiyah kot (sağ) textlerini seçin (Birden fazla seçim yapın, sonrasında Enter'a basın):")
  (setq black-right (list)) ; Sağdaki siyah kotlar için boş liste başlatıyoruz
  (while (setq obj (car (entsel)))
    (setq black-right (cons obj black-right))) ; Sağdaki siyah kotları listeye ekliyoruz

  (princ "\nSiyah kot (sol) textlerini seçin (Birden fazla seçim yapın, sonrasında Enter'a basın):")
  (setq black-left (list)) ; Soldaki siyah kotlar için boş liste başlatıyoruz
  (while (setq obj (car (entsel)))
    (setq black-left (cons obj black-left))) ; Soldaki siyah kotları listeye ekliyoruz

  ;; Kullanıcıdan terasman kotlarını seçme
  (princ "\nTerasman kot (sağ) textlerini seçin (Birden fazla seçim yapın, sonrasında Enter'a basın):")
  (setq terrace-right (list)) ; Sağdaki terasman kotları için boş liste başlatıyoruz
  (while (setq obj (car (entsel)))
    (setq terrace-right (cons obj terrace-right))) ; Sağdaki terasman kotları listeye ekliyoruz

  (princ "\nTerasman kot (sol) textlerini seçin (Birden fazla seçim yapın, sonrasında Enter'a basın):")
  (setq terrace-left (list)) ; Soldaki terasman kotları için boş liste başlatıyoruz
  (while (setq obj (car (entsel)))
    (setq terrace-left (cons obj terrace-left))) ; Soldaki terasman kotları listeye ekliyoruz

  ;; Yol genişliğini alma
  (princ "\nYol genişliğini girin:")
  (setq width (getreal))

  ;; Kotları metin nesnelerinden alma (seçilen nesnelerden yükseklik değerlerini alıyoruz)
  (setq red-left-values (mapcar (function (lambda (ent) (vla-get-textstring (vlax-ename->vla-object ent)))) red-left))
  (setq red-right-values (mapcar (function (lambda (ent) (vla-get-textstring (vlax-ename->vla-object ent)))) red-right))

  (setq black-left-values (mapcar (function (lambda (ent) (vla-get-textstring (vlax-ename->vla-object ent)))) black-left))
  (setq black-right-values (mapcar (function (lambda (ent) (vla-get-textstring (vlax-ename->vla-object ent)))) black-right))

  (setq terrace-left-values (mapcar (function (lambda (ent) (vla-get-textstring (vlax-ename->vla-object ent)))) terrace-left))
  (setq terrace-right-values (mapcar (function (lambda (ent) (vla-get-textstring (vlax-ename->vla-object ent)))) terrace-right))

  ;; Yükseklik farklarını hesaplama (farklar)
  (setq red-diff (apply '+ (mapcar (function (lambda (right left) (abs (- (read right) (read left))))) red-right-values red-left-values)))
  (setq black-diff (apply '+ (mapcar (function (lambda (right left) (abs (- (read right) (read left))))) black-right-values black-left-values)))
  (setq terrace-diff (apply '+ (mapcar (function (lambda (right left) (abs (- (read right) (read left))))) terrace-right-values terrace-left-values)))

  ;; Hacim hesaplama
  (setq fill-volume (+ fill-volume (* red-diff distance width)))
  (setq excavation
::contentReference[oaicite:0]{index=0}
 
