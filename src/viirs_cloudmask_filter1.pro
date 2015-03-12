; docformat = 'rst'
;+
; Filter 1 thresholds the brightness of VIIRS I1 (similar to ETM+ band 3). A
; value of 0.08, identical to the ACCA, is used. Pixel values less than the 
; threshold are not cloudy.
; 
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_cloudmask_filter1, i1
   compile_opt idl2
   
   threshold = 0.08
   return, i1 gt threshold
end
