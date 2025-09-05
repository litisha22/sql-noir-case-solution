-- ⚓ SQL Noir - Case File 3: The Miami Marina Murder
-- Crime Type: Homicide
-- Location: Coral Bay Marina
-- Date: August 14, 1986

------------------------------------------------------
-- Step 1: Crime Scene Report
-- The night was heavy with salt and secrets.
-- A body turned up near the docks of Coral Bay Marina.
-- Crime scene records on August 14, 1986, set the stage.
------------------------------------------------------
SELECT id, date, location, description
FROM crime_scene
WHERE date = 19860814
  AND location = 'Coral Bay Marina';

------------------------------------------------------
-- Step 2: Persons of Interest
-- The crime scene whispers gave us two clues:
--   • A man from "300ish Ocean Drive"
--   • Another whose first name ends with 'ul'
--     and whose last name ends with 'ez'
--
-- Time to pull records from the "person" file,
-- and see which shadows fit the description.
------------------------------------------------------
SELECT id, name, alias, occupation, address 
FROM person
WHERE LOWER(address) LIKE '3__ ocean drive'
   OR (LOWER(SUBSTRING(name, 1, CHARINDEX(' ', name)-1)) LIKE '%ul' 
       AND LOWER(SUBSTRING(name, CHARINDEX(' ', name)+1)) LIKE '%ez');

------------------------------------------------------
-- Step 3: Witness Interrogations
-- Two names surfaced from Step 2's search.
-- Now it's time to lean in, light the lamp,
-- and go through their interview transcripts.
------------------------------------------------------
SELECT p.id, p.name, p.alias, p.occupation, p.address, i.transcript
FROM person p
INNER JOIN interviews i ON p.id = i.person_id
WHERE LOWER(p.address) LIKE '3__ ocean drive'
   OR (LOWER(SUBSTRING(p.name, 1, CHARINDEX(' ', p.name)-1)) LIKE '%ul' 
       AND LOWER(SUBSTRING(p.name, CHARINDEX(' ', p.name)+1)) LIKE '%ez');

------------------------------------------------------
-- Step 4: Hotel Surveillance
-- The witnesses gave us our lead:
--   • A nervous check-in on August 13
--   • A hotel with "Sunset" in the name
--
-- Time to pull hotel check-in and surveillance records
-- to see who walked through Sunset's doors that night.
------------------------------------------------------
SELECT hc.check_in_date, sr.hotel_checkin_id, hc.hotel_name,
       sr.person_id, p.name, sr.suspicious_activity 
FROM surveillance_records sr
INNER JOIN hotel_checkins hc ON sr.hotel_checkin_id  = hc.id
INNER JOIN person p ON sr.person_id = p.id
WHERE hc.check_in_date = 19860813
  AND LOWER(hc.hotel_name) LIKE '%sunset%'
  AND sr.suspicious_activity IS NOT NULL;

------------------------------------------------------
-- Step 5: The Sunset Guest Speaks
-- Step 4 brought in more than one name from Sunset.
-- Not all nervous smiles mean guilt, but one transcript
-- may hold the crack in their story.
--
-- This query pulls the interview records of every suspect
-- flagged with suspicious activity at Sunset on Aug 13.
------------------------------------------------------
SELECT sr.hotel_checkin_id, hc.hotel_name, sr.person_id, p.name, 
       sr.suspicious_activity, i.transcript 
FROM surveillance_records sr
INNER JOIN hotel_checkins hc ON sr.hotel_checkin_id  = hc.id
INNER JOIN person p ON sr.person_id = p.id
INNER JOIN interviews i ON sr.person_id = i.person_id
WHERE hc.check_in_date = 19860813
  AND LOWER(hc.hotel_name) LIKE '%sunset%'
  AND sr.suspicious_activity IS NOT NULL;

------------------------------------------------------
-- Step 6: Closing the Net
-- The marina was quiet, but Sunset’s guest list wasn’t.
-- Cross-referencing the suspicious hotel visitors with
-- The confessions' file finally gives us our killer.
------------------------------------------------------
WITH hotel_visitor_interview AS (
    SELECT DISTINCT sr.person_id, p.name, sr.suspicious_activity, i.transcript 
    FROM surveillance_records sr
    INNER JOIN hotel_checkins hc ON sr.hotel_checkin_id = hc.id
    INNER JOIN person p ON sr.person_id = p.id
    INNER JOIN interviews i ON sr.person_id = i.person_id
    WHERE hc.check_in_date = 19860813
      AND LOWER(hc.hotel_name) LIKE '%sunset%'
      AND sr.suspicious_activity IS NOT NULL
)
SELECT DISTINCT hv.person_id, hv.name, c.confession
FROM hotel_visitor_interview hv
INNER JOIN confessions c ON hv.person_id = c.person_id;

-- 📝 Case Closed:
-- Among the Sunset guests, one finally broke.
-- The confession sealed their fate —
-- The Miami Marina Murder was solved.
-- The killer: Thomas Brown.

