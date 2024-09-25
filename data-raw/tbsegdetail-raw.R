# detailed tampa bay segments, from benthic-dash ----------------------------------------------

load(file = url('https://github.com/tbep-tech/benthic-dash/raw/refs/heads/main/data/segs.RData'))

tbsegdetail <- segs

save(tbsegdetail, file = 'data/tbsegdetail.RData', compress = 'xz')
