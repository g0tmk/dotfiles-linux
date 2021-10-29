# How to recover corrupted .tar.gz file

# note: when I tried this, the commands worked, but I did not recover any
#       more data than I got from a simple tar xvf

- Download latest gzrt

    wget https://www.urbanophile.com/arenn/hacking/gzrt/gzrt-0.8.tar.gz
    tar xvf gzrt*
    cd gzrt*
    sudo apt install build-essential zlib1g zlib1g-dev
    make
    gzrecover foo.tar.gz
    cpio -F foo.tar.recovered -i -v --no-absolute-fileames >stdout.log 2>stderr.log

