;+
; Programmatically build a geographic lookup table (GLT) using the ENVI Classic
; ENVI_GLT_DOIT. This program can be called in batch mode or in an interactive
; ENVI session. It takes a long time (>30 min) to build a GLT on my laptop.
; 
; :params:
;  lon: in, required, type=float
;   A 2D array of longitudes.
;  lat: in, required, type=float
;   A 2D array of latitudes.
;  
; :keywords:
;  batch: in, optional, type=boolean
;   Set this keyword to run in headless mode.
;  out_name: in, optional, type=string
;   The name of the output ENVI GLT file written by ENVI_GLT_DOIT.
;
; :requires:
;  ENVI 5
;  
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
pro viirs_build_glt, lon, lat, out_name=out_name, batch=batch
   compile_opt idl2
   
   if keyword_set(batch) then e = envi(/headless)
   
   if out_name eq !null then out_name='glt_test.dat'

   ; Estimate UTM zone from mean longitude in scene, assuming longitude is 
   ; defined on [-180,180].
   mean_lon = mean(lon)
   mean_lon += 180.0
   utm_zone = ceil(mean_lon / 6.0)

   in_proj = envi_proj_create(/geographic)
   out_proj = envi_proj_create(/utm, zone=utm_zone)
   
   ; Make temp ENVI files in memory for lon and lat. Clumsy. R_FIDs used below. 
   ; The variables LON and LAT are undefined after this step.
   envi_enter_data, lon, r_fid=lon_fid
   envi_enter_data, lat, r_fid=lat_fid
   
   envi_file_query, lon_fid, dims=dims
   
   envi_doit, 'envi_glt_doit', $
      dims=dims, $
      i_proj=in_proj, $
      o_proj=out_proj, $
      out_name=out_name, $
      rotation=0, $        ; north up
      x_fid=lon_fid, $
      x_pos=0, $
      y_fid=lat_fid, $
      y_pos=0, $
      r_fid=r_fid          ; swallowed
      
   if keyword_set(batch) && (r_fid ne -1) then $
      print, 'GLT file written to: ' + out_name      
   
   ; Remove the temp memory files for lon and lat.
   envi_file_mng, id=lon_fid, /remove
   envi_file_mng, id=lat_fid, /remove
   
   if keyword_set(batch) then e.close
end

; Example
f = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
iband_data = viirs_ingest_iband_file(f)
viirs_build_glt, iband_data.longitude, iband_data.latitude, out_name=glt_file
help, glt_file
end

