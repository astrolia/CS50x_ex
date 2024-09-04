-- Keep a log of any SQL queries you execute as you solve the mystery.

--Search in crime_scene_reports to find more details
SELECT description FROM crime_scene_reports
WHERE year = 2023 AND month = 7 AND day = 28 AND street = 'Humphrey Street';

-- Suspect took place at 10:15 at the bakery, maybe the suspect used the littering(leaved place at 16:36) to escape


--Search on bakery_security_logs to find more details

-- entrace at 10:14, license_plate = 13FNH73(maybe suspect)
SELECT activity,hour,minute,license_plate FROM bakery_security_logs
WHERE year = 2023 AND month = 7 AND day = 28 AND hour = 10;

--littering exit at 16:38, license_plate = 4468KVT
SELECT activity,hour,minute,license_plate FROM bakery_security_logs
WHERE year = 2023 AND month = 7 AND day = 28 AND hour = 16;


--search on people table for license plate match
SELECT name, phone_number, passport_number, license_plate FROM people
WHERE license_plate = '13FNH73' OR license_plate = '4468KVT';

-- 13FNH73: Sophia, num:(027) 555-1068 pass:3642612721
-- 4468KVT : John, num: (016) 555-9166 pass: 8174538026

--search on interviews to find more details about that day
SELECT name, transcript FROM interviews
WHERE year = 2023 AND month = 7 AND day = 28;

-------------------------------------------------------

--| Ruth    | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away.
--If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.

--| Eugene  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery,
--I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.

--| Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call,
--I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
--The thief then asked the person on the other end of the phone to purchase the flight ticket.

------------------------------------------------

--Checking again bakery security logs, to find thef's car license plate
SELECT p.name,activity, bakery_security_logs.license_plate, minute FROM bakery_security_logs
JOIN people p ON p.license_plate = bakery_security_logs.license_plate
WHERE year = 2023 AND month = 7 AND day = 28 AND hour = 10;

-- 10:23: 322W7JE // 0NTHK55
--10:35: 1106N58


-- Search atm transaction that match with the suspect
SELECT id,transaction_type, account_number, amount FROM atm_transactions
WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street';

--+------------------+----------------+--------+
--| transaction_type | account_number | amount |
--+------------------+----------------+--------+
--| withdraw         | 28500762       | 48     |
--| withdraw         | 28296815       | 20     |
--| withdraw         | 76054385       | 60     |
--| withdraw         | 49610011       | 50     |
--| withdraw         | 16153065       | 80     |
--| deposit          | 86363979       | 10     |
--| withdraw         | 25506511       | 20     |
--| withdraw         | 81061156       | 30     |
--| withdraw         | 26013199       | 35     |
--+------------------+----------------+--------+

-- search on people to find the name of the owner of the car

SELECT name, phone_number, passport_number, license_plate FROM people
WHERE license_plate = '322W7JE' OR license_plate = '0NTHK55';

--+--------+----------------+-----------------+
--|  name  |  phone_number  | passport_number |
--+--------+----------------+-----------------+
--| Diana  | (770) 555-1861 | 3592750733      | 322
--| Kelsey | (499) 555-9472 | 8294398571      | ONT
--+--------+----------------+-----------------+


-- crossing tables to find matches
SELECT p.name, p.phone_number, p.passport_number, p.license_plate, bank_accounts.account_number FROM bank_accounts
JOIN people p ON p.id = bank_accounts.person_id
WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street');

--+---------+----------------+-----------------+---------------+----------------+
--|  name   |  phone_number  | passport_number | license_plate | account_number |
--+---------+----------------+-----------------+---------------+----------------+
--| Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       |
--| Kaelyn  | (098) 555-1164 | 8304650265      | I449449       | 86363979       |
--| Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       |
--| Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       | 16153065       |
--| Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       | 28296815       |
--| Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511       |
--| Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       |
--| Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | 76054385       |
--| Benista | (338) 555-6650 | 9586786673      | 8X428L0       | 81061156       |
--+---------+----------------+-----------------+---------------+----------------+


--suspects that whitdrwan money and exited parking lot around 10:25
--| Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199

--| Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511

--| Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       |

--| Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | 76054385       |


-- cheking phone calls

SELECT caller, receiver, duration FROM phone_calls
WHERE year = 2023 AND month = 7 AND day = 28 AND duration <= 60;

