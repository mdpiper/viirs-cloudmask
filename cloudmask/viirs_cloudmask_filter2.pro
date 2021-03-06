; docformat = 'rst'
;+
; Filter 2 thresholds on the normalized snow difference index (NDSI). For VIIRS
; I-band data, this is expressed as::
; 
;  NDSI = (I1 - I3) / (I1 + I3)
;  
; The VIIRS Snow Cover ATBD cites Hall et al. (1998) with NDSI values
; greater than 0.4 representing snow. For the ACCA, Irish notes that he tried 
; this value, but, as I also found, it tended to eliminate cold clouds. Irish
; raised his threshold to 0.7 to capture these clouds. I'll also use 0.7 for 
; VIIRS. Note that VIIRS Snow Cover ATBD classifies pixels with NSDI > 0.4 
; and I2 > 0.11 as snow.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_cloudmask_filter2, i1, i2, i3
   compile_opt idl2
   
   ndsi = (i1 - i3) / (i1 + i3)
   snow = (ndsi gt 0.7) and (i2 gt 0.11)
   return, ~snow
end
