;+
; Process VCMIP
;-
function viirs_process_vcmip, vcmip_file, $
      no_glt=no_glt, $
      no_georeference=no_geo, $
      no_pictures=no_pics
   compile_opt idl2
   
   output_dir = file_dirname(vcmip_file, /mark_directory)
   
   vcmip_data = viirs_ingest_vcmip_file(vcmip_file)
   
   vcmip_glt_file = output_dir + 'vcmip-glt.dat'
   if ~keyword_set(no_glt) then $
      viirs_build_glt, vcmip_data.longitude, vcmip_data.latitude, $
      out_name=vcmip_glt_file
      
   vcmip = viirs_decode_vcm(vcmip_data, /morph_open)
   
   vcmip_geo_file = output_dir + 'vcmip-georef.dat'
   if ~keyword_set(no_geo) then $
      viirs_georeference_mask, vcmip, vcmip_glt_file, $
      out_name=vcmip_geo_file, /offset
      
   if ~keyword_set(no_pics) then $
      viirs_make_pretty_pictures, data1=vcmip_data, data2=vcmip, $
      out_dir=output_dir, /vcmip
      
   return, vcmip_geo_file
end


;+
; Process VIBCM
;-
function viirs_process_vibcm, iband_file, $
      no_glt=no_glt, $
      no_georeference=no_geo, $
      no_pictures=no_pics
   compile_opt idl2
   
   output_dir = file_dirname(iband_file, /mark_directory)
   
   iband_data = viirs_ingest_iband_file(iband_file)
   
   iband_glt_file = output_dir + 'iband-glt.dat'
   if ~keyword_set(no_glt) then $
      viirs_build_glt, iband_data.longitude, iband_data.latitude, $
      out_name=iband_glt_file
      
   vibcm = viirs_build_cloudmask(iband_data)
   
   vibcm_geo_file = output_dir + 'vibcm-georef.dat'
   iband_geo_file = output_dir + 'i' + ['1', '2', '3'] + '-georef.dat'
   rgb_stacked_file = output_dir + 'i3-i2-i1-composite.dat'
   if ~keyword_set(no_geo) then begin
      viirs_georeference_mask, vibcm, iband_glt_file, $
         out_name=vibcm_geo_file, /offset
      viirs_georeference_iband, iband_data.i1, iband_glt_file, $
         out_name=iband_geo_file[0]
      viirs_georeference_iband, iband_data.i2, iband_glt_file, $
         out_name=iband_geo_file[1]
      viirs_georeference_iband, iband_data.i3, iband_glt_file, $
         out_name=iband_geo_file[2]
      viirs_stack_bands, iband_geo_file[0], iband_geo_file[1], $
         iband_geo_file[2], out_name=rgb_stacked_file
   endif
   
   if ~keyword_set(no_pics) then begin
      viirs_make_pretty_pictures, data1=iband_data, data2=vibcm, $
         out_dir=output_dir, /iband
      viirs_make_pretty_pictures, data1=rgb_stacked_file, $
         out_dir=output_dir, /rgb_composite
   endif
   return, vibcm_geo_file
end


;+
; The driver program for the whole thing.
;-
function viirs_cloudmask_doit, iband_file, vcmip_file, _extra=keys
   compile_opt idl2
   
   ; Start ENVI in headless mode unless it's already open.
   e = envi(/current)
   if e eq !null then e = envi(/headless)
   
   vcmip_geo_file = viirs_process_vcmip(vcmip_file, _extra=keys)
   vibcm_geo_file = viirs_process_vibcm(iband_file, _extra=keys)
   
   output_dir = file_dirname(iband_file, /mark_directory)
   stacked_file = output_dir + 'vibcm-vcmip-stacked.dat'
   viirs_stack_masks, vibcm_geo_file, vcmip_geo_file, out_name=stacked_file
   
   viirs_make_pretty_pictures, data1=stacked_file, out_dir=output_dir, $
      /stacked_masks
      
   stats = viirs_calculate_stats(stacked_file)
   stats['iband_file'] = file_basename(iband_file)
   stats['vcmip_file'] = file_basename(vcmip_file)
   
   report_file = output_dir + 'report.txt'
   viirs_generate_report, stats, out_name=report_file
   
   if e.ui eq !null then e.close
   
   return, stats
end

; Example
iband_file = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
vcmip_file = file_which('GMODO-IICMO_npp_d20120206_t2358058_e0003462_b01442_c20120606211325714750_noaa_ops.h5')
stats = viirs_cloudmask_doit(iband_file, vcmip_file, /no_glt, /no_georeference)
help, stats
end
