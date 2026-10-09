# KNU

## Kernel Names Unix

**KNU is a universal system recognition and communication architecture.**

### 1. Purpose

KNU enables independently operating computer systems to recognize one another and communicate through any mutually compatible, direct, consensual connection.

KNU is designed to span hardware generations, operating systems, processor architectures, and communication transports.

### 2. Core principles

* **Universality:** No single operating system or hardware architecture is required.
* **Recognition:** Connected systems can establish each other's identities.
* **Consent:** Connection alone does not grant permission to access another system.
* **Interoperability:** Systems communicate through a common protocol.
* **Adaptability:** Different transports and hardware interfaces can implement KNU.
* **Continuity:** Systems can exchange and synchronize shared state without requiring identical physical memory.
* **Extensibility:** The protocol can evolve without unnecessarily breaking compatible implementations.

### 3. System identity

Every KNU-compatible endpoint must be able to identify itself and describe its supported protocol version.

A system's identity should remain stable across ordinary reconnections and, where supported, operating system upgrades.

Identity must be verifiable; a claimed name alone is not proof of identity.

### 4. Connection lifecycle

A KNU connection follows these logical stages:

1. Establish a compatible transport.
2. Discover the remote endpoint.
3. Exchange protocol versions and identities.
4. Verify identities where authentication is supported.
5. Request and obtain the necessary consent.
6. Negotiate capabilities and permissions.
7. Exchange authorized messages and data.
8. Close the connection or revoke authorization when requested.

### 5. Initial protocol messages

* `DISCOVER` — announce or discover KNU-compatible endpoints.
* `IDENTIFY` — exchange endpoint identities.
* `NEGOTIATE` — establish compatible protocol versions.
* `CONSENT` — request, grant, or deny authorization.
* `CAPABILITIES` — advertise supported features.
* `MESSAGE` — exchange authorized information.
* `DISCONNECT` — terminate a connection.
* `REVOKE` — withdraw previously granted authorization.

These names define the initial logical message types, not a finalized wire format.

### 6. Memory and state

KNU distinguishes local physical memory from information shared between systems.

KNU may coordinate shared state, synchronized data, and persistent information without assuming that different devices have a common physical address space.

Access to shared information must respect the permissions granted by its owner.

### 7. Hardware and operating systems

KNU does not initially require its own kernel.

It may operate through software and hardware interfaces provided by existing systems. Legacy computers may require adapters or intermediary bridges.

A future KNU kernel would be a separate architectural development requiring its own memory management, scheduling, hardware support, security model, and boot process.

### 8. Initial objective

Demonstrate mutual recognition and consensual communication between two heterogeneous computer systems.

The long-term compatibility goal is to connect systems spanning Apple's computing history, from the Apple I to modern Macs, including the MacBook Neo.

### 9. Design rule

**Different systems. One common language. Mutual recognition. Consensual communication.**
