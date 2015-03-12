; docformat = 'rst'
;+
; Ratio of near-infrared (I2) to red (I1) bands (4 and 3 in ETM+). Vegetation 
; scores highly. Irish uses a threshold value of 2.0. Pixels below this 
; threshold are marked as cloudy. 
; 
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_cloudmask_filter5, i1, i2
   compile_opt idl2
   
   threshold = 2.0
   return, (i2/i1) lt threshold
end
