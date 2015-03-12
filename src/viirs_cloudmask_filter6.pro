; docformat = 'rst'
;+
; Can't apply Filter 6 from the ACCA because there's no I-Band corresponding 
; to ETM+ band 2. All pixels are marked as cloudy.
; 
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_cloudmask_filter6, i1
   compile_opt idl2
   
   return, byte(i1^0.0)
end
