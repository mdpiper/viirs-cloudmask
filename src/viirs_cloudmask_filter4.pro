; docformat = 'rst'
;+
; Filter 4 thresholds on a band I3-I5 composite (corresponding to ETM+ bands 
; 5/6). Irish set a threshold of 225 K through a sensitivity analysis. I found 
; a broadly acceptable threshold over 430-490 K. As with Filter 3, I chose a 
; threshold on the high end of this range to be careful to not exclude cloudy 
; pixels. Pixels less than this threshold are marked as cloudy.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_cloudmask_filter4, i3, i5
   compile_opt idl2
   
   threshold = 485.0 ; K
   return, (max(i3) - i3)*i5 lt threshold
end
