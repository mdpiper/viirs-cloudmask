pro viirs_georeference_iband, data, glt_file, $
      out_name=out_name, $
      batch=batch
   compile_opt idl2
   
   if keyword_set(batch) then e = envi(/headless)
   
   print, 'Georeferencing I-band'
   if out_name eq !null then out_name='georeference_iband_test.dat'
   
   ; Make ENVI file in memory for input band. Clumsy. R_FID used below.
   _data = byte((fix(bytscl(data)) + 1S) < 255S)
   envi_enter_data, _data, $
      r_fid=iband_fid, $
      bnames=file_basename(out_name, '.dat')
      
   envi_open_file, glt_file, /no_realize, /no_interactive_query, r_fid=glt_fid
   
   envi_doit, 'envi_georef_from_glt_doit', $
      fid=iband_fid, $
      glt_fid=glt_fid, $
      background=0B, $
      out_name=out_name, $
      pos=0, $
      r_fid=r_fid
   if r_fid ne -1 then print, 'Georeferenced file written to: ' + out_name
   
   if keyword_set(batch) then e.close
end

