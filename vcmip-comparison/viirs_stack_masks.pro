;+
; Layer stacking. VIBCM as reference. Nearest neighbor sampling/replication.
;-
pro viirs_stack_masks, vibcm_file, vcmip_file, $
      out_name=out_name, $
      batch=batch
   compile_opt idl2
   
   if keyword_set(batch) then e = envi(/headless)
   
   if out_name eq !null then out_name='layer_stack_test.dat'
   
   envi_open_file, vibcm_file, r_fid=vibcm_fid
   envi_open_file, vcmip_file, r_fid=vcmip_fid
   
   envi_file_query, vibcm_fid, dims=vibcm_dims, data_type=dt
   envi_file_query, vcmip_fid, dims=vcmip_dims
   proj = envi_get_projection(fid=vibcm_fid, pixel_size=ps)
   
   envi_doit, 'envi_layer_stacking_doit', $
      fid=[vibcm_fid, vcmip_fid], $
      dims=[[vibcm_dims], [vcmip_dims]], $
      pos=[0, 0], $
      /exclusive, $
      out_bname=['VIBCM', 'VCMIP'], $
      out_dt=dt, $
      out_proj=proj, $
      out_ps=ps, $
      out_name=out_name, $
      r_fid=r_fid
   if r_fid ne -1 then print, 'Layer-stacked file written to: ' + out_name
   
   if keyword_set(batch) then e.close
end
