# NGO Logistics Systems Comparison

## NGO Logistics D
**Technology Stack:** Node.js + TypeScript + MongoDB
**Port:** 5174 (Frontend), 5001 (Backend), 27018 (Database)
**Use Case:** Document-based data, flexible schema, rapid prototyping
**Data Directory:** `/tmp/ngologistics-d/`

### Features:
- MongoDB document storage
- TypeScript type safety
- JSON-based APIs
- Dynamic queries
- Horizontal scaling

## NGO Logistics CG  
**Technology Stack:** WebAssembly + MariaDB
**Port:** 5175 (Frontend), 5002 (Backend), 3307 (Database)
**Use Case:** Complex relational data, transactions, structured reporting
**Data Directory:** `/tmp/ngologistics-cg/`

### Features:
- MariaDB relational database
- WebAssembly client-side processing
- SQL queries and transactions
- ACID compliance
- Complex joins and aggregations

## Isolation Strategy

### Port Isolation:
| Service | NGO Logistics D | NGO Logistics CG |
|---------|----------------|------------------|
| Frontend | 5174 | 5175 |
| Backend API | 5001 | 5002 |
| Database | 27018 | 3307 |

### Data Isolation:
- Separate database instances
- Different data directories
- Independent configuration files

### Process Isolation:
- Separate Node.js processes
- Different database daemons
- Unique environment variables

## Usage Examples

### Start Individual Systems:
```bash
# Start only NGO Logistics D
start-ngologistics-d

# Start only NGO Logistics CG
start-ngologistics-cg
