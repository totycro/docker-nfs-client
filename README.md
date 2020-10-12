# docker-nfs-client
Minimal nfs-client docker image safe for use in kubernetes

Use a configuration like this to be able to access an nfs share from a container, such that only the nfs-client container needs the privileged mode.

```yaml
apiVersion: v1
kind: Pod
metadata:
    [...]
spec:
  containers:
  -
    [...]
    name: main-container
    volumeMounts:
    - mountPath: /mnt
      name: nfs-shared
      mountPropagation: HostToContainer
  - name: nfs-client
    image: totycro/nfs-client:0.1.0
    env:
    - name: MOUNT_TARGET
      value: my-nfs-server:/
    - name: MOUNT_POINT
      value: /mnt
    - name: MOUNT_OPTIONS
      value: "nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport"
    securityContext:
      privileged: true
    volumeMounts:
    - name: nfs-shared
      mountPath: /mnt
      mountPropagation: Bidirectional
  volumes:
  - name: nfs-shared
    emptyDir: {}
```
