INSERT INTO hotel_bookings

SELECT

uuid_generate_v4(),

uuid_generate_v4(),

'Hotel-'||g,

CASE

WHEN g%4=0 THEN 'delhi'

WHEN g%4=1 THEN 'noida'

WHEN g%4=2 THEN 'gurugram'

ELSE 'bangalore'

END,

CURRENT_DATE,

CURRENT_DATE+2,

(random()*10000)::numeric,

CASE

WHEN g%3=0 THEN 'BOOKED'

WHEN g%3=1 THEN 'CANCELLED'

ELSE 'COMPLETED'

END,

NOW()-((random()*30)::int||' days')::interval

FROM generate_series(1,100) g;
