# Stitching Error Debug

 
 
 

Useful Note:https://harvardmed.atlassian.net/wiki/spaces/O2/pages

https://harvardmed.atlassian.net/wiki/spaces/O2/pages/1586793613/Troubleshooting+Slurm+Jobs

_## To check the Error_
go sections/section_number/intrasection/logs_
_
## 

***## Easy Solved Problem***

**_## Resubmit the Job_**

if gen_mask failed and you want to resubmit gen_mask.job:
`./srun.sh gen_mask.job`

Remember, srun.sh gave the job list as below

JOBS=(
  inter_vcoarse.job,inter_hcoarse.job
  inter_vfine.job,inter_hfine.job
  gen_align_input.job
  align.job,imaps.job
  apply_map_par.job
  gen_mask.job
  intra_reduce.job)

if align.job failed but imaps.job doesn’t, do this to srun.sh before run ./srun.sh align.job:

JOBS=(
  inter_vcoarse.job,inter_hcoarse.job
  inter_vfine.job,inter_hfine.job
  gen_align_input.job
  #align.job,imaps.job
  algin.job
  apply_map_par.job
  gen_mask.job
  intra_reduce.job)

**_## TIMEOUT_****## 
**
- Request new time
	- Double the time request (i.e. #SBATCH -t 12:00:00 to #SBATCH -t 24:00:00)
	- Change the time limit (i.e. #SBATCH -p short to #SBATCH -p medium)

![Stitching Error Debug](images/Stitching%20Error%20Debug.png)

**_## OUT_OF_MEMORY_**
- Request new memory
	- Double the memory request ( #SBATCH --mem-per-cpu=5G to #SBATCH --mem-per-cpu=10G)

**_## Gen_mask_****## 
**
- Move raw tif from the folder 0 to 0_skip, and remake raw_images.lst, skip.txt, re-prepare the job
- Steps:
	1. move tif files from folder 0 to 0_skip: 

run move_skip_file.py inside the folder
sample: /n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections/230310201555_jc105_2998/move_skip_file.py

	1. remake raw_image.lst

`find 0/ -name "*.tif" -exec basename {} \; >raw_images.lst`
	1. remove all content in skip.txt
	2. re-prepare the job (before prepare, go ~/repos/gtalign, check the status of the repo, if it is not on SEM compatible, 

`(py3.7) `**`sw307@gandalf`**`:`**`/n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections`**`$ prepare_section_for_alignment_O2.py 230301190458_jc105_2952`

**_## Resize the tile_**
**
**
1. run crop_resize.py

`cp ../230217232838_jc105_2560/crop_resize.py `
`python crop_resize.py`

1. move tif from 0_resample to 0, pbm from 0_resample to intrasection/masks/0

`mv 0/ 0_junk/`
`mv 0_resample/ 0/`
`rm -r intrasection/`
`
`
`for file in 0/*/*.pbm; do`
`    destination="intrasection/masks/0/${file#0/}"; `
`    mkdir -p "$(dirname "$destination")"`
`    mv "$file" "$destination"`
`done`
1. find the edge files and rm (for SEM)

`cp /n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections/python_codes/find_edge.py .`
`cp /n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections/python_codes/move_skip_file.py .`
`python find_edge.py `
`python move_skip_file.py`

1. remake raw_image.lst and prepare the job

`rm raw_images.lst`
`find 0/ -name "*.tif" -exec basename {} \; >raw_images.lst`
`cat size`
`rm size`
`rm skip.txt `
`cd ..`
`prepare_section_for_alignment_O2.py section#`
`
`
*example*:
`mv 0/ 0_junk/`
`mv 0_resample/ 0/`
`rm -r intrasection/`
`find 0/ -name "*.tif" -exec basename {} \; >raw_images.lst`
`
`
`for file in 0/*/*.pbm; do`
`    destination="intrasection/masks/0/${file#0/}"; `
`    mkdir -p "$(dirname "$destination")"`
`    cp "$file" "$destination"`
`done`
`cp ../230219115601_jc105_2563/find_edge.py .`
`cp ../230219115601_jc105_2563/move_skip_file.py .`
`python find_edge.py `
`#python move_skip_file.py`
`#rm raw_images.lst`
`#find 0/ -name "*.tif" -exec basename {} \; >raw_images.lst`
`cat size`
`rm size`
`#rm skip.txt `
`cd ..`
`
`

or 5. do this instead of step 1
**`sow439@login06`**`:`**`/n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections`**`$ sbatch crop_resample.sh '/n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/utils/240128151523_jc105_2275'`
`
`
`mv 0_resample/ /n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections/240128151523_jc105_2275/`
`
`
`cd /n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections/240128151523_jc105_2275/`
`find 0/ -name "*.tif" -exec basename {} \; >raw_images.lst`

**_## Re-submit the job when you get empty resin + too large to gen_mask_**
**`for`**` i in $(cat tiles_w_resin.txt); do mv $i 0_skip/; done`
`
`
`cp ../outlayer.py .`
`python outlayer.py`
`cp ../230219115601_jc105_2563/move_skip_file.py .`
`python move_skip_file.py `
`rm intrasection/*.lst`
`rm raw_images.lst`
`find 0/ -name "*.tif" -exec basename {} \; >raw_images.lst`
`cat size`
`rm size`
`rm skip.txt `
`cd ..`

**_## Inter-tile stitching result check_**
**
**
`cdjc`
`cd sections`
`./find_misalign_stitching_tiles.sh section# v/h SEM/TEM`
`./count_lines.sh section#/intrasection/``problematic_v_pairs.lst`
`
`
Use extract_number_from_list.py in 230407113218_jc105_3578 to find the pairs problem in other sections

**_## INITIAL MAP_**
**_
_****_
_**
`inter_preparation.py -v `pwd` lists/sections1330_3748_1201.lst -prob lists/prob_sections1330_3748_1201.lst `

`export PATH=/n/groups/htem/AlignTKO2/1.2.1/bin:$PATH`
`PAIRS=`cat lists/sections1344_3748_0206.lst.maplist | awk '{print $3}'``
`for i in $PAIRS; do best_translation -input intersection/fmaps/$i.map -output intersection/fmaps_best_translation/$i.map | tee intersection/fmaps_best_translation/$i.parameters; done`
`
`
`cd `**`/n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/intersection`**
**`
`**
`input_list="sections1344_3748_0206.lst "`
`output_dir=initial_maps_240217t_1344_3748`
`starting_section=$(listAcquisitions jc105 1344)`
`export PATH=/n/groups/htem/AlignTKO2/1.2.1/bin:$PATH`**`
`**
`
`
`workon py3.7`
`./find_minimal_edges.py ../lists/$input_list $starting_section`
`
`
`mkdir -p $output_dir`
`ln -sf ../identity.map $output_dir/$starting_section.map`
`./gen_initial_maps.job ../lists/$input_list $output_dir | tee $output_dir/gen_initial_maps.log`

change to o2
`input_list="sections1344_3748_0206.lst "`
`output_dir=initial_maps_240217t_1344_3748`
`starting_section=$(listAcquisitions jc105 1344)`
`
`
`for i in {1..2285..50}; do sbatch apply_initial_map.job $output_dir ../lists/$input_list $i 50; done`

### check initial_map result
`cd  `**`/intersection/initial_maps_231018t_1682_2000/aligned_512_links`**`
`
`convert *.tif -adjoin stack.tif`

**to change the file names systematically from xxxxx_jc105_2262 to 2262**
`for file in *.tif; do`
`    # Extract the last part of the file name (2262.tif)`
`    new_name=$(echo $file | grep -oE '[0-9]+\.tif')`
`    # Rename the file`
`    mv "$file" "$new_name"`
`done`

**_## zalign with anchor map_**
`inter_preparation.py -v `pwd` lists/sections1344_3748_0206.lst  -prob lists/`**`prob_sections1344_3748_0118`**`.lst  -alst lists/anchors_sections1344_3748.lst`
`
`
`inter_preparation.py -v `pwd` lists/anchors_sections1344_3748.lst `
`
`
**`./intersection/jobs/srun_align.sh`**` lists/sections1344_3748_0206.lst -x -i amaps_anchors -e -r 256 -q`

`for file in *.tif; do     new_name=$(echo "$file" | grep -oE '[0-9]+\.tif');     mv "$file" "$new_name"; done`

