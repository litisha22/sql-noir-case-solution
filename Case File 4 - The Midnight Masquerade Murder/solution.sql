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

-- ------------------------------------------------------
-- Step 3: The Guest List Emerges
-- The door swings open on Room 707 at The Grand Regency.
-- Names step into the light—guests no longer shadows behind masks.
-- Time to see who’s behind this room number, and what secrets they carry.
------------------------------------------------------
SELECT hc.id, hc.person_id, p.name, hc.hotel_name, hc.room_number
FROM hotel_checkins hc
INNER JOIN person p ON p.id = hc.person_id
WHERE LOWER(hc.hotel_name) LIKE '%the grand regency%'
  AND hc.room_number = 707;

-- ------------------------------------------------------
-- Step 4: Surveillance and Phone Logs
-- The midnight whispers grow louder—shadowy figures caught on camera,
-- and phone lines buzzing with secrets frozen in time.
-- Surveillance notes and phone records from The Grand Regency,
-- Room 707, the night before the masquerade.
-- Let’s eavesdrop on what was really said and seen.
------------------------------------------------------
SELECT hc.id, hc.person_id, p.name, sr.note as surveillance_note, pr.note as phone_note
FROM surveillance_records sr
INNER JOIN hotel_checkins hc ON sr.hotel_checkin_id = hc.id
INNER JOIN person p ON p.id = hc.person_id
INNER JOIN phone_records pr ON (p.id = pr.caller_id OR p.id = pr.recipient_id)
WHERE LOWER(hc.hotel_name) LIKE '%the grand regency%'
  AND hc.room_number = 707
  AND pr.call_date = 19871030;

-- One voice presses the questions hard:
-- “Did you kill him?”
-- “Why did you kill him, bro? You should have left the carpenter to his craft.”
-- The weight of these questions hangs heavy in the silence.

-- ------------------------------------------------------
-- Step 5: Following the Call to a Confession
-- The line rings through The Grand Regency,
-- leading us to the listener—and their final words.
-- We've traced the recipient of that pointed call,
-- now to see if their confession breaks the silence.
------------------------------------------------------
WITH phone_logs AS (
    SELECT hc.person_id, p.name, p.occupation, pr.recipient_id
    FROM surveillance_records sr
    INNER JOIN hotel_checkins hc ON sr.hotel_checkin_id = hc.id
    INNER JOIN person p ON p.id = hc.person_id
    INNER JOIN phone_records pr ON p.id = pr.caller_id
    WHERE LOWER(hc.hotel_name) LIKE '%the grand regency%'
      AND hc.room_number = 707
      AND pr.call_date = 19871030
)
SELECT p.id, p.name, p.occupation, fi.confession
FROM person p
INNER JOIN phone_logs pl ON p.id = pl.recipient_id
INNER JOIN final_interviews fi ON p.id = fi.person_id;

-- The first interview yields a twist:
-- The recipient denies the deed but drops a vital hint—
-- The true murderer is a carpenter behind the wheel of a Lamborghini.
-- The trail sharpens; the game is far from over.

-- ------------------------------------------------------
-- Step 6: The Carpenter’s Ride
-- The hint points straight to the driver of the fast machine—
-- A carpenter with a Lamborghini, cruising under suspicion’s glare.
-- Let’s shine the spotlight on this flashy suspect.
------------------------------------------------------
SELECT p.*
FROM person p
INNER JOIN vehicle_registry vr ON p.id = vr.person_id
WHERE occupation = 'Carpenter'
  AND car_make = 'Lamborghini';

-- ------------------------------------------------------
-- Step 7: The Smoking Gun - Final Confession
-- The carpenter behind the wheel can no longer hide.
-- Their confession spills the truth onto the cold floor.
------------------------------------------------------
SELECT p.name, p.occupation, fi.confession
FROM person p
INNER JOIN vehicle_registry vr ON p.id = vr.person_id
INNER JOIN final_interviews fi ON p.id = fi.person_id
WHERE occupation = 'Carpenter'
  AND car_make = 'Lamborghini';

-- 📝 Case Closed:
-- Behind the mask, the truth stood plain.
-- Marco Santos, caught in the spotlight,
-- confessed and brought the masquerade to its end.
-- The Midnight Masquerade Murder is no more.
