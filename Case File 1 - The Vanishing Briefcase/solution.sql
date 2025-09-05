-- 🕵️ SQL Noir - Case File 1: The Vanishing Briefcase
-- Crime Type: Theft
-- Location: Blue Note Lounge
-- Objective: Identify the suspect who stole the briefcase

------------------------------------------------------
-- Step 1: Crime Scene Report
------------------------------------------------------
SELECT *
FROM crime_scene
WHERE type = 'theft'
  AND location = 'Blue Note Lounge';

------------------------------------------------------
-- Step 2: Narrow Down Suspects
-- Clue: Man in a trench coat with a scar on his left cheek
------------------------------------------------------
SELECT *
FROM suspects
WHERE attire = 'trench coat'
  AND scar = 'left cheek';

------------------------------------------------------
-- Step 3: Cross-Check Interviews
-- Verify alibi and admissions
------------------------------------------------------
SELECT *
FROM interviews
WHERE suspect_id IN (3, 183);

------------------------------------------------------
-- Step 4: Confirm the Culprit
-- Suspect_id = 183 confessed
------------------------------------------------------
SELECT *
FROM suspects
WHERE id = 183;
