; docformat = 'rst'
;+
; Filter 3 thresholds VIIRS I5 (similar to ETM+ band 6) temperature values. I 
; chose a higher threshold than in the Irish paper (300 K) because it was
; excluding too many warm clouds. I'd prefer to be inclusive and see if other
; filters catch pixels that aren't cloudy. Be aware that I5 brightness
; temperatures are defined on [150.0, 380.0]. Pixel values greater than the 
; threshold are not cloudy.
; 
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_cloudmask_filter3, i5
   compile_opt idl2
   
   threshold = 312.0 ; K
   return, i5 lt threshold
end
