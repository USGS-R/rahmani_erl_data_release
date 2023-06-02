Active development moved to https://code.usgs.gov/wma/wp/data-releases/rahmani_erl_data_release

## Data release to accompany Rahmani et al., Exploring the exceptional performance of a deep learning stream temperature model and the value of streamflow data


## Building this release

0. Sam created a ScienceBase data release whose parent item is [here](https://www.sciencebase.gov/catalog/item/5f908bae82ce720ee2d0fef2).

1. Download the entire contents of the "Data - ERL paper" folder at https://drive.google.com/drive/u/0/folders/1i3BDRPThyLmVYwaIjxIVpiGf61E3pLzq. Unzip into the "tmp" folder in this project to create
```
- in_data
  - Data - ERL paper
    - Forcing_attrFiles
    - LR
    - etc.
```

2. Download or clone the entire contents of the temperature model code repo from https://github.com/FRahmani368/LSTM_Temperature into a directory called LSTM_Temperature just adjacent to rahmani_erl_data_release. Switch to the data release branch of that repository (`erl-release`).
```
- [parent folder]
  - rahmani_erl_data_release
  - LSTM_Temperature
      - hydroDL
      - StreamTemp-Integ.py
      - etc.
```

3. Run `scipiper::scmake()`.

## Testing the code

To get an interactive allocation on Slurm with GPU:

```sh
ssh tallgrass.cr.usgs.gov
salloc -N 1 -n 1 -c 1 --gres=gpu:1 -p gpu --mem=256GB -A watertemp -t 5:00:00
squeue
ssh dl-0001 # or whichever node you get assigned in squeue
cd /caldera/projects/usgs/water/iidd/datasci/psu/LSTM_Temperature # or wherever you put a copy of the code
module load cuda10.0/toolkit/10.0.130
conda activate lstm_tq
# [edit StreamTemp-Integ.py and/or hydroDL/data/camels.py if needed]
python StreamTemp-Integ.py
```
