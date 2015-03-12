; docformat = 'rst'
;+
; Checks whether a file is a NPP VIIRS I-Band EDR. It isn't rigorous -- I check
; whether 1) the file is HDF5, 2) the 'Mission_Name' attribute exists and is
; 'NPP' and 3) the five I-Band and one GEO group are present.
; 
; :params:
;  infile: in, required, type=string
;   The path to a suspected I-Band EDR.
;
; :returns:
;  1 on success (input is an I-band EDR) or 0 on failure.
;  
; :requires:
;  IDL 8.0
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_is_iband_file, infile
   compile_opt idl2
   
   catch, err
   if err ne 0 then begin
      catch, /cancel
      if fid ne !null then h5f_close, fid
      return, 0
   endif
   
   ; Is this an HDF5 file?
   is_h5 = h5f_is_hdf5(infile)
   if ~is_h5 then return, 0
   
   fid = h5f_open(infile)
   
   ; Is this an NPP file?
   aid = h5a_open_name(fid, 'Mission_Name')
   mission = h5a_read(aid)
   h5a_close, aid
   if mission ne 'NPP' then message
   
   ; Check that the GEO group and the five I-Band groups are present.
   ibands = 'I' + strtrim(indgen(5, start=1),2)
   groups = '/All_Data/' + ['VIIRS-IMG-GTM-EDR-GEO_All/', $
      'VIIRS-' + ibands + '-IMG-EDR_All/']
   foreach g, groups do begin
      gid = h5g_open(fid, g)
      h5g_close, gid
   endforeach
   
   h5f_close, fid
   
   return, 1
end


; Example
f = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
print, viirs_is_iband_file(f)
end
