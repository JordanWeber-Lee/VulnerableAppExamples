CREATE USER LOYALTY_ADMIN IDENTIFIED BY exposedPassword
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON users;

CREATE USER LOYALTY_APP IDENTIFIED BY exposedPassword
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON users;

CREATE TABLE loyalty_member (
    member_id     NUMBER        NOT NULL,
    member_name   VARCHAR2(100) NOT NULL,
    email         VARCHAR2(200) NOT NULL,
    password      VARCHAR2(200) NOT NULL,
    points        NUMBER        DEFAULT 0,
    enrolled_date DATE          DEFAULT SYSDATE,
    CONSTRAINT pk_loyalty_member PRIMARY KEY (member_id)
);

CREATE TABLE loyalty_tier (
    tier_id     NUMBER        NOT NULL,
    tier_name   VARCHAR2(50)  NOT NULL,
    min_points  NUMBER        NOT NULL,
    CONSTRAINT pk_loyalty_tier PRIMARY KEY (tier_id)
);

CREATE TABLE loyalty_activity (
    activity_id   NUMBER        NOT NULL,
    member_id     NUMBER        NOT NULL,
    member_name   VARCHAR2(100),
    activity_desc VARCHAR2(400),
    activity_date DATE          DEFAULT SYSDATE,
    CONSTRAINT pk_loyalty_activity PRIMARY KEY (activity_id)
);

INSERT INTO loyalty_member (member_id, member_name, email, password, points)
VALUES (1001, 'Ada Reynolds', 'ada.reynolds@example.com', 'exposedPassword', 250);

INSERT INTO loyalty_member (member_id, member_name, email, password, points)
VALUES (1002, 'Marcus Bell', 'marcus.bell@example.com', 'exposedPassword', 4200);

INSERT INTO loyalty_member (member_id, member_name, email, password, points)
VALUES (1003, 'Priya Nair', 'priya.nair@example.com', 'exposedPassword', 900);

INSERT INTO loyalty_tier (tier_id, tier_name, min_points)
VALUES (1, 'SILVER', 0);

INSERT INTO loyalty_tier (tier_id, tier_name, min_points)
VALUES (2, 'GOLD', 1000);

INSERT INTO loyalty_tier (tier_id, tier_name, min_points)
VALUES (3, 'PLATINUM', 5000);

INSERT INTO loyalty_activity (activity_id, member_id, member_name, activity_desc)
VALUES (1, 1001, 'Ada Reynolds', 'Points redeemed for gift card');

INSERT INTO loyalty_activity (activity_id, member_id, member_name, activity_desc)
VALUES (2, 1002, 'Marcus Bell', 'Tier upgrade to GOLD');

COMMIT;
