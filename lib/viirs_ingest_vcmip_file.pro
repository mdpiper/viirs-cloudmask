function viirs_ingest_vcmip_file, vcmip_file
   compile_opt idl2
 
   data = hash()
   data['file'] = vcmip_file

   ; Read geocoords.
   geocoords = ['Longitude','Latitude']
   foreach coord, geocoords do begin
      path = '/All_Data/VIIRS-MOD-GEO_All/' + coord
      data[coord] = viirs_read_dataset(vcmip_file, path)
   endforeach
   
   ; Read the first byte of the VCM IP.
   ; TODO: think more about this.
   dataset = '/All_Data/VIIRS-CM-IP_All/QF1_VIIRSCMIP'
   data['QF1_VIIRSCMIP'] = viirs_read_dataset(vcmip_file, dataset)
   
   data['dimensions'] = size(data['Longitude'], /dimensions)
   return, data.tostruct()
end

; Example
f = file_which('GMODO-IICMO_npp_d20120206_t2358058_e0003462_b01442_c20120606211325714750_noaa_ops.h5')
vcmip_data = viirs_ingest_vcmip_file(f)
help, vcmip_data
end
