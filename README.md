# OpenShift CICD Scope for ECI

1. I need to deploy Sterling's WS (reserve, getOrderList...) as single containers: Can i make a single container with just those API? Can i create as many app server containers as API i have and redirect traffic with a proxy (istio or whatever service mesh is in place) so that each container just receives the payload for that API?

    1.1.	Realtime synchronized micro service runtime
    1.2.	Service discovery
    1.3.	Service routing


2. I need to auto-scale based on load (both increase and decrease)

    2.1.	Auto-scale of real-time services
    2.2.	Auto-scale of async services


3. I would like to test a blue-green deployment

    3.1. Blue-green deployment on same transaction data store (There will be some limitation on this due to entity deployment that you are aware)

4. Deploy a complete Test environment (App + Agent + DB + MQ)

    4.1.	Full instance provision
    4.2.	Partial instance provision (maybe reuse DB and/or MQ)


5. How to build the docker images based on Helm charts

    5.1.	This is probably more as collaboration as demo
