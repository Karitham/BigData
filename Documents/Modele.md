# Modele

```yaml
facts:
  - id: serial
  - event: enum
  - patient_id: integer
  - date_id: integer
  - clinic_id: integer
  - practician_id: ?integer # perhaps NULL when event is death, unless death at hospital
  - satisfacton_rate: ?integer # NULL when event is death or empty

patients:
  - id: serial
  - name: varchar
  - surname: varchar
  - address_id: varchar
  - sex: enum
  - birth_date_id: integer # refers to birth date from date table

date:
  - id: serial
  - minute: integer
  - hour: integer
  - day: integer
  - month: enum
  - year: integer

address_id:
  - id: serial
  - postcode: varchar
  - region: varchar
  - dept: varchar
  - country: varchar
  - street: varchar
  - number: varchar
  - comment: varchar

clinic:
  - address_id: integer
  - name: varchar

practician:
  - name: varchar
  - surname: varchar
  - address_id: integer
```
