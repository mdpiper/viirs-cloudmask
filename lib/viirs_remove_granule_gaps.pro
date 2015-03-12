; docformat = 'rst'
;+
; Removes the gaps between the four granules in a VIIRS I-Band Imagery EDR
; using the indices returned from VIIRS_LOCATE_GRANULE_GAPS.
; 
; :params:
;  dataset: in, required, type=float
;   A dataset from a VIIRS I-Band Imagery EDR.
;  index: in, required, type=long
;   An 8-element array giving the start-stop indices of the granules in a 
;   VIIRS I-Band Imagery EDR.
;
; :requires:
;  IDL 8
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_remove_granule_gaps, dataset, index
   compile_opt idl2
   
   ; Separate the granules of the dataset above and below the gap.
   n_granules = n_elements(index)/2 ; should find a better way
   granules = list()
   for i=0, n_granules-1 do $
      granules.add, dataset[*, index[2*i]:index[2*i+1]]
   
   ; Stick the granules together sans gap.
   dataset_nogap = [[granules[0]], [granules[1]], [granules[2]], [granules[3]]]
   
   return, dataset_nogap
end
