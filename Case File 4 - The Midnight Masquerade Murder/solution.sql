-- 🎭 SQL Noir - Case File 4: The Midnight Masquerade Murder
-- Crime Type: Homicide
-- Location: Coconut Grove Mansion
-- Date: October 31, 1987

------------------------------------------------------
-- Step 1: Crime Scene Report
-- The clock struck midnight at the Coconut Grove mansion,
-- where the masked ball's laughter was cut short.
-- Leonard Pierce was found dead amidst whispered secrets.
-- Let's bring the crime scene details into the light.
------------------------------------------------------
SELECT id, date, location, description
FROM crime_scene
WHERE date = 19871031
  AND LOWER(location) LIKE '%coconut grove%';

-- 🌑 Under the guise of revelry, the garden hides a grim scene.
-- Witnesses whisper of a hotel booking and phone calls ringing
-- with secrets that won't stay silent.
-- We'll need to delve deeper—hotel check-ins and phone records might sing.

-- ------------------------------------------------------
-- Step 2: Witness Statements
-- The shadows deepen with whispers from the masked guests.
-- Time to unravel the clues hidden in witness statements.
------------------------------------------------------
SELECT ws.crime_scene_id, ws.witness_id, ws.clue
FROM witness_statements ws
INNER JOIN crime_scene cs ON ws.crime_scene_id = cs.id
WHERE date = 19871031
  AND LOWER(location) LIKE '%coconut grove%';

-- 🕯️ The whispers grow louder in the dim light.
-- Witnesses spill the secrets:
--     • A booking at The Grand Regency lingers like smoke in the air.
--     • Room 707, reserved just yesterday, holds a shadowed guest.
-- The trail leads us there—time to unmask who checked in under the veil of night.
