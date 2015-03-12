;+
; Decodes the quality flags in VIIRS Imagery EDRs (QF1_VIIRSIMGEDR). Works 
; for I1 - I5.
; 
; Look up the values on p. 11 of the Common Data Format Control Book – External
; (CDFCB-X) Volume IV- Part II - Imagery, Atmospheric, and Cloud EDRs.
; 
; :examples:
;  249 = 11111001
;  Quality (bits 1-2) = 1, poor
;  Saturated (bit 3) = 0, no
;  Missing data (bits 4-5) = 3, thermistor
;  Out of range (bits 6-7) = 3, both radiances and reflectances
;  Spare (bit 8) = 1, unused
;-
function viirs_decode_quality_flag, qfval
   compile_opt idl2
   
   r = { $
      pixel_quality: 255B, $
      pixel_is_saturated: 255B, $
      missing_data: 255B, $
      out_of_range: 255B $
      }
   
   r.pixel_quality = qfval and 3B
   r.pixel_is_saturated = ishft(qfval, -2) and 1B
   r.missing_data = ishft(qfval, -3) and 3B
   r.out_of_range = ishft(qfval, -5) and 3B
   
   return, r
end

