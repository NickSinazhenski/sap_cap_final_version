# Purchase Requests Management System (SAP CAP)

This is a training project built with **SAP CAP** and **SAP Fiori Elements**.  
The application manages purchase requests and an approval workflow.

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
- ptoduct
- rates (Composition → PurchaseRequestCurrency)

### PurchaseRequestCurrency (Composition)
- currency
- parent (PurchaseRequest)
- amount

---

## How to Run the Project

```bash
git clone 
```
```bash
npm install
```
```bash
cds watch
```
- CAP Backend
```bash
http://localhost:4004
```
- requester view

```bash
http://localhost:4004/app.purchase.purchaseapp.project1/index.html
```
 - approver view
```bash
http://localhost:4004/app.purchase.approver.project2/index.html
```





