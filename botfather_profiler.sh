#!/bin/sh

# Lấy PID của tiến trình botfather
BOTFATHER_PID=$(ps aux | grep '[b]otfather' | awk '{print $2}')

# Kiểm tra nếu không tìm thấy PID
if [ -z "$BOTFATHER_PID" ]; then
  echo "Không tìm thấy tiến trình botfather."
  exit 1
fi
# Thiết lập thời gian sleep, mặc định là 10 nếu không truyền
SLEEP_DURATION=${1:-10}

echo "Ghi flamegraph cho botfather (PID: $BOTFATHER_PID) trong $SLEEP_DURATION giây..."

# Ghi dữ liệu perf
sudo perf record -g --call-graph=dwarf -p $BOTFATHER_PID -- sleep $SLEEP_DURATION

# Tạo flamegraph
sudo perf script > out.perf
./stackcollapse-perf.pl out.perf | ./stackcollapse-recursive.pl > out.folded
./flamegraph.pl out.folded > flamegraph.svg

echo "Hoàn tất. Flamegraph lưu tại flamegraph.svg"

cp flamegraph.svg ~/FileServer/public/flamegraph.svg

# perf report
