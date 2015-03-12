; docformat = 'rst'
;+
; Makes a VIIRS I(3,2,1)-Band false color composite image, the equivalent of a 
; Band(5,4,3) false color composite with Landsat 7 ETM+, with BIP interleaving.
;
; :params:
;  data: in, required, type=structure
;   A data structure returned from VIIRS_INGEST_FILE.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_make_rgb, data
   compile_opt idl2
   
   return, transpose([[[data.i3]], [[data.i2]], [[data.i1]]], [2,0,1])
end

; Example.
f = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
iband_data = viirs_ingest_iband_file(f)
rgb = viirs_make_rgb(iband_data)
help, rgb
end
