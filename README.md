
# CNFed - Cloud Native Federation – Thesis Deployment Prototype

This repository contains the implementation of a federated identity infrastructure, developed as part of my Bachelor's thesis. It showcases how core components of a federation—Identity Providers (IdPs), Service Providers (SPs), and registry services—can be deployed using modern DevOps practices with Kubernetes, Docker and Helm.

---

## 🌐 Overview

This prototype models a minimal but functional academic federation stack. It includes:

- **Shibboleth Identity Provider (IdP)** with OpenLDAP
- **Shibboleth Service Provider (SP)** integration with SAML
- **Jagger Federation Registry (MDS)** for metadata management
- **OpenLDAP storage for users
- Kubernetes-native deployment (federation-stack with Helm)


---

## 🛠️ Technologies

- Kubernetes (GKE, Helm)
- Docker & Docker Compose
- Shibboleth IdP / SP
- Jagger Federation Registry
- OpenLDAP
- Bash scripting & Makefiles

---


## 🤝 Acknowledgements

This work was supported by [CYNET – The Cyprus National Research and Education Network](https://www.cynet.ac.cy/) and the [GEANT Trust & Identity Incubator](https://geant.org). Their mentorship and exposure to production-level federation technologies greatly enriched this research.



