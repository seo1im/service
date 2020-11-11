Kubenetes
===
## 기본 실행
pod를 생성 -> Service로 실행(selector로 연결)

## yaml
apiVersion: 쿠버네티스 api버전 명시
kind: 오브젝트 혹은 컨트롤러의 종류 명시
metadata: 이름이나 label설정
spec: 파드가 어떤 컨테이너로 어떻게 동작할지를 설정한다.

## Pod
### yaml
```yaml
~~~
metadata:
  name: #파드 이름
  labels: #오브젝트를 식별할 레이블을 설정
    app: my-pod #example: 해당 파드가 app container이고 식별자는 my-pod이다(일종의 이름)
spec:
  containers:
  - name: #컨테이너 이름 설정
    image: #사용할 docker image
    ports:
    -containerPort: #컨테이너 접속 포트
```

### 생명주기
Pending(생성중) -> Runnig(실행중) -> Succeeded(종료 : 재시작X)<br>
Fail(비정상적 종료)

## Deployment
상태가 없는 앱을 배포하는 가장 기본적인 컨트롤러

### yaml
```yaml
spec:
  replicas: #파드의 실행 개수를 설정
  selector: #어떤 레이블의 파드를 선택해 관리할지 명시
    matchLabels:
      app: nginx-deployment #metadata.labels와 동일하게 설정해야 한다.
    template: #실행할 파드에 대한 정보를 담고 있음
      metadata:
        labels:
          app: nginx-deployment
      spec:
        containers: #실제 사용하는 컨테이너의 이름과 이미지를 설정 
        - name: nginx-deployment #example
          image: nginx 
```

### 이미지의 업데이트
1. kubectl set
2. kubectl edit
3. kubectl apply(이미지를 수정한 후 적용)


## Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: #서비스 타입 설정(기본 : Cluster IP)
	selector: #서비스에 연결할 labels의 필드 value
	ports: #여러개의 port를 연결
```

#### describe service 내용
Name: service 이름
Namespace: 속한 namespace
Selector: 선택되어진 파드
Endpoint: 실제로 서비스에 연결된 파드의 IP

#### LoadBalancer Type
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-loadbalancer
spec:
  type: LoadBalancer
  selector: 
    app: #Pod label
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

## Secret 사용하기
```yaml
spec:
  emv:
  - name: SECRET_USERNAME
    valueFrom:
      secretKeyRef:
        name: #matched name
        key: #키 value
```

## Volume
컨테이너를 재시작하더라도 데이터를 유지시켜야 하는 경우<br>
PV : 볼륨 자체, 파드와는 별개로 관리됨
PVC : 사용자가 PV에 하는 요청

#### 순서
1. 프로비저닝 : PV를 반드는 과정
2. 바인딩 : PV와 PVC를 연결하는 과정 (PV와 PVC는 1:1 매칭)
3. 사용 : PVC는 파드에 할당되어 사용(파드는 PVC를 볼륨으로 인식)
4. 반환 : PVC를 삭제하고 PV를 초기화한다.

### yaml
#### PV
```yaml
kind: PersistentVolume
matadata:
  name: pv-hostpath-label
  labels:
    location: local
spec:
  capacity: #용량 설정
    storage: 2Gi
  volumeMode: Filesystem #볼륨의 시스템 설정
  accessModes: #볼륨의 읽기 쓰기 옵션 설정
  - ReadWriteOnce
  storageClassName: manual #스토리지 클래스 설정
  persistentVolumeReclaimPolicy: Delete #PV해제시 초기화 옵션
  hostPath: #Volume 플러그인 명시
    path: tmp/k8s-pv
```

#### PVC
```yaml
spec:
  accessModes:
  -ReadWriteOnce
  volumeMode: FileSystem
  resources:
    requests:
      storage: 1Gi
  storageClassName: manual
  selector: #matched pv label
    matchLabels:
      location: local
```

### pod에서 PVC를 볼륨으로 사용하는법
```yaml
spec:
  containers:
    ~~~
    volumMounts:
    - name: #matched mount volume name
      mountPath: #path
  volumes:
  - name: #volume name
    persistentVolumeClaim:
      claimName: #만들어진 PVC name
```

#### PVC만 설정하여도 자동적으로 PV를 설정한다.

## etc
1. environment 설정
2. kustomization.yaml
3. tier / imagePullPolicy
4. spec.strategy.type
5. template.spec.restartPolicy
6. kind: PersistentVolumeClaim / PersistentVolume
7. volumeMount