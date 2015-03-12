;+
; Get cloud mask quality flags from bits 0-1 (high = 3, medium = 2, low = 1, 
; poor = 0) and cloud detection and confidence from bits 2-3 (confident cloudy = 3, 
; probably cloudy = 2, probably clear = 1, confident clear = 0).
; 
; I'm choosing to return pixels that are confident/probably cloudy and have
; high/medium quality.
; 
; Optionally, apply morphological opening operation to reduce noise.
; 
; :params:
;  data
;  
; :keywords:
;  morph_open
;  
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_decode_vcm, data, morph_open=open
   compile_opt idl2
   
   dataset = data.qf1_viirscmip
   
   quality = dataset and 3B
   confidence = ishft(dataset, -2) and 3B
   
   mask = (confidence ge 2) and (quality ge 2)
   
   if keyword_set(open) then begin
      kernel = bytarr(2,2) + 1B
      mask = morph_open(mask, kernel)
   endif
   
   return, mask
end

; Example
f = file_which('GMODO-IICMO_npp_d20120206_t2358058_e0003462_b01442_c20120606211325714750_noaa_ops.h5')
vcmip_data = viirs_ingest_vcmip_file(f)
vcmip = viirs_decode_vcm(vcmip_data, /morph_open)
help, vcmip
;g = image(bytscl(vcmip), rgb_table=12)
end
