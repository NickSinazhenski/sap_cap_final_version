# Purchase Requests Management System (SAP CAP)

This is a training project built with **SAP Cloud Application Programming Model (CAP)** and **SAP Fiori Elements**.  
The application manages purchase requests with draft support, composition, and an approval workflow.

---

## Project Structure

app/  
- project1/ — requester view 
- project/ — approver view 


db/  
- schema.cds — domain model (entities, associations, composition)  
- data/ — initial CSV data  

srv/  
- service.cds — OData service definition  
- service.js — service implementation  
- handlers/ — business logic (read, create, update, approve, reject)  

package.json  
README.md  

---

## Domain Model Overview

### PurchaseRequest (Main Entity)
- ID (UUID)
- requestType
- requester
- status
- rejectReason
- totalAmount
- currency
- rates (Composition → PurchaseRequestCurrency)

### PurchaseRequestCurrency (Composition)
- ID
- currency
- amount
- parent (PurchaseRequest)

---

## Key Features

- SAP Fiori Elements List Report and Object Page
- Draft handling using `@odata.draft.enabled`
- Composition handling
- Role-based behavior (requester / approver)
- Custom OData actions:
  - CreateRequest
  - UpdateRequest
  - DeleteRequest
  - Approve
  - Reject
  - ChangeStatus

---

## How to Run the Project




```bash
npm install

cds watch

- CAP Backend
http://localhost:4004

- Fiori Application
 -requester 
http://localhost:4004/app.purchase.purchaseapp.project1/index.html
 -approver 
http://localhost:4004/app.purchase.approver.project2/index.html




