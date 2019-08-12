# OpenShift_CICD_ECI

  I need to deploy Sterling's WS (reserve, getOrderList...) as single containers: Can i make a single container with just those API? Can i create as many app server containers as API i have and redirect traffic with a proxy (istio or whatever service mesh is in place) so that each container just receives the payload for that API?

1.	Realtime synchronized micro service runtime
2.	Service discovery

3.	Service routing


  I need to auto-scale based on load (both increase and decrease)

1.	Auto-scale of real-time services
2.	Auto-scale of async services


  I would like to test a blue-green deployment

1.	Blue-green deployment on same transaction data store

1.	There will be some limitation on this due to entity deployment that you are aware.
  Deploy a complete Test environment (App + Agent + DB + MQ)

1.	Full instance provision
2.	Partial instance provision (maybe reuse DB and/or MQ)


  How to build the docker images based on Helm charts

1.	This is probably more as collaboration as demo
