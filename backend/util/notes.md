Perfect 👌 thanks for pasting the full assignment. Let me **break it down in plain words** so you know *exactly* what you have to build and what the company will expect in your submission.

---

## 📌 What You’re Building

You’re building a **prototype mobile app in Flutter** that simulates a **request & confirmation workflow system** with **two roles**:

1. **End User** → Requests items.
2. **Receiver** → Reviews and confirms which items are available.

Think of it like this:

* A person requests 3 medicines from a pharmacy (End User).
* The pharmacist (Receiver) checks stock one by one: confirms 2 medicines are available, 1 is not → request becomes **Partially Fulfilled**, and the missing item gets reassigned elsewhere.

---

## 👤 Roles & Their Features

### 1. **End User**

* Can **create a request** → Example: "I need Item A, Item B, Item C".
* **Submit the request** → Goes into backend.
* **Track requests** with status:

  * `Pending` → request submitted, waiting for Receiver.
  * `Confirmed` → all items available.
  * `Partially Fulfilled` → some confirmed, some reassigned.
* Must see **real-time updates** of status (e.g., if Receiver marks one item as available, the End User sees update without Firebase).

---

### 2. **Receiver**

* Sees **requests assigned to them**.
* Opens a request → gets list of items.
* For each item, marks **Available** or **Not Available**.
* Submits response:

  * If all items are available → request becomes `Confirmed`.
  * If some are available → request becomes `Partially Fulfilled`.

    * Backend should handle **reassigning unconfirmed items** to another Receiver.

---

## ⚙️ Backend / Mock Server

You need a **very simple backend**. They give you freedom:

* Node.js/Express ✅
* Django ✅
* Or even a **Mock JSON Server** ✅

It must support APIs:

* `POST /requests` → Create a request.
* `GET /requests?role=enduser&id=123` → Fetch End User requests.
* `GET /requests?role=receiver&id=456` → Fetch Receiver’s assigned requests.
* `PATCH /requests/:id` → Update confirmation status of items.

👉 You **don’t need Firebase**. Instead:

* Either use **polling** (app keeps checking backend every X seconds for updates).
* Or use **WebSockets** (real-time push from server → better if you can).

---

## 🔐 Authentication

* Just **basic login**:

  * Example:

    * User1 logs in as **End User**.
    * User2 logs in as **Receiver**.
* No need for OAuth/Google login, just a **simple role-based login**.

---

## 🏗️ State Management

They recommend **Riverpod** (best choice for clean architecture), or **Provider**.
This ensures:

* You separate UI, business logic, and API calls properly.
* Code looks clean and professional.

---

## ⚠️ Error Handling

* Handle cases like:

  * If API request fails → show error message.
  * If Receiver submits without confirming all items → show warning.
  * If network is down → retry/prompt.

---

## 🎨 UI/UX

* Don’t waste time on flashy design.
* Focus on:

  * Simple, clean layout.
  * Clear item statuses (Pending / Confirmed / Partially Fulfilled).
  * Buttons & lists should look professional but minimal.

---

## 📂 Deliverables

1. **Flutter App** with:

   * End User role.
   * Receiver role.
   * Real-time updates (polling or WebSocket).
   * Proper state management.

2. **Backend / Mock API** with endpoints for request creation & updates.

3. **GitHub Repo** with:

   * Full code (Flutter + Backend).
   * `README.md`:

     * Setup steps (how to run backend + app).
     * API endpoints.
     * Your design explanation.

4. **Short demo video (2–5 min)**:

   * End User creates request.
   * Receiver confirms items.
   * Status updates in real time.

---

## ✅ Evaluation Criteria

They’ll check:

* If **both roles work** correctly.
* If **partial confirmation is handled properly** (important point!).
* If **real-time updates** work without Firebase.
* If **state management** is clean.
* If **UI is simple & professional**.
* If your repo + documentation is clear.

---

## 📝 Checklist for You

* [ ] End User: Create request with multiple items.
* [ ] End User: See statuses (Pending / Confirmed / Partially Fulfilled).
* [ ] Receiver: View assigned requests.
* [ ] Receiver: Confirm each item individually.
* [ ] System: Update request status.
* [ ] Backend: Handle unconfirmed items → reassign.
* [ ] Real-time update → via polling or WebSocket.
* [ ] Role-based login.
* [ ] Error handling.
* [ ] Clean code (Riverpod/Provider).
* [ ] GitHub repo with README + demo video.

---

👉 In short:
You’re making a **mini request-confirmation workflow system in Flutter** with a **mock backend**, 2 roles, and real-time status updates.

---

Would you like me to **create a step-by-step day-wise roadmap** (like Day 1 → set up backend, Day 2 → implement End User side, Day 3 → Receiver side, etc.) so you can finish this assignment quickly and cleanly?
