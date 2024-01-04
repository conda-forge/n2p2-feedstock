#!/bin/bash
cd src

# Build libraries
export CFLAGS=${CFLAGS}" -isystem $PREFIX/include/eigen3"
if [[ "${mpi}" == "nompi" ]]; then
    MAKE_ARGS="PROJECT_OPTIONS=-DN2P2_NO_MPI PROJECT_MPICC=${CXX} PROJECT_CC=${CXX}"
fi

if [[ "${mpi}" == "nompi" ]]; then
    # libnnptrain can only work with MPI
    make -j${NUM_CPUS} libnnp libnnpif pynnp ${MAKE_ARGS}
else
    make -j${NUM_CPUS} libnnp libnnpif libnnptrain pynnp ${MAKE_ARGS}
fi
mkdir -p ${PREFIX}/include ${PREFIX}/lib ${PREFIX}/bin ${PREFIX}/python${PY_VER}/site-packages
mv ${SRC_DIR}/lib/pynnp* ${SP_DIR}
cp ${SRC_DIR}/lib/* ${PREFIX}/lib
cp ${SRC_DIR}/include/* ${PREFIX}/include
cp ${SRC_DIR}/src/libnnpif/LAMMPS/InterfaceLammps.h ${PREFIX}/include

if [[ "${mpi}" != "nompi" ]]; then
    # Build application
    export CFLAGS=${CXXFLAGS}
    export CC=${CXX}
    make -j${NUM_CPUS} all-app ${MAKE_ARGS}
    cp ${SRC_DIR}/bin/* ${PREFIX}/bin
fi
