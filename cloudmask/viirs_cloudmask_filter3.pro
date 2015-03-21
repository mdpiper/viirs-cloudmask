; docformat = 'rst'
;+
; Filter 3 thresholds VIIRS I5 (similar to ETM+ band 6) temperature values. I 
; chose the same threshold used in the Irish paper (300 K). Be aware that I5 
; brightness temperatures are defined on [150.0, 380.0]. Pixel values greater 
; than the threshold are not cloudy.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_cloudmask_filter3, i5
   compile_opt idl2
   
   threshold = 300.0 ; K
   return, i5 lt threshold
end
