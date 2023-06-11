# HH-suite-database
#安装work、work2中的依赖项，路径请自行修改
mkdir ~/kangyufei/work/MMseqs2/build
cd ~/kangyufei/work/MMseqs2/build
chmod a+x ../cmake/checkshell.sh
cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=. ..
make
make install 
export PATH=~/kangyufei/work/MMseqs2/build/bin/:$PATH
export PATH=~/kangyufei/work/MMseqs2/build/util/:$PATH

mkdir ~/kangyufei/work/hh-suite/build
cd ~/kangyufei/work/hh-suite/build
cmake -DCMAKE_INSTALL_PREFIX=. ..
make
make install
export HHLIB=~/kangyufei/work/hh-suite
export PATH=~/kangyufei/work/hh-suite/build/bin/:$PATH
export PATH=~/kangyufei/work/hh-suite/build/scripts/:$PATH

cd ~/kangyufei/work/argtable2-13
chmod a+x tests/*.sh
chmod a+x configure
./configure --prefix=/public/dbu/kangyufei/work/argtable2-13/build/
make check
make
make install
export PATH=~/kangyufei/work/argtable2-13:$PATH
export PATH=~/kangyufei/work/argtable2-13/build/lib:$PATH
export PATH=~/kangyufei/work/argtable2-13/build/include:$PATH
export LD_LIBRARY_PATH=~/kangyufei/work/argtable2-13/build/lib:$LD_LIBRARY_PATH

cd ~/kangyufei/work/clustal-omega-1.2.4
chmod a+x configure
./configure CFLAGS='-I/public/dbu/kangyufei/work/argtable2-13/build/include/' LDFLAGS='-L/public/dbu/kangyufei/work/argtable2-13/build/lib/' --prefix=/public/dbu/kangyufei/work/clustal-omega-1.2.4/build/
make check
make
make install
export PATH=~/kangyufei/work/clustal-omega-1.2.4:$PATH
export PATH=~/kangyufei/work/clustal-omega-1.2.4/build/bin:$PATH
export PATH=~/kangyufei/work/clustal-omega-1.2.4/build/include:$PATH

cd ~/kangyufei/work/kalign
mkdir build 
cd build
cmake .. 
make 
make test 
make install
export PATH=~/kangyufei/work/kalign:$PATH
export PATH=~/kangyufei/work/kalign/build/lib:$PATH
export PATH=~/kangyufei/work/kalign/build/bin:$PATH
export PATH=~/kangyufei/work/kalign/build/include:$PATH

cd ~/kangyufei/work/hashdeep-4.4
sh bootstrap.sh
./configure --prefix=/public/dbu/kangyufei/work/hashdeep-4.4/build/
make
make install
export PATH=~/kangyufei/work/hashdeep-4.4:$PATH
export PATH=~/kangyufei/work/hashdeep-4.4/build/bin:$PATH

cd ~/kangyufei/work/FAMSA-master
make
export PATH=~/kangyufei/work/FAMSA-master:$PATH

# 初始化环境变量,路径请自行修改
export PATH=~/kangyufei/work/MMseqs2/build/bin/:$PATH
export PATH=~/kangyufei/work/MMseqs2/build/util/:$PATH

export HHLIB=~/kangyufei/work/hh-suite/build
export PATH=~/kangyufei/work/hh-suite/build/bin/:$PATH
export PATH=~/kangyufei/work/hh-suite/build/scripts/:$PATH

export PATH=~/kangyufei/work/argtable2-13/:$PATH
export PATH=~/kangyufei/work/argtable2-13/build/lib/:$PATH
export PATH=~/kangyufei/work/argtable2-13/build/include/:$PATH
export LD_LIBRARY_PATH=~/kangyufei/work/argtable2-13/build/lib/:$LD_LIBRARY_PATH

export PATH=~/kangyufei/work/clustal-omega-1.2.4:$PATH
export PATH=~/kangyufei/work/clustal-omega-1.2.4/build/bin:$PATH
export PATH=~/kangyufei/work/clustal-omega-1.2.4/build/include:$PATH

export PATH=~/kangyufei/work/kalign:$PATH
export PATH=~/kangyufei/work/kalign/build/lib:$PATH
export PATH=~/kangyufei/work/kalign/build/bin:$PATH
export PATH=~/kangyufei/work/kalign/build/include:$PATH

export PATH=~/kangyufei/work/hashdeep-4.4:$PATH
export PATH=~/kangyufei/work/hashdeep-4.4/build/bin:$PATH

export PATH=~/kangyufei/work/FAMSA-master:$PATH
