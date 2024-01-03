#!/bin/bash
cd src

# Build libraries
export CFLAGS=${CFLAGS}" -isystem $PREFIX/include/eigen3"
if [[ "${mpi}" == "nompi" ]]; then
    MAKE_ARGS="PROJECT_OPTIONS=-DN2P2_NO_MPI PROJECT_MPICC=clang++"
fi

make -j${NUM_CPUS} libnnp libnnpif libnnptrain pynnp ${MAKE_ARGS}
mkdir -p ${PREFIX}/include ${PREFIX}/lib ${PREFIX}/bin ${PREFIX}/python${PY_VER}/site-packages
mv ${SRC_DIR}/lib/pynnp* ${SP_DIR}
cp ${SRC_DIR}/lib/* ${PREFIX}/lib
cp ${SRC_DIR}/include/* ${PREFIX}/include
cp ${SRC_DIR}/src/libnnpif/LAMMPS/InterfaceLammps.h ${PREFIX}/include

# Build application
export CFLAGS=${CXXFLAGS}
export CC=${CXX}
make -j${NUM_CPUS} all-app ${MAKE_ARGS}
cp ${SRC_DIR}/bin/* ${PREFIX}/bin
