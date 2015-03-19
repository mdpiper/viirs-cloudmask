; docformat = 'rst'
;+
; Fliter 7 is formed from a I2-I3 ratio (ETM+ bands 4-5). According to Irish, 
; this filter eliminates highly reflective rocks and sands. He uses a 
; threshold setting of 1.0. Pixels above this threshold are marked as cloudy.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_cloudmask_filter7, i2, i3
   compile_opt idl2
   
   threshold = 1.0
   return, (i2/i3) gt threshold
end
