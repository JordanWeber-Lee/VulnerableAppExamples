CREATE OR REPLACE PACKAGE LOYALTY_PKG AS

    g_program_name CONSTANT VARCHAR2(30) := 'REWARDS';

    TYPE member_rec IS RECORD (
        member_id     NUMBER,
        member_name   VARCHAR2(100),
        email         VARCHAR2(200),
        points        NUMBER
    );

    TYPE member_cur IS REF CURSOR RETURN member_rec;

    FUNCTION get_member_points (
        p_member_id IN NUMBER
    ) RETURN NUMBER;

    PROCEDURE find_member_by_name (
        p_name   IN  VARCHAR2,
        p_result OUT SYS_REFCURSOR
    );

    PROCEDURE search_tier (
        p_tier_name IN  VARCHAR2,
        p_count     OUT NUMBER
    );

    PROCEDURE add_points (
        p_member_id IN NUMBER,
        p_amount    IN NUMBER
    );

    PROCEDURE authenticate_member (
        p_email    IN  VARCHAR2,
        p_password IN  VARCHAR2,
        p_ok       OUT NUMBER
    );

    PROCEDURE export_member_activity (
        p_member_id IN NUMBER,
        p_filename  IN VARCHAR2
    );

    PROCEDURE run_member_report (
        p_where_clause IN VARCHAR2
    ) AUTHID CURRENT_USER;

END LOYALTY_PKG;
/
