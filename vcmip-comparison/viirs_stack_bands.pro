;+
; Layer stacking. VIBCM as reference. Nearest neighbor sampling/replication.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
pro viirs_stack_bands, i1_file, i2_file, i3_file, $
      out_name=out_name, $
      batch=batch
   compile_opt idl2
   
   if keyword_set(batch) then e = envi(/headless)
   
   if out_name eq !null then out_name='layer_stack_test.dat'
   
   envi_open_file, i1_file, r_fid=i1_fid
   envi_open_file, i2_file, r_fid=i2_fid
   envi_open_file, i3_file, r_fid=i3_fid
   
   envi_file_query, i1_fid, dims=iband_dims, data_type=dt
   proj = envi_get_projection(fid=i1_fid, pixel_size=ps)
   
   envi_doit, 'envi_layer_stacking_doit', $
      fid=[i3_fid, i2_fid, i1_fid], $
      dims=[[iband_dims], [iband_dims], [iband_dims]], $
      pos=[0, 0, 0], $
      /exclusive, $
      out_bname=['I3', 'I2', 'I1'], $
      out_dt=dt, $
      out_proj=proj, $
      out_ps=ps, $
      out_name=out_name, $
      r_fid=r_fid
   if r_fid ne -1 then print, 'Layer-stacked file written to: ' + out_name
   
   if keyword_set(batch) then e.close
end
