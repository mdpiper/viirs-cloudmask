; docformat = 'rst'
;+
; Programmatically georeference a cloud mask using a GLT and the ENVI Classic
; ENVI_GEOREF_FROM_GLT_DOIT. This program can be called in batch mode or in
; an interactive ENVI session.
;
; :params:
;  cmask: in, required, type=byte
;   The cloud mask (a 2D byte array) returned from VIIRS_BUILD_CLOUDMASK.
;  glt_file: in, required, type=string
;   The path to the GLT file (created by VIIRS_BUILD_GLT) to be used in the
;   georeferencing.
;
; :keywords:
;  batch: in, optional, type=boolean
;   Set this keyword to run in headless mode.
;  out_name: in, optional, type=string
;   The name of the output ENVI file written by ENVI_GEOREF_FROM_GLT_DOIT.
;  offset: in, optional, type=boolean
;   Set this keyword to add 1B to each pixel of the mask, offsetting "no
;   cloud" values from background pixel values.
;
; :requires:
;  ENVI 5
;  
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
pro viirs_georeference_mask, cmask, glt_file, $
   out_name=out_name, $
   batch=batch, $
   offset=offset
   compile_opt idl2
   
   if keyword_set(batch) then e = envi(/headless)
   
   if keyword_set(batch) then print, 'Georeferencing mask'
   if out_name eq !null then out_name='georeference_test.dat'

   ; Add 1B to input data for later use in masking.
   _cmask = keyword_set(offset) ? cmask + 1B : cmask
   
   ; Make temp ENVI file in memory for the _cmask array. Clumsy. The R_FID is
   ; used below.
   envi_enter_data, _cmask, $
      r_fid=cmask_fid, $
      bnames='I-Band Cloud Mask'
      
   envi_open_file, glt_file, /no_realize, /no_interactive_query, r_fid=glt_fid
   
   envi_doit, 'envi_georef_from_glt_doit', $
      fid=cmask_fid, $
      glt_fid=glt_fid, $
      background=0, $      ; unsure of best technique, but background = no cloud
      out_name=out_name, $
      pos=0, $
      r_fid=r_fid          ; swallowed

   if keyword_set(batch) && (r_fid ne -1) then $
      print, 'Georeferenced file written to: ' + out_name
      
   ; Remove the temp memory file for cmask.
   envi_file_mng, id=cmask_fid, /remove
   
   if keyword_set(batch) then e.close
end

