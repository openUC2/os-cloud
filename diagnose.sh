#!/bin/bash

set +e

echo "=== Identity ==="
id

echo "=== UID mapping ==="
cat /proc/self/uid_map

echo "=== Security context ==="
cat /proc/self/attr/current
grep -E '^(Cap(Inh|Prm|Eff|Bnd)|NoNewPrivs|Seccomp):' /proc/self/status

echo "=== Namespace limits ==="
cat /proc/sys/user/max_user_namespaces

echo "=== unshare test ==="
unshare -Ur true
echo "unshare exit code: $?"

echo "=== bubblewrap user namespace test ==="
bwrap --unshare-user -- /usr/bin/true
echo "bwrap user namespace exit code: $?"

echo "=== bubblewrap mount namespace test ==="
bwrap --unshare-all --ro-bind / / /usr/bin/true
echo "bwrap mount namespace exit code: $?"

echo "=== Namespace types ==="
readlink /proc/self/ns/user
readlink /proc/self/ns/mnt

echo "=== Bubblewrap version and location ==="
command -v bwrap
bwrap --version

echo "=== Explicit network namespace ==="
bwrap --unshare-net --ro-bind / / /usr/bin/true
echo "bwrap --unshare-net exit code: $?"

echo "=== All namespaces, explicitly sharing network ==="
bwrap --unshare-all --share-net --ro-bind / / /usr/bin/true
echo "bwrap --share-net exit code: $?"

echo "=== Capability check ==="
capsh --decode=0x802405fb
