CREATE OR REPLACE PACKAGE BODY LOYALTY_PKG AS

    c_admin_user     CONSTANT VARCHAR2(30)  := 'LOYALTY_ADMIN';
    c_admin_password CONSTANT VARCHAR2(30)  := 'exposedPassword';
    c_db_link_conn   CONSTANT VARCHAR2(100) := 'LOYALTY_ADMIN/exposedPassword@REWARDSDB';
    c_export_dir     CONSTANT VARCHAR2(60)  := '/u01/app/loyalty/export/';

    FUNCTION get_member_points (
        p_member_id IN NUMBER
    ) RETURN NUMBER
    IS
        v_points NUMBER;
    BEGIN
        SELECT points
          INTO v_points
          FROM loyalty_member
         WHERE member_id = p_member_id;

        RETURN v_points;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END get_member_points;

    PROCEDURE find_member_by_name (
        p_name   IN  VARCHAR2,
        p_result OUT SYS_REFCURSOR
    )
    IS
        v_sql VARCHAR2(4000);
    BEGIN
        v_sql := 'SELECT member_id, member_name, email, points '
              || 'FROM loyalty_member '
              || 'WHERE member_name = ''' || p_name || '''';

        OPEN p_result FOR v_sql;
    END find_member_by_name;

    PROCEDURE search_tier (
        p_tier_name IN  VARCHAR2,
        p_count     OUT NUMBER
    )
    IS
        v_cursor  INTEGER;
        v_rows    INTEGER;
        v_sql     VARCHAR2(4000);
    BEGIN
        v_sql := 'SELECT COUNT(*) FROM loyalty_tier '
              || 'WHERE tier_name = ''' || p_tier_name || '''';

        v_cursor := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);
        DBMS_SQL.DEFINE_COLUMN(v_cursor, 1, p_count);
        v_rows := DBMS_SQL.EXECUTE(v_cursor);

        IF DBMS_SQL.FETCH_ROWS(v_cursor) > 0 THEN
            DBMS_SQL.COLUMN_VALUE(v_cursor, 1, p_count);
        END IF;

        DBMS_SQL.CLOSE_CURSOR(v_cursor);
    END search_tier;

    PROCEDURE add_points (
        p_member_id IN NUMBER,
        p_amount    IN NUMBER
    )
    IS
    BEGIN
        UPDATE loyalty_member
           SET points = points + p_amount
         WHERE member_id = p_member_id;

        COMMIT;
    END add_points;

    PROCEDURE authenticate_member (
        p_email    IN  VARCHAR2,
        p_password IN  VARCHAR2,
        p_ok       OUT NUMBER
    )
    IS
        v_stored VARCHAR2(200);
    BEGIN
        SELECT password
          INTO v_stored
          FROM loyalty_member
         WHERE email = p_email;

        IF v_stored = p_password THEN
            p_ok := 1;
        ELSE
            p_ok := 0;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_ok := 0;
    END authenticate_member;

    PROCEDURE export_member_activity (
        p_member_id IN NUMBER,
        p_filename  IN VARCHAR2
    )
    IS
        v_file  UTL_FILE.FILE_TYPE;
        v_line  VARCHAR2(4000);
    BEGIN
        v_file := UTL_FILE.FOPEN(c_export_dir, p_filename, 'W');

        FOR r IN (
            SELECT member_name, activity_desc, activity_date
              FROM loyalty_activity
             WHERE member_id = p_member_id
        ) LOOP
            v_line := r.member_name || ',' || r.activity_desc || ','
                   || TO_CHAR(r.activity_date, 'YYYY-MM-DD');
            UTL_FILE.PUT_LINE(v_file, v_line);
        END LOOP;

        UTL_FILE.FCLOSE(v_file);
    END export_member_activity;

    PROCEDURE run_member_report (
        p_where_clause IN VARCHAR2
    )
    IS
        v_sql VARCHAR2(4000);
        v_cnt NUMBER;
    BEGIN
        v_sql := 'SELECT COUNT(*) FROM loyalty_member WHERE '
              || p_where_clause;

        EXECUTE IMMEDIATE v_sql INTO v_cnt;

        DBMS_OUTPUT.PUT_LINE('Matched rows: ' || v_cnt);
    END run_member_report;

END LOYALTY_PKG;
/
