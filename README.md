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

2. Download or clone the entire contents of the temperature model code repo at https://github.com/FRahmani368/LSTM_Temperature. Copy the essential code files into the "tmp" folder in this project to create
```
- in_data
  - Data - ERL paper
  - LSTM_Temperature
    - the essential code files from the LSTM_Temperature repo go here
```

3. Run `scipiper::scmake()`.
