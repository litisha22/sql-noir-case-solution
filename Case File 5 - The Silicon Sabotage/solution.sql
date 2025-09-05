-- ⚡SQL Noir - Case File 5: The Silicon Sabotage
-- Crime Type: Corporate Espionage and Sabotage
-- Location: QuantumTech Headquarters
-- Date: Unknown

------------------------------------------------------
-- Step 1: Incident Report
-- The countdown to invention shattered at QuantumTech, 
-- where ambition burned bright—and suddenly, went dark.
-- The prototype microprocessor QuantaX was destroyed,
-- and research data erased just hours before its grand debut.
-- Let’s sift through the incident logs to find the first tremor
-- signaling this high-tech betrayal.
------------------------------------------------------
SELECT * 
FROM incident_reports
WHERE LOWER(location) LIKE '%quantumtech%';

-- April 21, 1989—the day the QuantaX prototype was lost.

-- ------------------------------------------------------
-- Step 2: Witness Statements
-- Voices around QuantumTech whisper fragments of truth.
-- Employees who saw shadows, heard hurried footsteps,
-- or noticed strange behavior come forward.
-- These statements may hold cracks in the saboteur’s facade.
------------------------------------------------------
SELECT id, incident_id, employee_id, statement
FROM witness_statements
WHERE incident_id = 74;

-- ------------------------------------------------------
-- Witness Statements Insights
-- Mentions of a server located in Helsinki.
-- Observation of a keycard labeled “QX-” followed by a two-digit odd number.

-- ------------------------------------------------------
-- Step 3: Identifying Suspects
-- Narrowing down to employees active on April 21, 1989,
-- who accessed the Helsinki server and used the specific "QX-" keycard.
-- This intersection filters the list to those directly linked by access logs.
------------------------------------------------------
WITH suspects AS (
    SELECT DISTINCT e.id, e.employee_name, e.department, e.occupation, e.home_address
    FROM employee_records e
    INNER JOIN computer_access_logs c ON e.id = c.employee_id
    INNER JOIN keycard_access_logs k ON e.id = k.employee_id
    WHERE k.access_date = '19890421'
      AND c.server_location = 'Helsinki'
      AND k.keycard_code LIKE 'QX-%'
      AND CAST(SUBSTRING(k.keycard_code, 4, 2) AS INT) % 2 = 1
)
SELECT * FROM suspects;

-- ------------------------------------------------------
-- Step 4: Collecting Statements from Suspects
-- We focus squarely on the suspects identified in Step 3,
-- gathering all statements they made to prune truth from deception.
------------------------------------------------------
WITH suspects AS (
    SELECT DISTINCT e.id, e.employee_name, e.department, e.occupation, e.home_address
    FROM employee_records e
    INNER JOIN computer_access_logs c ON e.id = c.employee_id
    INNER JOIN keycard_access_logs k ON e.id = k.employee_id
    WHERE k.access_date = '19890421'
      AND c.server_location = 'Helsinki'
      AND k.keycard_code LIKE 'QX-%'
      AND CAST(SUBSTRING(k.keycard_code, 4, 2) AS INT) % 2 = 1
)
SELECT ws.employee_id, STRING_AGG(ws.statement, '; ') AS statement
FROM witness_statements ws
WHERE ws.employee_id IN (SELECT DISTINCT id FROM suspects)
GROUP BY ws.employee_id;

-- ------------------------------------------------------
-- Statements from Suspects
-- Observations include suspicious activity near the roof via fire escape,
-- multiple individuals wearing identical disguises,
-- a colleague's email warning that something was wrong with the alarm system,
-- a physical check found no immediate issues,
-- systematic disabling of exterior lights,
-- and recent tampering with the security panel.
-- These details collectively suggest planned sabotage and efforts to disable security.

-- ------------------------------------------------------
-- Step 5: Identifying Sender of Alarm Warning Email
-- Investigating the inbox of employee ID 99,
-- the recipient of the alarm system warning email on the day of sabotage.
-- This may reveal hidden clues or conspiratorial messages.
------------------------------------------------------
SELECT sender_employee_id
FROM email_logs
WHERE recipient_employee_id = 99
  AND email_date = 19890421;

-- ------------------------------------------------------
-- Step 6: Investigate the Inbox of the False Alarm Email Sender
-- Checking emails sent to the person who warned employee 99,
-- to uncover further communications linked to the sabotage day.
------------------------------------------------------
SELECT sender_employee_id, email_subject, email_content
FROM email_logs
WHERE recipient_employee_id IN (
    SELECT sender_employee_id
    FROM email_logs
    WHERE recipient_employee_id = 99
      AND email_date = 19890421
);