--Taylor: | (286) 555-6063 | (676) 555-6554 | 43       |
--Diana: | (770) 555-1861 | (725) 555-3243 | 49       |

--cheking the receivers

SELECT name, phone_number, passport_number, ba.account_number FROM people
JOIN bank_accounts ba ON ba.person_id = people.id
WHERE phone_number = '(725) 555-3243' OR phone_number = '(676) 555-6554';

--+--------+----------------+-----------------+
--|  name  |  phone_number  | passport_number |
--+--------+----------------+-----------------+
--| James  | (676) 555-6554 | 2438825627      |
--| Philip | (725) 555-3243 | 3391710505      |
--+--------+----------------+-----------------+

--+--------+----------------+-----------------+----------------+
--|  name  |  phone_number  | passport_number | account_number |
--+--------+----------------+-----------------+----------------+
--| Philip | (725) 555-3243 | 3391710505      | 47746428       |
--+--------+----------------+-----------------+----------------+


--finding airport

SELECT flights.id, destination_airport_id, hour, minute FROM flights
JOIN airports ai ON flights.origin_airport_id = ai.id
WHERE flights.origin_airport_id IN (SELECT id FROM airports
WHERE city = 'Fiftyville') AND year = 2023 AND month = 7 AND day = 29;

SELECT abbreviation, full_name, city FROM airports
WHERE id = 4;

--+------------------------+------+--------+
--| destination_airport_id | hour | minute |
--+------------------------+------+--------+
--| 6                      | 16   | 0      | | BOS          | Logan International Airport | Boston |
--| 11                     | 12   | 15     |
--| 4                      | 8    | 20     | | LGA          | LaGuardia Airport | New York City |
--| 1                      | 9    | 30     |
--| 9                      | 15   | 20     |
--+------------------------+------+--------+

--seaching the suspects between the passagers crossing all matches till now

SELECT p.name, p.passport_number, f.hour, f.minute, ba.hour, ba.minute, ba.activity, p.phone_number FROM passengers
JOIN people p ON p.passport_number = passengers.passport_number
JOIN flights f ON f.id = passengers.flight_id
JOIN bakery_security_logs ba ON p.license_plate = ba.license_plate
WHERE passengers.flight_id IN (SELECT flights.id FROM flights
JOIN airports ai ON flights.origin_airport_id = ai.id
WHERE flights.origin_airport_id IN (SELECT id FROM airports
WHERE city = 'Fiftyville') AND year = 2023 AND month = 7 AND day = 29) AND p.passport_number IN (SELECT p.passport_number FROM bank_accounts
JOIN people p ON p.id = bank_accounts.person_id
WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions
WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw')) AND
p.license_plate IN (SELECT license_plate FROM bakery_security_logs
WHERE year = 2023 AND month = 7 AND day = 28 AND hour = 10) AND
p.phone_number IN (SELECT caller FROM phone_calls
WHERE year = 2023 AND month = 7 AND day = 28 AND duration <= 60);

--+--------+-----------------+------+--------+------+--------+----------+----------------+
--|  name  | passport_number | hour | minute | hour | minute | activity |  phone_number  |
--+--------+-----------------+------+--------+------+--------+----------+----------------+
--| Diana  | 3592750733      | 16   | 0      | 8    | 36     | entrance | (770) 555-1861 |
--| Diana  | 3592750733      | 16   | 0      | 10   | 23     | exit     | (770) 555-1861 |
--| Bruce  | 5773159633      | 8    | 20     | 8    | 23     | entrance | (367) 555-5533 |
--| Bruce  | 5773159633      | 8    | 20     | 10   | 18     | exit     | (367) 555-5533 |
--| Taylor | 1988161715      | 8    | 20     | 8    | 34     | entrance | (286) 555-6063 |
--| Taylor | 1988161715      | 8    | 20     | 10   | 35     | exit     | (286) 555-6063 |
--+--------+-----------------+------+--------+------+--------+----------+----------------+

-- looking for the acomplece
SELECT name FROM people
WHERE phone_number = (SELECT receiver FROM phone_calls
WHERE year = 2023 AND month = 7 AND day = 28 AND duration <= 60 AND caller = '(367) 555-5533');

--Robin

--Conclusion
-- Bruce fits in everything till now even if the exit time looks like too early
--Exited from the bakery 10:18, called Robin for less then 60s and take the earliest flight
--The flight went to New York City
