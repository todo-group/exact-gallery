#!/bin/sh

SOURCE_DIR=${HOME}/development/exact
BUILD_DIR=${HOME}/build/exact
EXE=${BUILD_DIR}/ising/free_energy/square_finite
HEADER_N=3
RESULT_N=1
PREFIX=$(basename $0 .sh)

L="4 8 16 32 64"
T=$(python3 -c "for i in range(350,1000+1,5): print(1/(i/1000))")

(cd ${SOURCE_DIR} && git log HEAD) | head -3 > version.log

export OMP_NUM_THREADS=1
parallel --results ${PREFIX} --joblog ${PREFIX}.log "${EXE} {}" ::: ${L} ::: ${T}

for l in ${L}; do
  OUTPUT=${PREFIX}-L${l}.dat
  head -n ${HEADER_N} ${PREFIX}/1/${l}/2/$(echo ${T} | cut -d ' ' -f 1)/stdout > ${OUTPUT}
  for t in ${T}; do
    tail -n ${RESULT_N} ${PREFIX}/1/${l}/2/${t}/stdout >> ${OUTPUT}
  done
done
