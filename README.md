# 🚀 KTP: Reliable Transport Protocol over UDP

### *End-to-End Reliable Flow Control with Sliding Window & IPC*

---

## 📌 Overview

This project implements a **custom transport-layer protocol (KTP — KGP Transport Protocol)** that provides **reliable, ordered, and flow-controlled data transfer over unreliable UDP sockets**.

Unlike UDP, which offers **no guarantees**, KTP ensures:

* ✅ Reliable delivery
* ✅ In-order packet reception
* ✅ Flow control using sliding window
* ✅ Automatic retransmission on loss

This project is a **miniature TCP-like protocol**, built from scratch using:

* Low-level socket programming
* Shared memory (IPC)
* Semaphores for synchronization
* Multi-threaded architecture

---

## 🎯 Key Objectives

* Emulate **end-to-end reliability** over UDP
* Design a **custom socket API** (`k_socket`, `k_sendto`, etc.)
* Implement **sliding window flow control**
* Handle **packet loss, duplication, and reordering**
* Ensure **concurrent multi-process communication**

---

## 🧠 System Architecture

```text
User Process (user1 / user2)
        │
        ▼
   KTP API Layer
(k_socket, k_sendto, k_recvfrom)
        │
        ▼
 Shared Memory + Semaphores
        │
        ▼
 Init Process (initksocket)
 ├── Receiver Thread (R)
 ├── Sender Thread (S)
 └── Garbage Collector (GC)
        │
        ▼
      UDP Socket Layer
```

---

## ⚙️ Core Components

---

### 🔹 1. KTP Socket Library (`ksocket.c`, `ksocket.h`)

Implements the core API:

* `k_socket()` → creates KTP socket
* `k_bind()` → binds source/destination
* `k_sendto()` → sends data via buffer
* `k_recvfrom()` → receives ordered data
* `k_close()` → cleans resources

👉 Uses shared memory + semaphores for coordination

---

### 🔹 2. Initialization Service (`initksocket.c`)

A **central daemon process** responsible for:

* Creating UDP sockets
* Managing shared memory
* Running 3 critical threads:

#### 🧵 Receiver Thread (R)

* Listens using `select()`
* Processes:

  * DATA packets
  * ACK packets
* Handles:

  * Packet loss simulation
  * Window updates

---

#### 🧵 Sender Thread (S)

* Periodically checks:

  * Timeout events
  * Unsent packets
* Performs:

  * Retransmission
  * New packet dispatch

---

#### 🧵 Garbage Collector (GC)

* Detects dead processes
* Frees orphaned sockets
* Prevents resource leakage

---

### 🔹 3. User Applications

#### 📤 `user1.c` (Sender)

* Reads file (`file.txt`)
* Sends in chunks via `k_sendto()`
* Handles buffer-full conditions

#### 📥 `user2.c` (Receiver)

* Receives via `k_recvfrom()`
* Writes to output file
* Detects EOF marker

---

## 📦 Project Structure

```text
ktp-reliable-protocol/
├── src/
│   ├── ksocket.c
│   ├── ksocket.h
│   ├── initksocket.c
│   ├── user1.c
│   ├── user2.c
│
├── data/
│   └── file.txt
│
├── docs/
│   ├── documentation.txt
│   ├── report.pdf
│
├── Makefile
├── .gitignore
├── README.md
├── .github/workflows/network.yml
```

---

## 🔁 Protocol Design

---

### 🔹 Sliding Window Mechanism

* Fixed-size window (N = 10)
* Tracks:

  * Sent but unacknowledged packets
  * Receive buffer availability

---

### 🔹 Packet Format

```text
[TYPE][SEQ (8 bits)][LEN (10 bits)][DATA]
```

* TYPE → DATA / ACK
* SEQ → sequence number
* LEN → payload length

---

### 🔹 Reliability Features

* 📌 Sequence numbers (8-bit wraparound)
* 📌 ACK-based confirmation
* 📌 Timeout-based retransmission
* 📌 Duplicate detection
* 📌 In-order delivery guarantee

---

### 🔹 Flow Control

* Receiver advertises available buffer (`rwnd`)
* Sender adjusts window dynamically

---

## ⚠️ Packet Loss Simulation

Simulated using:

```c
int dropMessage(float p);
```

* Randomly drops packets with probability `p`
* Tests robustness under unreliable conditions

---

## 🧵 Concurrency Model

* Shared memory stores:

  * socket metadata
  * send/receive buffers
  * window state

* Semaphores ensure:

  * mutual exclusion
  * race-free updates

---

## 🛠️ Build Instructions

```bash
make
```

---

## ▶️ Execution

### Step 1: Start initialization service

```bash
./initksocket
```

---

### Step 2: Start receiver

```bash
./user2 127.0.0.1 5076 127.0.0.1 8081
```

---

### Step 3: Start sender

```bash
./user1 127.0.0.1 8081 127.0.0.1 5076
```

---

## 🧪 Testing

* Transfer files (>100KB recommended)
* Simulate packet loss
* Run multiple sender-receiver pairs

---

## 🔄 CI/CD Integration

Located at:

```text
.github/workflows/network.yml
```

### CI performs:

* Code checkout
* Compilation via Makefile
* Binary validation

> ⚠️ Full runtime testing is not executed in CI due to IPC and multi-process constraints.

---

## 📊 Performance Insights

* Efficient at low packet loss
* Retransmissions increase with loss probability
* Maintains correctness even under 50% loss

---

## ⚠️ Limitations

* No congestion control (unlike TCP)
* Fixed buffer sizes
* No encryption/security
* Localhost testing only

---

## 🚀 Future Enhancements

* Add congestion control (AIMD)
* Adaptive timeout (RTT estimation)
* Selective ACK (SACK)
* Multi-host deployment
* Logging & visualization tools

---

## 🧠 Learning Outcomes

This project demonstrates:

* Transport layer protocol design
* Reliable communication over unreliable channels
* IPC using shared memory & semaphores
* Multi-threaded system programming
* Network protocol debugging

---

## 👨‍💻 Author

* Souhardya Dandapat

## 📜 License

Academic / Educational Use Only

---

## ⭐ Final Note

This project is a **full-stack transport protocol implementation**, bridging:

* OS concepts (IPC, processes, threads)
* Networking (UDP, reliability, flow control)
* Systems design (modularity, synchronization)

It serves as a **strong foundation for advanced networking, distributed systems, and systems programming roles**.

---
