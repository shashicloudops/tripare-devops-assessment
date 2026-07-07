CREATE INDEX idx_booking_city_created

ON hotel_bookings(city,created_at);

CREATE INDEX idx_booking_org_status

ON hotel_bookings(org_id,status);
