# Render and Upload

 
 
 
## 

## Two Topics: 

### render aligned sections
### render non-aligned sections

### render non-aligned sections

1. run **create_montages_cloudvolume.py** (located /n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214)once before uploading (create a new volume)
2. run upload_cloud.job to call **upload_montages_to_cloudvolume.py **in sections/python_codes/

test with one section
`cd /n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections/`
`cp 220624170816_jc105_1345/intrasection/jobs/fullres_render_jobs/srun.sh 220625132547_jc105_1344/intrasection/jobs/fullres_render_jobs/`
`cp 220624170816_jc105_1345/intrasection/jobs/fullres_render_jobs/upload_cloud.job 220625132547_jc105_1344/intrasection/jobs/fullres_render_jobs/`
`
`
`./220625132547_jc105_1344/intrasection/jobs/srun_fullres_render.sh`

do a bunch
`for i in $(listAcquisitions jc105 1346 1364); do cp 220624170816_jc105_1345/intrasection/jobs/fullres_render_jobs/srun.sh $i/intrasection/jobs/fullres_render_jobs/; cp 220624170816_jc105_1345/intrasection/jobs/fullres_render_jobs/upload_cloud.job $i/intrasection/jobs/fullres_render_jobs/; done`
`
`
`for i in $(listAcquisitions jc105 1344 1364); do cp 240203161233_jc105_2562/intrasection/jobs/fullres_render_jobs/``apply_map_fullres.job ``$i/intrasection/jobs/fullres_render_jobs/; done`
`
`
`for i in $(listAcquisitions jc105 1346 1364); do ./$i/intrasection/jobs/srun_fullres_render.sh; done`
`
`
 update from Mar 11
— change the memories +time request

`for i in $(listAcquisitions jc105 1366); do rsync -r 220624175124_jc105_1346/intrasection/jobs/fullres_render_jobs/ $i/intrasection/jobs/fullres_render_jobs/; cp 220624175124_jc105_1346/intrasection/jobs/srun_fullres_render.sh $i/intrasection/jobs/; done`
`
`
`
`
`for i in $(listAcquisitions jc105 1346 1364); do ./$i/intrasection/jobs/srun_fullres_render.sh; done`

**Aligned downsampled section upload**
mar 13 upload to:**
**
gs://zetta_jchen_mouse_cortex_001_drop/songyang_003/2402261055_sections1344_3748_0206_aligned/aligned_8_links
