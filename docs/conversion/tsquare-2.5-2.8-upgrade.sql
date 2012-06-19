-- --------------------------------------------------------------------------------------------------------------------------------------
-- Reports Tool Moved
-- --------------------------------------------------------------------------------------------------------------------------------------

-- reports tool registration has changed... SAK-13643
UPDATE SAKAI_SITE_TOOL SET REGISTRATION='sakai.reports' WHERE REGISTRATION='osp.reports';

-- SAK-11130 Localization breaks default folders in Messages because of internationalization bug
update MFR_TOPIC_T
set TITLE='pvt_received'
where TITLE in (
  'Received' /* en */, '\u0645\u0633\u062a\u0644\u0645' /* ar */,
  'Rebut' /* ca */, 'Recibidos' /* es */, 'Re\u00e7u' /* fr_CA */,
  '\u53d7\u4fe1\u3057\u307e\u3057\u305f' /* ja */, 'Ontvangen' /* nl */,
  'Recebidas' /* pt_BR */, 'Recebidas' /* pt_PT */,
  'Mottagna' /* sv */) and
    TYPE_UUID = (select uuid from CMN_TYPE_T where KEYWORD = 'privateForums');

update MFR_TOPIC_T
set TITLE='pvt_sent'
where TITLE in (
  'Sent' /* en */, '\u0623\u0631\u0633\u0644' /* ar */,
  'Enviat' /* ca */, 'Enviados' /* es */, 'Envoy\u00e9' /* fr_CA */,
  '\u9001\u4fe1\u3057\u307e\u3057\u305f' /* ja */, 'Verzonden' /* nl */,
  'Enviadas' /* pt_BR  */, 'Enviada' /* pt_PT  */,
  'Skickade' /* sv */) and
    TYPE_UUID = (select uuid from CMN_TYPE_T where KEYWORD = 'privateForums');

update MFR_TOPIC_T
set TITLE='pvt_deleted'
where TITLE in (
  'Deleted' /* en */, '\u062d\u0630\u0641' /* ar */,
  'Suprimit' /* ca */, 'Borrados' /* es */, 'Supprim\u00e9' /* fr_CA */,
  '\u524a\u9664\u3057\u307e\u3057\u305f' /* ja */, 'Verwijderd' /* nl */,
  'Apagadas' /* pt_BR */, 'Eliminadas' /* pt_PT */,
  'Borttagna' /* sv */) and
    TYPE_UUID = (select uuid from CMN_TYPE_T where KEYWORD = 'privateForums');

update MFR_TOPIC_T
set TITLE='pvt_drafts'
where TITLE in (
  'Drafts' /*en */, '\u0645\u0634\u0631\u0648\u0639' /* ar */,
  'Esborrany' /* ca */, 'Preliminar' /* es */, 'Brouillon' /* fr_CA */,
  '\u4e0b\u66f8\u304d' /* ja */, 'Concept' /* nl */,
  'Rascunho' /* pt_BR */, 'Rascunho' /* pt_PT */,
  'Utkast' /* sv */) and
    TYPE_UUID = (select uuid from CMN_TYPE_T where KEYWORD = 'privateForums');



-- ---------------------------------------------------------------------------
-- Fix http://bugs.sakaiproject.org/jira/browse/SAK-13842
-- 
-- Remove discussions and recent discussions from mercury and !worksite
-- 
-- Sites which still run discussions from contrib - can simply patch
-- this so it never runs - either by commenting out all this SQL
-- or by removing the call to this script in SiteService.
-- ---------------------------------------------------------------------------

-- Undo the hard-coded inserts

-- INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-130', 'mercury-100', 
-- 'mercury', 'sakai.synoptic.discussion', 3, 'Recent Discussion Items', NULL );

DELETE FROM SAKAI_SITE_TOOL WHERE 
       TOOL_ID              = 'mercury-130' AND
       PAGE_ID              = 'mercury-100' AND 
       SITE_ID              = 'mercury' AND 
       REGISTRATION         = 'sakai.synoptic.discussion';

-- INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-510', 'category', 'false' );

DELETE FROM SAKAI_SITE_TOOL_PROPERTY WHERE
       SITE_ID = 'mercury' and
       TOOL_ID = 'mercury-510';

-- sakai_site.sql:INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-510', 'mercury-500', 
-- 'mercury', 'sakai.discussion', 1, 'Discussion', NULL );

DELETE FROM SAKAI_SITE_TOOL WHERE 
       TOOL_ID              = 'mercury-510' AND
       PAGE_ID              = 'mercury-500' AND 
       SITE_ID              = 'mercury' AND 
       REGISTRATION         = 'sakai.discussion';

-- INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-130', '!worksite-100', 
-- '!worksite', 'sakai.synoptic.discussion', 3, 'Recent Discussion Items', NULL );

DELETE FROM SAKAI_SITE_TOOL WHERE 
       TOOL_ID              = '!worksite-130' AND
       PAGE_ID              = '!worksite-100' AND 
       SITE_ID              = '!worksite' AND 
       REGISTRATION         = 'sakai.synoptic.discussion';

-- INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-510', 'category', 'false' );

DELETE FROM SAKAI_SITE_TOOL_PROPERTY WHERE
       SITE_ID = '!worksite' and
       TOOL_ID = '!worksite-510';

-- sakai_site.sql:INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-510', '!worksite-500', 
--  '!worksite', 'sakai.discussion', 1, 'Discussion', NULL );

DELETE FROM SAKAI_SITE_TOOL WHERE 
       TOOL_ID              = '!worksite-510' AND
       PAGE_ID              = '!worksite-500' AND 
       SITE_ID              = '!worksite' AND 
       REGISTRATION         = 'sakai.discussion';
-- SAK-13474 Increase length of announcement channel to 255 chars
ALTER TABLE announcement_channel MODIFY (CHANNEL_ID VARCHAR2(255));
ALTER TABLE announcement_message MODIFY (CHANNEL_ID VARCHAR2(255)); 
-- There was no conversion associated with the 2.5.5 release and thus, no 2_5_4-2_5_5 conversion script

-- SAK-14482 Patch mercury and !workspace sites to use sakai.assignment.grades tool
-- update Mercury site
UPDATE SAKAI_SITE_TOOL SET REGISTRATION='sakai.assignment.grades' WHERE REGISTRATION='sakai.assignment' AND SITE_ID='mercury';

-- update !worksite site
UPDATE SAKAI_SITE_TOOL SET REGISTRATION='sakai.assignment.grades' WHERE REGISTRATION='sakai.assignment' AND SITE_ID='!worksite';
-- This is the Oracle Sakai 2.5.4 -> 2.6.0 conversion script
-- --------------------------------------------------------------------------------------------------------------------------------------
-- 
-- use this to convert a Sakai database from 2.5.3 to 2.6.0.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
-- The 2.5.0 - 2.5.2 script can be located at https://source.sakaiproject.org/svn/reference/tags/sakai_2-5-2/docs/conversion/sakai_2_5_0-2_5_2_oracle_conversion.sql
-- * Note that there was not a 2.5.1 release due to critical issue identified just prior to release 
-- The 2.5.2 - 2.5.3 script can be located at https://source.sakaiproject.org/svn/reference/tags/sakai_2-5-3/docs/conversion/sakai_2_5_2-2_5_3_oracle_conversion.sql
-- The 2.5.3 - 2.5.4 script can be located at https://source.sakaiproject.org/svn/reference/tags/sakai-2.5.4/docs/conversion/sakai_2_5_3-2_5_4_oracle_conversion.sql
--
-- --------------------------------------------------------------------------------------------------------------------------------------

-- SAK-13345 introduced a performance optimization to search. To see if you need this index run this command:
-- select INDEX_NAME FROM USER_INDEXES WHERE INDEX_NAME='ISEARCHBUILDERITEM_STA';
-- If there is 1 row returned then you should run the following 2 queries
-- create index ISEARCHBUILDERITEM_STA_ACT on searchbuilderitem (SEARCHSTATE,SEARCHACTION);
-- drop index ISEARCHBUILDERITEM_STA; 


-- SAK-12527 Changes to Chat Room options do not work consistently

-- add column timeParam and numberParam 
alter table CHAT2_CHANNEL add timeParam int;
alter table CHAT2_CHANNEL add numberParam int;

UPDATE CHAT2_CHANNEL
SET numberParam = Case When filterParam = 0 or filterType <> 'SelectByNumber' Then 10 Else filterParam End,
timeParam = Case When filterparam = 0 or filterType <> 'SelectMessagesByTime' Then 3 Else filterParam End;

alter table CHAT2_CHANNEL modify (timeParam int not null);
alter table CHAT2_CHANNEL modify (numberParam int not null);

-- SAK-12176 Messages-Send cc to recipients' email address(es)

-- add column sendEmailOut to table MFR_AREA_T
alter table MFR_AREA_T add (SENDEMAILOUT NUMBER(1,0));
update MFR_AREA_T set SENDEMAILOUT=1 where SENDEMAILOUT is NULL;
alter table MFR_AREA_T modify (SENDEMAILOUT NUMBER(1,0) not null);

-- new msg.emailout permission 

INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'msg.emailout');

-- maintain role
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'msg.emailout'));

-- Instructor role
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'msg.emailout'));

-- --------------------------------------------------------------------------------------------------------------------------------------
-- backfill new msg.emailout permissions into existing realms
-- --------------------------------------------------------------------------------------------------------------------------------------

-- for each realm that has a role matching something in this table, we will add to that role the function from this table
CREATE TABLE PERMISSIONS_SRC_TEMP (ROLE_NAME VARCHAR2(99), FUNCTION_NAME VARCHAR2(99));

INSERT INTO PERMISSIONS_SRC_TEMP values ('maintain','msg.emailout');
INSERT INTO PERMISSIONS_SRC_TEMP values ('Instructor','msg.emailout');
INSERT INTO PERMISSIONS_SRC_TEMP values ('CIG Coordinator','msg.emailout');
INSERT INTO PERMISSIONS_SRC_TEMP values ('Program Coordinator','msg.emailout');
INSERT INTO PERMISSIONS_SRC_TEMP values ('Program Admin','msg.emailout');

-- lookup the role and function numbers
CREATE TABLE PERMISSIONS_TEMP (ROLE_KEY INTEGER, FUNCTION_KEY INTEGER);
INSERT INTO PERMISSIONS_TEMP (ROLE_KEY, FUNCTION_KEY)
SELECT SRR.ROLE_KEY, SRF.FUNCTION_KEY
from PERMISSIONS_SRC_TEMP TMPSRC
JOIN SAKAI_REALM_ROLE SRR ON (TMPSRC.ROLE_NAME = SRR.ROLE_NAME)
JOIN SAKAI_REALM_FUNCTION SRF ON (TMPSRC.FUNCTION_NAME = SRF.FUNCTION_NAME);

-- insert the new functions into the roles of any existing realm that has the role (don't convert the "!site.helper")
INSERT INTO SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
SELECT
    SRRFD.REALM_KEY, SRRFD.ROLE_KEY, TMP.FUNCTION_KEY
FROM
    (SELECT DISTINCT SRRF.REALM_KEY, SRRF.ROLE_KEY FROM SAKAI_REALM_RL_FN SRRF) SRRFD
    JOIN PERMISSIONS_TEMP TMP ON (SRRFD.ROLE_KEY = TMP.ROLE_KEY)
    JOIN SAKAI_REALM SR ON (SRRFD.REALM_KEY = SR.REALM_KEY)
    WHERE SR.REALM_ID != '!site.helper'
    AND NOT EXISTS (
        SELECT 1
            FROM SAKAI_REALM_RL_FN SRRFI
            WHERE SRRFI.REALM_KEY=SRRFD.REALM_KEY AND SRRFI.ROLE_KEY=SRRFD.ROLE_KEY AND SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY
    );

-- clean up the temp tables
DROP TABLE PERMISSIONS_TEMP;
DROP TABLE PERMISSIONS_SRC_TEMP;

-- SAK-12777 Create unique constraint on CALENDAR_EVENT EVENT_ID
CREATE UNIQUE INDEX EVENT_INDEX ON CALENDAR_EVENT
(
       EVENT_ID
);

-- SAK-6216 Optional ability to store client hostname (resolved IP) in SAKAI_SESSION
alter table SAKAI_SESSION add SESSION_HOSTNAME varchar2(255) NULL;

-- SAK-10801 Add CONTEXT field to SAKAI_EVENT
alter table SAKAI_EVENT add CONTEXT varchar2(255) NULL;

-- SAK-13310 Poll description field too small
alter table POLL_POLL modify POLL_DETAILS VARCHAR2(4000);

-- SAK-14106
alter table SAM_ITEM_T add DISCOUNT float NULL;
alter table SAM_ANSWER_T add DISCOUNT float NULL;
alter table SAM_PUBLISHEDITEM_T add DISCOUNT float NULL;
alter table SAM_PUBLISHEDANSWER_T add DISCOUNT float NULL;

-- SAK-14291
create index SYLLABUS_ATTACH_ID_I on SAKAI_SYLLABUS_ATTACH (syllabusId);
create index SYLLABUS_DATA_SURRO_I on SAKAI_SYLLABUS_DATA (surrogateKey);

-- Samigo
-- SAK-8432
create index SAM_AG_AGENTID_I on SAM_ASSESSMENTGRADING_T (AGENTID);
-- SAK-14430
ALTER TABLE SAM_ASSESSACCESSCONTROL_T ADD MARKFORREVIEW number(1,0) NULL;
ALTER TABLE SAM_PUBLISHEDACCESSCONTROL_T ADD MARKFORREVIEW number(1,0) NULL;
-- SAK-14472
INSERT INTO SAM_TYPE_T ("TYPEID" ,"AUTHORITY", "DOMAIN", "KEYWORD", "DESCRIPTION", "STATUS", "CREATEDBY", "CREATEDDATE", "LASTMODIFIEDBY", "LASTMODIFIEDDATE")
    VALUES (12 , 'stanford.edu', 'assessment.item', 'Multiple Correct Single Selection', NULL, 1, 1, SYSDATE, 1, SYSDATE);
-- SAK-14474
update sam_assessaccesscontrol_t set autosubmit = 0;
update sam_publishedaccesscontrol_t set autosubmit = 0;
alter table SAM_ASSESSMENTGRADING_T add ISAUTOSUBMITTED number(1, 0) default '0' null;
-- SAK-14430 
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) VALUES
  (sam_assessMetaData_id_s.nextVal, 1, 'markForReview_isInstructorEditable', 'true');
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) VALUES
  (sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment' AND TYPEID='142' AND ISTEMPLATE=1), 'markForReview_isInstructorEditable', 'true');
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) VALUES
  (sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Quiz' AND TYPEID='142' AND ISTEMPLATE=1), 'markForReview_isInstructorEditable', 'true');
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) VALUES
  (sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Problem Set' AND TYPEID='142' AND ISTEMPLATE=1), 'markForReview_isInstructorEditable', 'true');
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) VALUES
  (sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Test' AND TYPEID='142' AND ISTEMPLATE=1), 'markForReview_isInstructorEditable', 'true');
INSERT INTO SAM_ASSESSMETADATA_T (ASSESSMENTMETADATAID, ASSESSMENTID, LABEL, ENTRY) VALUES
  (sam_assessMetaData_id_s.nextVal, (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Timed Test' AND TYPEID='142' AND ISTEMPLATE=1), 'markForReview_isInstructorEditable', 'true');
update SAM_ASSESSACCESSCONTROL_T set MARKFORREVIEW = 1 where ASSESSMENTID = (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TITLE='Formative Assessment' AND TYPEID='142' AND ISTEMPLATE=1);

-- SAK-13646
alter table GB_GRADABLE_OBJECT_T add (IS_EXTRA_CREDIT number(1,0), ASSIGNMENT_WEIGHTING double precision);
alter table GB_CATEGORY_T add (IS_EXTRA_CREDIT number(1,0));
alter table GB_GRADE_RECORD_T add (IS_EXCLUDED_FROM_GRADE number(1,0));

-- SAK-12883, SAK-12582 - Allow control over which academic sessions are
-- considered current; support more than one current academic session
alter table CM_ACADEMIC_SESSION_T add IS_CURRENT number(1,0) default 0 not null;

-- WARNING: This simply emulates the old runtime behavior. It is strongly
-- recommended that you decide which terms should be treated as current
-- and edit this script accordingly!
update CM_ACADEMIC_SESSION_T set IS_CURRENT=1 where SYSDATE >= START_DATE and SYSDATE <= END_DATE;

-- Tables for email template service (new tool - SAK-14573)
    create table EMAIL_TEMPLATE_ITEM (
        ID number(19,0) not null,
        LAST_MODIFIED date not null,
        OWNER varchar2(255) not null,
        SUBJECT clob not null,
        MESSAGE clob not null,
        TEMPLATE_KEY varchar2(255) not null,
        TEMPLATE_LOCALE varchar2(255),
        defaultType varchar2(255),
        primary key (ID)
    );

    create index email_templ_owner on EMAIL_TEMPLATE_ITEM (OWNER);

    create index email_templ_key on EMAIL_TEMPLATE_ITEM (TEMPLATE_KEY);

  create sequence emailtemplate_item_seq;
 -- create sequence hibernate_sequence;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- SAK-7924 - add and backfill new site.roleswap permissions into existing realms and templates
-- --------------------------------------------------------------------------------------------------------------------------------------

-- ---- View Site in a Different Role Backfill --------
-- SAK-7924 -- Adding the new site.roleswap permission as well as backfilling where appropriate
-- roles that can be switched to are defined in sakai.properties with the studentview.roles property

INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'site.roleswap');

-- Add the permission to the templates - this is which roles have permission to access the functionality to switch roles
-- course sites
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'),
(select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'),
(select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.roleswap'));

-- maintain/access sites
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'),
(select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'),
(select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.roleswap'));

-- --------------------------------------------------------------------------------------------------------------------------------------
-- backfill script
-- --------------------------------------------------------------------------------------------------------------------------------------

-- course sites

CREATE TABLE PERMISSIONS_TEMP (ROLE_NAME VARCHAR(99), FUNCTION_NAME VARCHAR(99));
CREATE TABLE PERMISSIONS_TEMP2 (REALM_KEY INTEGER, ROLE_KEY INTEGER, FUNCTION_KEY INTEGER);

INSERT INTO PERMISSIONS_TEMP values ('Instructor','site.roleswap');

INSERT INTO PERMISSIONS_TEMP2 (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
select distinct SAKAI_REALM.REALM_KEY,
SAKAI_REALM_ROLE.ROLE_KEY, SAKAI_REALM_FUNCTION.FUNCTION_KEY
from SAKAI_REALM, SAKAI_REALM_ROLE, PERMISSIONS_TEMP,
SAKAI_REALM_FUNCTION, SAKAI_SITE
where SAKAI_REALM_ROLE.ROLE_NAME = PERMISSIONS_TEMP.ROLE_NAME
AND SAKAI_REALM_FUNCTION.FUNCTION_NAME =
PERMISSIONS_TEMP.FUNCTION_NAME
AND (substr(SAKAI_REALM.REALM_ID, 7,
length(SAKAI_REALM.REALM_ID)) = SAKAI_SITE.SITE_ID)
AND SAKAI_SITE.TYPE='course';

insert into SAKAI_REALM_RL_FN SELECT * FROM PERMISSIONS_TEMP2
tmp WHERE
not exists (
select 1
from SAKAI_REALM_RL_FN SRRFI
where SRRFI.REALM_KEY=tmp.REALM_KEY and SRRFI.ROLE_KEY=tmp.ROLE_KEY and
SRRFI.FUNCTION_KEY=tmp.FUNCTION_KEY
);

DROP TABLE PERMISSIONS_TEMP;
DROP TABLE PERMISSIONS_TEMP2;

-- project sites

CREATE TABLE PERMISSIONS_SRC_TEMP (ROLE_NAME VARCHAR(99), FUNCTION_NAME VARCHAR(99));

INSERT INTO PERMISSIONS_SRC_TEMP values ('maintain','site.roleswap');

-- lookup the role and function numbers
create table PERMISSIONS_TEMP (ROLE_KEY INTEGER, FUNCTION_KEY INTEGER);
insert into PERMISSIONS_TEMP (ROLE_KEY, FUNCTION_KEY)
select SRR.ROLE_KEY, SRF.FUNCTION_KEY
from PERMISSIONS_SRC_TEMP TMPSRC
join SAKAI_REALM_ROLE SRR on (TMPSRC.ROLE_NAME = SRR.ROLE_NAME)
join SAKAI_REALM_FUNCTION SRF on (TMPSRC.FUNCTION_NAME = SRF.FUNCTION_NAME);

-- insert the new functions into the roles of any existing realm that has the role (don't convert the "!site.helper")
insert into SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
select
    SRRFD.REALM_KEY, SRRFD.ROLE_KEY, TMP.FUNCTION_KEY
from
    (select distinct SRRF.REALM_KEY, SRRF.ROLE_KEY from SAKAI_REALM_RL_FN SRRF) SRRFD
    join PERMISSIONS_TEMP TMP on (SRRFD.ROLE_KEY = TMP.ROLE_KEY)
    join SAKAI_REALM SR on (SRRFD.REALM_KEY = SR.REALM_KEY)
    where SR.REALM_ID != '!site.helper'
    and not exists (
        select 1
            from SAKAI_REALM_RL_FN SRRFI
            where SRRFI.REALM_KEY=SRRFD.REALM_KEY and SRRFI.ROLE_KEY=SRRFD.ROLE_KEY and  SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY
    );

-- clean up the temp tables
drop table PERMISSIONS_TEMP;
drop table PERMISSIONS_SRC_TEMP;

-- - Tables added for SAK-12912:Add optional ability to prompt for questions during site creation

    create table SSQ_ANSWER (
        ID varchar2(99) not null,
        ANSWER varchar2(255),
        ANSWER_STRING varchar2(255),
        FILL_IN_BLANK number(1,0),
        ORDER_NUM number(10,0),
        QUESTION_ID varchar2(99),
        primary key (ID)
    );

    create table SSQ_QUESTION (
        ID varchar2(99) not null,
        QUESTION varchar2(255),
        REQUIRED number(1,0),
        MULTIPLE_ANSWERS number(1,0),
        ORDER_NUM number(10,0),
        IS_CURRENT varchar2(255),
        SITETYPE_ID varchar2(99),
        primary key (ID)
    );

    comment on table SSQ_QUESTION is
        'This table stores site setup questions';

    create table SSQ_SITETYPE_QUESTIONS (
        ID varchar2(99) not null,
        SITE_TYPE varchar2(255),
        INSTRUCTION varchar2(255),
        URL varchar2(255),
        URL_LABEL varchar2(255),
        URL_Target varchar2(255),
        primary key (ID)
    );

    create table SSQ_USER_ANSWER (
        ID varchar2(99) not null,
        SITE_ID varchar2(255),
        USER_ID varchar2(255),
        ANSWER_STRING varchar2(255),
        ANSWER_ID varchar2(255),
        QUESTION_ID varchar2(255),
        primary key (ID)
    );

    create index SSQ_ANSWER_QUESTION_I on SSQ_ANSWER (QUESTION_ID);

    alter table SSQ_ANSWER 
        add constraint FK390C0DCC6B21AFB4 
        foreign key (QUESTION_ID) 
        references SSQ_QUESTION;

    create index SSQ_QUESTION_SITETYPE_I on SSQ_QUESTION (SITETYPE_ID);

    alter table SSQ_QUESTION 
        add constraint FKFE88BA7443AD4C69 
        foreign key (SITETYPE_ID) 
        references SSQ_SITETYPE_QUESTIONS;

-- --- SAK-15040 site.viewRoster is a newly added permission

INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.user'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.viewRoster'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.viewRoster'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!site.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.viewRoster'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.viewRoster'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!group.template.course'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'Instructor'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.viewRoster'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '/site/mercury'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = 'maintain'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.viewRoster'));

-- --------------------------------------------------------------------------------------------------------------------------------------
-- backfill new site.viewRoster permissions into existing realms
-- --------------------------------------------------------------------------------------------------------------------------------------

-- for each realm that has a role matching something in this table, we will add to that role the function from this table
CREATE TABLE PERMISSIONS_SRC_TEMP (ROLE_NAME VARCHAR2(99), FUNCTION_NAME VARCHAR2(99));

INSERT INTO PERMISSIONS_SRC_TEMP values ('maintain','site.viewRoster');
INSERT INTO PERMISSIONS_SRC_TEMP values ('Instructor','site.viewRoster');
INSERT INTO PERMISSIONS_SRC_TEMP values ('CIG Coordinator','site.viewRoster');
INSERT INTO PERMISSIONS_SRC_TEMP values ('Program Coordinator','site.viewRoster');
INSERT INTO PERMISSIONS_SRC_TEMP values ('Program Admin','site.viewRoster');

-- lookup the role and function numbers
CREATE TABLE PERMISSIONS_TEMP (ROLE_KEY INTEGER, FUNCTION_KEY INTEGER);
INSERT INTO PERMISSIONS_TEMP (ROLE_KEY, FUNCTION_KEY)
SELECT SRR.ROLE_KEY, SRF.FUNCTION_KEY
from PERMISSIONS_SRC_TEMP TMPSRC
JOIN SAKAI_REALM_ROLE SRR ON (TMPSRC.ROLE_NAME = SRR.ROLE_NAME)
JOIN SAKAI_REALM_FUNCTION SRF ON (TMPSRC.FUNCTION_NAME = SRF.FUNCTION_NAME);

-- insert the new functions into the roles of any existing realm that has the role (don't convert the "!site.helper")
INSERT INTO SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
SELECT
    SRRFD.REALM_KEY, SRRFD.ROLE_KEY, TMP.FUNCTION_KEY
FROM
    (SELECT DISTINCT SRRF.REALM_KEY, SRRF.ROLE_KEY FROM SAKAI_REALM_RL_FN SRRF) SRRFD
    JOIN PERMISSIONS_TEMP TMP ON (SRRFD.ROLE_KEY = TMP.ROLE_KEY)
    JOIN SAKAI_REALM SR ON (SRRFD.REALM_KEY = SR.REALM_KEY)
    WHERE SR.REALM_ID != '!site.helper'
    AND NOT EXISTS (
        SELECT 1
            FROM SAKAI_REALM_RL_FN SRRFI
            WHERE SRRFI.REALM_KEY=SRRFD.REALM_KEY AND SRRFI.ROLE_KEY=SRRFD.ROLE_KEY AND SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY
    );

-- clean up the temp tables
DROP TABLE PERMISSIONS_TEMP;
DROP TABLE PERMISSIONS_SRC_TEMP;

-- --- SAK-16024 site.add.course is a newly added permission

INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'site.add.course');
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!user.template.maintain'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = '.auth'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.add.course'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!user.template.registered'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = '.auth'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.add.course'));
INSERT INTO SAKAI_REALM_RL_FN VALUES((select REALM_KEY from SAKAI_REALM where REALM_ID = '!user.template.sample'), (select ROLE_KEY from SAKAI_REALM_ROLE where ROLE_NAME = '.auth'), (select FUNCTION_KEY from SAKAI_REALM_FUNCTION where FUNCTION_NAME = 'site.add.course'));

-- --------------------------------------------------------------------------------------------------------------------------------------
-- backfill new site.add.course permissions into existing realms
-- --------------------------------------------------------------------------------------------------------------------------------------

-- SAK-16751 Backfilling for site.add.course has been commented out as it updates all realms with .auth role unnecessarily (site realms only require backfilling)
-- It is a rather promiscuous conversion that may not square with an institution's permission strategy.  If you
-- uncomment it and run it you will add site.add.course to realms like /announcement/channel/!site/motd,
-- /site/!urlError and !user.template.guest. None of these realms have include site.add so they cannot create sites.
-- So consider your options carefully before uncommenting and running this backfill operation.

-- for each realm that has a role matching something in this table, we will add to that role the function from this table
-- CREATE TABLE PERMISSIONS_SRC_TEMP (ROLE_NAME VARCHAR2(99), FUNCTION_NAME VARCHAR2(99));

-- INSERT INTO PERMISSIONS_SRC_TEMP values ('.auth','site.add.course');

-- lookup the role and function numbers
-- CREATE TABLE PERMISSIONS_TEMP (ROLE_KEY INTEGER, FUNCTION_KEY INTEGER);
-- INSERT INTO PERMISSIONS_TEMP (ROLE_KEY, FUNCTION_KEY)
-- SELECT SRR.ROLE_KEY, SRF.FUNCTION_KEY
-- from PERMISSIONS_SRC_TEMP TMPSRC
-- JOIN SAKAI_REALM_ROLE SRR ON (TMPSRC.ROLE_NAME = SRR.ROLE_NAME)
-- JOIN SAKAI_REALM_FUNCTION SRF ON (TMPSRC.FUNCTION_NAME = SRF.FUNCTION_NAME);

-- insert the new functions into the roles of any existing realm that has the role (don't convert the "!site.helper")
-- INSERT INTO SAKAI_REALM_RL_FN (REALM_KEY, ROLE_KEY, FUNCTION_KEY)
-- SELECT
--    SRRFD.REALM_KEY, SRRFD.ROLE_KEY, TMP.FUNCTION_KEY
-- FROM
--    (SELECT DISTINCT SRRF.REALM_KEY, SRRF.ROLE_KEY FROM SAKAI_REALM_RL_FN SRRF) SRRFD
--    JOIN PERMISSIONS_TEMP TMP ON (SRRFD.ROLE_KEY = TMP.ROLE_KEY)
--    JOIN SAKAI_REALM SR ON (SRRFD.REALM_KEY = SR.REALM_KEY)
--    WHERE SR.REALM_ID != '!site.helper'
--    AND NOT EXISTS (
--        SELECT 1
--            FROM SAKAI_REALM_RL_FN SRRFI
--            WHERE SRRFI.REALM_KEY=SRRFD.REALM_KEY AND SRRFI.ROLE_KEY=SRRFD.ROLE_KEY AND SRRFI.FUNCTION_KEY=TMP.FUNCTION_KEY
--    );

-- clean up the temp tables
-- DROP TABLE PERMISSIONS_TEMP;
-- DROP TABLE PERMISSIONS_SRC_TEMP;

--
-- Citations SAK-14517 Support more RIS types for import/export
--
-- Updates
--
-- INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('article','title','sakai:ris_identifier','T1,TI,CT');
UPDATE CITATION_SCHEMA_FIELD SET PROPERTY_VALUE = 'T1,TI,CT' WHERE SCHEMA_ID = 'article' AND FIELD_ID = 'title' AND PROPERTY_NAME = 'sakai:ris_identifier';
--
-- INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('article','sourceTitle','sakai:ris_identifier','JF,BT');
UPDATE CITATION_SCHEMA_FIELD SET PROPERTY_VALUE = 'JF,BT' WHERE SCHEMA_ID = 'article' AND FIELD_ID = 'sourceTitle' AND PROPERTY_NAME = 'sakai:ris_identifier';
--
-- New fields
--
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','creator','sakai:hasOrder','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','creator','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','creator','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','creator','sakai:maxCardinality','2147483647');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','creator','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','creator','sakai:ris_identifier','AU');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sakai:hasField','creator');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','title','sakai:hasOrder','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','title','sakai:required','true');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','title','sakai:minCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','title','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','title','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','title','sakai:ris_identifier','CT');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sakai:hasField','title');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','year','sakai:hasOrder','2');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','year','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','year','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','year','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','year','sakai:valueType','number');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','year','sakai:ris_identifier','PY');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sakai:hasField','year');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','volume','sakai:hasOrder','3');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','volume','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','volume','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','volume','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','volume','sakai:valueType','number');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','volume','sakai:ris_identifier','VL');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sakai:hasField','volume');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','pages','sakai:hasOrder','4');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','pages','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','pages','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','pages','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','pages','sakai:valueType','number');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','pages','sakai:ris_identifier','SP');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sakai:hasField','pages');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sourceTitle','sakai:hasOrder','5');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sourceTitle','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sourceTitle','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sourceTitle','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sourceTitle','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sourceTitle','sakai:ris_identifier','BT');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sakai:hasField','sourceTitle');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','note','sakai:hasOrder','6');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','note','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','note','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','note','sakai:maxCardinality','2147483647');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','note','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','note','sakai:ris_identifier','N1');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('proceed','sakai:hasField','note');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','title','sakai:hasOrder','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','title','sakai:required','true');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','title','sakai:minCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','title','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','title','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','title','sakai:ris_identifier','CT');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sakai:hasField','title');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','year','sakai:hasOrder','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','year','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','year','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','year','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','year','sakai:valueType','number');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','year','sakai:ris_identifier','PY');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sakai:hasField','year');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sourceTitle','sakai:hasOrder','2');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sourceTitle','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sourceTitle','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sourceTitle','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sourceTitle','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sourceTitle','sakai:ris_identifier','T3');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sakai:hasField','sourceTitle');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','abstract','sakai:hasOrder','3');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','abstract','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','abstract','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','abstract','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','abstract','sakai:valueType','longtext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','abstract','sakai:ris_identifier','N2');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sakai:hasField','abstract');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','subject','sakai:hasOrder','4');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','subject','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','subject','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','subject','sakai:maxCardinality','2147483647');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','subject','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','subject','sakai:ris_identifier','KW');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('electronic','sakai:hasField','subject');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','creator','sakai:hasOrder','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','creator','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','creator','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','creator','sakai:maxCardinality','2147483647');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','creator','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','creator','sakai:ris_identifier','AU');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','sakai:hasField','creator');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','title','sakai:hasOrder','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','title','sakai:required','true');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','title','sakai:minCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','title','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','title','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','title','sakai:ris_identifier','CT');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','sakai:hasField','title');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','year','sakai:hasOrder','2');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','year','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','year','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','year','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','year','sakai:valueType','number');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','year','sakai:ris_identifier','PY');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','sakai:hasField','year');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','publisher','sakai:hasOrder','3');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','publisher','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','publisher','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','publisher','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','publisher','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','publisher','sakai:ris_identifier','PB');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','sakai:hasField','publisher');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','pages','sakai:hasOrder','4');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','pages','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','pages','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','pages','sakai:maxCardinality','1');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','pages','sakai:valueType','number');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','pages','sakai:ris_identifier','SP');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','sakai:hasField','pages');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','note','sakai:hasOrder','5');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','note','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','note','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','note','sakai:maxCardinality','2147483647');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','note','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','note','sakai:ris_identifier','N1');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','sakai:hasField','note');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','subject','sakai:hasOrder','6');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','subject','sakai:required','false');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','subject','sakai:minCardinality','0');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','subject','sakai:maxCardinality','2147483647');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','subject','sakai:valueType','shorttext');
INSERT INTO CITATION_SCHEMA_FIELD (SCHEMA_ID, FIELD_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','subject','sakai:ris_identifier','KW');
INSERT INTO CITATION_SCHEMA (SCHEMA_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES('thesis','sakai:hasField','subject');

-- tables for SAK-13843:  assignment - information display on triggers

    create table ASN_AP_ITEM_ACCESS_T (
        ID number(19,0) not null,
        ITEM_ACCESS varchar2(255),
        ASN_AP_ITEM_ID number(19,0) not null,
        primary key (ID),
        unique (ITEM_ACCESS, ASN_AP_ITEM_ID)
    );

    create table ASN_AP_ITEM_T (
        ID number(19,0) not null,
        ASSIGNMENT_ID varchar2(255),
        TITLE varchar2(255),
        TEXT clob,
        RELEASE_DATE date,
        RETRACT_DATE date,
        HIDE number(1,0),
        primary key (ID)
    );

    create table ASN_MA_ITEM_T (
        ID number(19,0) not null,
        ASSIGNMENT_ID varchar2(255),
        TEXT clob,
        SHOW_TO number(10,0),
        primary key (ID)
    );

    create table ASN_NOTE_ITEM_T (
        ID number(19,0) not null,
        ASSIGNMENT_ID varchar2(255),
        NOTE clob,
        CREATOR_ID varchar2(255),
        SHARE_WITH number(10,0),
        primary key (ID)
    );

    create table ASN_SUP_ATTACH_T (
        ID number(19,0) not null,
        ATTACHMENT_ID varchar2(255),
        ASN_SUP_ITEM_ID number(19,0) not null,
        primary key (ID),
        unique (ATTACHMENT_ID, ASN_SUP_ITEM_ID)
    );

    comment on table ASN_SUP_ATTACH_T is
        'This table is for assignment supplement item attachment.';

    create table ASN_SUP_ITEM_T (
        ID number(19,0) not null,
        primary key (ID)
    );

    create index ASN_AP_ITEM_I on ASN_AP_ITEM_ACCESS_T (ASN_AP_ITEM_ID);

    alter table ASN_AP_ITEM_ACCESS_T 
        add constraint FK573733586E844C61 
        foreign key (ASN_AP_ITEM_ID) 
        references ASN_AP_ITEM_T;

    alter table ASN_AP_ITEM_T 
        add constraint FK514CEE15935EEE07 
        foreign key (ID) 
        references ASN_SUP_ITEM_T;

    alter table ASN_MA_ITEM_T 
        add constraint FK2E508110935EEE07 
        foreign key (ID) 
        references ASN_SUP_ITEM_T;

    create index ASN_SUP_ITEM_I on ASN_SUP_ATTACH_T (ASN_SUP_ITEM_ID);

    alter table ASN_SUP_ATTACH_T 
        add constraint FK560294CEDE4CD07F 
        foreign key (ASN_SUP_ITEM_ID) 
        references ASN_SUP_ITEM_T;

    create sequence ASN_AP_ITEM_S;

    create sequence ASN_NOTE_S;

    create sequence ASN_SUP_ITEM_ATT_S;

    create sequence ASN_SUP_ITEM_S;

-- SAK-7670 Add new table for delayed events

CREATE TABLE SAKAI_EVENT_DELAY
(
        EVENT_DELAY_ID NUMBER,
        EVENT VARCHAR2 (32),
        REF VARCHAR2 (255),
        USER_ID VARCHAR2 (99),
        EVENT_CODE VARCHAR2 (1),
        PRIORITY NUMBER (1)
);

CREATE UNIQUE INDEX SAKAI_EVENT_DELAY_INDEX ON SAKAI_EVENT_DELAY
(
        EVENT_DELAY_ID
);

CREATE INDEX SAKAI_EVENT_DELAY_REF_INDEX ON SAKAI_EVENT_DELAY
(
        REF     ASC
);

CREATE SEQUENCE SAKAI_EVENT_DELAY_SEQ;

-- SAK-13584 Further Improve the Performance of the Email Archive and Message API. Note you have to run a bash conversion script on your old mail archive data for it to
-- appear in the new mail archive. The script is in the source as mailarchive-runconversion.sh. Please see the SAK for more information on this script or SAK-16554 for
-- updates to this script. 

ALTER TABLE MAILARCHIVE_MESSAGE ADD (
       SUBJECT           VARCHAR2 (255) default null,
       BODY              CLOB default null
);

CREATE INDEX MAILARCHIVE_SUBJECT_INDEX ON MAILARCHIVE_MESSAGE
(
        SUBJECT
);

-- SAK-16463 fix
alter table MAILARCHIVE_MESSAGE modify XML CLOB;

-- Note after performing these conversions your indexes may be in an invalid state because of the required clob conversion.
-- You may need to run ths following statement, manually execute the generated 'alter indexes' and re-gather statistics on this table
-- There is a randomly named index so it can not be automated.

-- See the 2.6 release notes or SAK-16553 for further details

-- select 'alter index '||index_name||' rebuild online;' from user_indexes where status = 'INVALID' or status = 'UNUSABLE'; 

-- SAK-11096 asn.share.drafts is a newly added permission

INSERT INTO SAKAI_REALM_FUNCTION VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'asn.share.drafts');
-- SAK-16847  asn.share.drafts permission should be added into 2.6.1 conversion script
-- This might have been added with the 2.6.0 conversion but was added after release

MERGE INTO SAKAI_REALM_FUNCTION a USING (
     SELECT 'asn.share.drafts' as FUNCTION_NAME from dual) b
 ON (a.FUNCTION_NAME = b.FUNCTION_NAME)
 WHEN NOT MATCHED THEN INSERT (FUNCTION_KEY,FUNCTION_NAME) VALUES (SAKAI_REALM_FUNCTION_SEQ.NEXTVAL, 'asn.share.drafts');

-- Two recent Jira's (http://jira.sakaiproject.org/browse/SAK-17061) and (http://jira.sakaiproject.org/browse/PRFL-97) 
-- have uncovered that when the field 'locked' was added to the SAKAI_PERSON_T a while ago 
-- (before 2.5.0 was cut), there was no DB upgrade script added to upgrade existing entries. 

-- Here is the Jira that added the locked field: http://jira.sakaiproject.org/browse SAK-10512

--As such, this field is null for old profiles. Its set correctly for any new profiles but all old entries need to be converted.

update SAKAI_PERSON_T set locked=0 where locked=null; 


-- SAK-16668

alter table asn_note_item_t add note_clob clob;
update asn_note_item_t set note_clob = note;
alter table asn_note_item_t drop column note;
alter table asn_note_item_t rename column note_clob to note;

 

alter table asn_ma_item_t add text_clob clob;
update asn_ma_item_t set text_clob = text;
alter table asn_ma_item_t drop column text;
alter table asn_ma_item_t rename column text_clob to text;


-- SAK-16548 - Incorrect internationalization showing the grade NO GRADE
-- NOTE: It is possible that your xml column in assignment_submission may be a long type. You need to convert it to a clob if this is the case.
--       The following SQL will fail to run if the column is a long.

--       This seems to be either clob or long (It needs to be a clob)

-- alter table assignment_submission modify xml clob;

-- Note after performing a conversion to clob your indexes may be in an invalid/unusable state. 
-- You will need to run ths following statement, and manually execute the generated 'alter indexes' and re-gather statistics on this table.
-- There are randomly named indexes so it can not be automated.

-- select 'alter index '||index_name||' rebuild online;' from user_indexes where status = 'INVALID' or status = 'UNUSABLE'; 

-- After the field(s) are clobs continue with the updates

-- Values pulled from gen.nograd in ./assignment-bundles/assignment_*.properties

-- ******* Information about SAK-16548 conversion. *******

-- This conversion is broken up into 3 parts for performance reasons. The first part does a create table based on a select, it filters out results it needs to change.
-- In production at Michigan this took ~7 hours to filter through 2 million submissions and created a table with 20000 rows (1% of the table). The original script planned
-- for 2.6.1 took days to complete and did full table locks. 

-- The second part performs updates based on the results from the filter. In our case the update only took around 5 minutes, much less than the filter. 

-- You can run both of these parts while your system is up, you don't need to have an extended downtime.   

--Step 1: Create a temporary table using a subselect to just get the ids that need updating
create table assignment_submission_id_temp as
    select submission_id from assignment_submission where graded = 'true' and (
--assignment_zh_CN.properties
        instr(xml,unistr('"\65E0\8BC4\5206"')) !=0 or 
--assignment_ar.properties
        instr(xml,unistr('"\0644\0627 \062A\0648\062C\062F \0623\064A \062F\0631\062C\0629."')) !=0 or 
--assignment_pt_BR.properties
        instr(xml,unistr('"Nenhuma Avalia\00e7\00e3o"')) !=0 or 
--assignment_es.properties 
        instr(xml,unistr('"No hay calificaci\00F3n"')) !=0 or 
--assignment_ko.properties
        instr(xml,unistr('"\d559\c810 \c5c6\c74c"')) !=0 or 
--assignment_eu.propertie
        instr(xml,unistr('"Kalifikatu gabe"')) !=0 or 
--assignment_nl.properties
        instr(xml,unistr('"Zonder beoordeling"')) !=0 or 
--assignment_fr_CA.properties
        instr(xml,unistr('"Aucune note"')) !=0 or 
--assignment_en_GB.properties
        instr(xml,unistr('"No Mark"')) !=0 or 
--assignment.properties
        instr(xml,unistr('"No Grade"')) !=0 or 
--assignment_ca.properties
        instr(xml,unistr('"No hi ha qualificaci\00f3"')) !=0 or 
--assignment_pt_PT.properties
        instr(xml,unistr('"Sem avalia\00E7\00E3o"')) !=0 or 
--assignment_ru.properties
        instr(xml,unistr('"\0411\0435\0437 \043e\0446\0435\043d\043a\0438"')) !=0 or 
--assignment_sv.properties
        instr(xml,unistr('"Betygs\00E4tts ej"')) !=0 or 
--assignment_ja.properties
        instr(xml,unistr('"\63a1\70b9\3057\306a\3044"')) !=0 or 
--assignment_zh_TW.properties
        instr(xml,unistr('"\6c92\6709\8a55\5206"')) !=0  
);

--Step 2:Run the update from this temporary table
update assignment_submission set xml = regexp_replace(xml, 'scaled_grade=".*?"', 'scaled_grade="gen.nograd"') where submission_id in (
    select submission_id from assignment_submission_id_temp);

--Step 3: Drop the temp table
drop table assignment_submission_id_temp; 

-- END OF SAK-16548
-- This is the Oracle Sakai 2.6.2 -> 2.6.3 conversion script
-- --------------------------------------------------------------------------------------------------------------------------------------
-- 
-- use this to convert a Sakai database from 2.6.2 to 2.6.3.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
-- Script insertion format
-- -- [TICKET] [short comment]
-- -- [comment continued] (repeat as necessary)
-- SQL statement
-- --------------------------------------------------------------------------------------------------------------------------------------

-- SAK-8421 add indexes to improve performance of Forums statistics view.
create index MFR_UNREAD_MESSAGE_C_ID on MFR_UNREAD_STATUS_T (MESSAGE_C);
create index MFR_UNREAD_TOPIC_C_ID on MFR_UNREAD_STATUS_T (TOPIC_C);
create index MFR_UNREAD_USER_C_ID on MFR_UNREAD_STATUS_T (USER_C);
create index MFR_UNREAD_READ_C_ID on MFR_UNREAD_STATUS_T (READ_C);

-- SAK-14482 update Mercury site to use new assignments tool
-- The 'mercury' site has the old sakai.assignment tool which is not available in 2.5
-- (and thus has no icon and clicking on it has no effect). This replaces it with the sakai.assignment.grades tool 
-- as well as patches the !worksite which suffers from the same problem.

-- NOTE: while provided in the sakai_2_5_0-2_5_x_oracle_conversion005_SAK-14482.sql on 12 Jan 2009 
-- this change was not included in a 2.5 rollup conversion script until sakai_2_5_5-2_5_6_oracle_conversion.sql
-- and was only added to the 2.6.x branch on 2 Feb 2010 as sakai_2_6_0-2_6_x_oracle_conversion005_SAK-14482.sql 
-- AFTER sakai-2.6.2 was released on 29 Jan 2010.  There is a chance then that deployers may have missed this update
-- and we are including it for the sake of consistency.  Running the two update statements against an already 
-- updated SAKAI_SITE_TOOL table will affect 0 rows and do no harm.

-- update Mercury site
UPDATE SAKAI_SITE_TOOL SET REGISTRATION='sakai.assignment.grades' WHERE REGISTRATION='sakai.assignment' AND SITE_ID='mercury';

-- update !worksite site
UPDATE SAKAI_SITE_TOOL SET REGISTRATION='sakai.assignment.grades' WHERE REGISTRATION='sakai.assignment' AND SITE_ID='!worksite';

-- SAK-5742 create SAKAI_PERSON_T indexes  
create index SAKAI_PERSON_SURNAME_I on SAKAI_PERSON_T (SURNAME);
create index SAKAI_PERSON_ferpaEnabled_I on SAKAI_PERSON_T (ferpaEnabled);
create index SAKAI_PERSON_GIVEN_NAME_I on SAKAI_PERSON_T (GIVEN_NAME);
create index SAKAI_PERSON_UID_I on SAKAI_PERSON_T (UID_C);
-- This is the Oracle Sakai 2.6.x -> 2.7.0 conversion script
-- --------------------------------------------------------------------------------------------------------------------------------------
-- 
-- use this to convert a Sakai database from 2.6.x to 2.7.0.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
-- Script insertion format
-- -- [TICKET] [short comment]
-- -- [comment continued] (repeat as necessary)
-- SQL statement
-- --------------------------------------------------------------------------------------------------------------------------------------

-- SAK-16686/KNL-241 Support exceptions to dynamic page localization
INSERT INTO SAKAI_SITE_PAGE_PROPERTY VALUES ('~admin','~admin-400','sitePage.customTitle','true');

-- SAK-16832
ALTER TABLE SAM_PUBLISHEDASSESSMENT_T ADD LASTNEEDRESUBMITDATE timestamp NULL;

-- SAK-17447
alter table EMAIL_TEMPLATE_ITEM add HTMLMESSAGE clob; 

-- SAK-16984 new column in sakai-Person
alter TABLE SAKAI_PERSON_T add NORMALIZEDMOBILE varchar2(255) NULL;

-- SAK-15165 new fields for SakaiPerson
alter table SAKAI_PERSON_T add FAVOURITE_BOOKS varchar2(4000); 
alter table SAKAI_PERSON_T add FAVOURITE_TV_SHOWS varchar2(4000); 
alter table SAKAI_PERSON_T add FAVOURITE_MOVIES varchar2(4000); 
alter table SAKAI_PERSON_T add FAVOURITE_QUOTES varchar2(4000); 
alter table SAKAI_PERSON_T add EDUCATION_COURSE varchar2(4000); 
alter table SAKAI_PERSON_T add EDUCATION_SUBJECTS varchar2(4000);

-- SAK-17485/SAK-10559
alter table MFR_MESSAGE_T add NUM_READERS int;
update MFR_MESSAGE_T set NUM_READERS = 0; 

-- SAK-16835 columns for new quartz version
alter table QRTZ_TRIGGERS add PRIORITY number(13) NULL;
alter table QRTZ_FIRED_TRIGGERS add PRIORITY number(13) NOT NULL;

-- SAK-16835 migrate existing triggers to have default value
-- see http://www.opensymphony.com/quartz/wikidocs/Quartz%201.6.0.html
update QRTZ_TRIGGERS set PRIORITY = 5 where PRIORITY IS NULL;
update QRTZ_FIRED_TRIGGERS set PRIORITY = 5 where PRIORITY IS NULL; 

-- START SiteStats 2.1 (SAK-17773)
-- IMPORTANT: Installations with previous (contrib) versions of SiteStats deployed should
--            comment out lines below and consult this url for possible conversion upgrades:
--            https://source.sakaiproject.org/svn/sitestats/trunk/updating/
-- NOTE:      There is no DB conversion required from SiteStats 2.0 -> 2.1
create table SST_EVENTS (ID number(19,0) not null, USER_ID varchar2(99 char) not null, SITE_ID varchar2(99 char) not null, EVENT_ID varchar2(32 char) not null, EVENT_DATE date not null, EVENT_COUNT number(19,0) not null, primary key (ID));
create table SST_JOB_RUN (ID number(19,0) not null, JOB_START_DATE timestamp, JOB_END_DATE timestamp, START_EVENT_ID number(19,0), END_EVENT_ID number(19,0), LAST_EVENT_DATE timestamp, primary key (ID));
create table SST_PREFERENCES (ID number(19,0) not null, SITE_ID varchar2(99 char) not null, PREFS clob not null, primary key (ID));
create table SST_REPORTS (ID number(19,0) not null, SITE_ID varchar2(99 char), TITLE varchar2(255 char) not null, DESCRIPTION clob, HIDDEN number(1,0), REPORT_DEF clob not null, CREATED_BY varchar2(99 char) not null, CREATED_ON timestamp not null, MODIFIED_BY varchar2(99 char), MODIFIED_ON timestamp, primary key (ID));
create table SST_RESOURCES (ID number(19,0) not null, USER_ID varchar2(99 char) not null, SITE_ID varchar2(99 char) not null, RESOURCE_REF varchar2(255 char) not null, RESOURCE_ACTION varchar2(12 char) not null, RESOURCE_DATE date not null, RESOURCE_COUNT number(19,0) not null, primary key (ID));
create table SST_SITEACTIVITY (ID number(19,0) not null, SITE_ID varchar2(99 char) not null, ACTIVITY_DATE date not null, EVENT_ID varchar2(32 char) not null, ACTIVITY_COUNT number(19,0) not null, primary key (ID));
create table SST_SITEVISITS (ID number(19,0) not null, SITE_ID varchar2(99 char) not null, VISITS_DATE date not null, TOTAL_VISITS number(19,0) not null, TOTAL_UNIQUE number(19,0) not null, primary key (ID));
create index SST_EVENTS_SITE_ID_IX on SST_EVENTS (SITE_ID);
create index SST_EVENTS_USER_ID_IX on SST_EVENTS (USER_ID);
create index SST_EVENTS_EVENT_ID_IX on SST_EVENTS (EVENT_ID);
create index SST_EVENTS_DATE_IX on SST_EVENTS (EVENT_DATE);
create index SST_PREFERENCES_SITE_ID_IX on SST_PREFERENCES (SITE_ID);
create index SST_REPORTS_SITE_ID_IX on SST_REPORTS (SITE_ID);
create index SST_RESOURCES_DATE_IX on SST_RESOURCES (RESOURCE_DATE);
create index SST_RESOURCES_RES_ACT_IDX on SST_RESOURCES (RESOURCE_ACTION);
create index SST_RESOURCES_USER_ID_IX on SST_RESOURCES (USER_ID);
create index SST_RESOURCES_SITE_ID_IX on SST_RESOURCES (SITE_ID);
create index SST_SITEACTIVITY_DATE_IX on SST_SITEACTIVITY (ACTIVITY_DATE);
create index SST_SITEACTIVITY_EVENT_ID_IX on SST_SITEACTIVITY (EVENT_ID);
create index SST_SITEACTIVITY_SITE_ID_IX on SST_SITEACTIVITY (SITE_ID);
create index SST_SITEVISITS_SITE_ID_IX on SST_SITEVISITS (SITE_ID);
create index SST_SITEVISITS_DATE_IX on SST_SITEVISITS (VISITS_DATE);
create index SST_EVENTS_SITEEVENTUSER_ID_IX on SST_EVENTS (SITE_ID,EVENT_ID,USER_ID);
create sequence SST_EVENTS_ID;
create sequence SST_JOB_RUN_ID;
create sequence SST_PREFERENCES_ID;
create sequence SST_REPORTS_ID;
create sequence SST_RESOURCES_ID;
create sequence SST_SITEACTIVITY_ID;
create sequence SST_SITEVISITS_ID;

-- OPTIONAL: Preload with default reports (STAT-35)
--   0) Activity total (Show activity in site, with totals per event.)
insert into SST_REPORTS (ID,SITE_ID,TITLE,DESCRIPTION,HIDDEN,REPORT_DEF,CREATED_BY,CREATED_ON,MODIFIED_BY,MODIFIED_ON) values (SST_REPORTS_ID.NEXTVAL,NULL,'${predefined_report0_title}','${predefined_report0_description}',0,'<?xml version=''1.0'' ?><ReportParams><howChartCategorySource>none</howChartCategorySource><howChartSeriesSource>total</howChartSeriesSource><howChartSource>event</howChartSource><howChartType>pie</howChartType><howLimitedMaxResults>false</howLimitedMaxResults><howMaxResults>0</howMaxResults><howPresentationMode>how-presentation-both</howPresentationMode><howSort>true</howSort><howSortAscending>true</howSortAscending><howSortBy>event</howSortBy><howTotalsBy><howTotalsBy>event</howTotalsBy></howTotalsBy><siteId/><what>what-events</what><whatEventIds/><whatEventSelType>what-events-bytool</whatEventSelType><whatLimitedAction>false</whatLimitedAction><whatLimitedResourceIds>false</whatLimitedResourceIds><whatResourceAction>new</whatResourceAction><whatResourceIds/><whatToolIds><whatToolIds>all</whatToolIds></whatToolIds><when>when-all</when><whenFrom/><whenTo/><who>who-all</who><whoGroupId/><whoRoleId>access</whoRoleId><whoUserIds/></ReportParams>','preload',(SELECT current_date FROM dual),'preload',(SELECT current_date FROM dual));
--   1) Most accessed files (Show top 10 most accessed files.)
insert into SST_REPORTS (ID,SITE_ID,TITLE,DESCRIPTION,HIDDEN,REPORT_DEF,CREATED_BY,CREATED_ON,MODIFIED_BY,MODIFIED_ON) values (SST_REPORTS_ID.NEXTVAL,NULL,'${predefined_report1_title}','${predefined_report1_description}',0,'<?xml version=''1.0'' ?><ReportParams><howChartCategorySource>none</howChartCategorySource><howChartSeriesSource>total</howChartSeriesSource><howChartSource>resource</howChartSource><howChartType>pie</howChartType><howLimitedMaxResults>true</howLimitedMaxResults><howMaxResults>10</howMaxResults><howPresentationMode>how-presentation-both</howPresentationMode><howSort>true</howSort><howSortAscending>false</howSortAscending><howSortBy>total</howSortBy><howTotalsBy><howTotalsBy>resource</howTotalsBy></howTotalsBy><siteId/><what>what-resources</what><whatEventIds/><whatEventSelType>what-events-bytool</whatEventSelType><whatLimitedAction>true</whatLimitedAction><whatLimitedResourceIds>false</whatLimitedResourceIds><whatResourceAction>read</whatResourceAction><whatResourceIds/><whatToolIds><whatToolIds>all</whatToolIds></whatToolIds><when>when-all</when><whenFrom/><whenTo/><who>who-all</who><whoGroupId/><whoRoleId>access</whoRoleId><whoUserIds/></ReportParams>','preload',(SELECT current_date FROM dual),'preload',(SELECT current_date FROM dual));
--   2) Most active users (Show top 10 users with most activity in site.)
insert into SST_REPORTS (ID,SITE_ID,TITLE,DESCRIPTION,HIDDEN,REPORT_DEF,CREATED_BY,CREATED_ON,MODIFIED_BY,MODIFIED_ON) values (SST_REPORTS_ID.NEXTVAL,NULL,'${predefined_report2_title}','${predefined_report2_description}',0,'<?xml version=''1.0'' ?><ReportParams><howChartCategorySource>none</howChartCategorySource><howChartSeriesSource>total</howChartSeriesSource><howChartSource>user</howChartSource><howChartType>pie</howChartType><howLimitedMaxResults>true</howLimitedMaxResults><howMaxResults>10</howMaxResults><howPresentationMode>how-presentation-both</howPresentationMode><howSort>true</howSort><howSortAscending>false</howSortAscending><howSortBy>total</howSortBy><howTotalsBy><howTotalsBy>user</howTotalsBy></howTotalsBy><siteId/><what>what-events</what><whatEventIds/><whatEventSelType>what-events-bytool</whatEventSelType><whatLimitedAction>false</whatLimitedAction><whatLimitedResourceIds>false</whatLimitedResourceIds><whatResourceAction>new</whatResourceAction><whatResourceIds/><whatToolIds><whatToolIds>all</whatToolIds></whatToolIds><when>when-all</when><whenFrom/><whenTo/><who>who-all</who><whoGroupId/><whoRoleId>access</whoRoleId><whoUserIds/></ReportParams>','preload',(SELECT current_date FROM dual),'preload',(SELECT current_date FROM dual));
--   3) Less active users (Show top 10 users with less activity in site.)
insert into SST_REPORTS (ID,SITE_ID,TITLE,DESCRIPTION,HIDDEN,REPORT_DEF,CREATED_BY,CREATED_ON,MODIFIED_BY,MODIFIED_ON) values (SST_REPORTS_ID.NEXTVAL,NULL,'${predefined_report3_title}','${predefined_report3_description}',0,'<?xml version=''1.0'' ?><ReportParams><howChartCategorySource>none</howChartCategorySource><howChartSeriesSource>total</howChartSeriesSource><howChartSource>user</howChartSource><howChartType>bar</howChartType><howLimitedMaxResults>false</howLimitedMaxResults><howMaxResults>0</howMaxResults><howPresentationMode>how-presentation-both</howPresentationMode><howSort>true</howSort><howSortAscending>true</howSortAscending><howSortBy>total</howSortBy><howTotalsBy><howTotalsBy>user</howTotalsBy></howTotalsBy><siteId/><what>what-events</what><whatEventIds/><whatEventSelType>what-events-bytool</whatEventSelType><whatLimitedAction>false</whatLimitedAction><whatLimitedResourceIds>false</whatLimitedResourceIds><whatResourceAction>new</whatResourceAction><whatResourceIds/><whatToolIds><whatToolIds>all</whatToolIds></whatToolIds><when>when-all</when><whenFrom/><whenTo/><who>who-all</who><whoGroupId/><whoRoleId>access</whoRoleId><whoUserIds/></ReportParams>','preload',(SELECT current_date FROM dual),'preload',(SELECT current_date FROM dual));
--   4) Users with more visits (Show top 10 users who have most visited the site.)
insert into SST_REPORTS (ID,SITE_ID,TITLE,DESCRIPTION,HIDDEN,REPORT_DEF,CREATED_BY,CREATED_ON,MODIFIED_BY,MODIFIED_ON) values (SST_REPORTS_ID.NEXTVAL,NULL,'${predefined_report4_title}','${predefined_report4_description}',0,'<?xml version=''1.0'' ?><ReportParams><howChartCategorySource>none</howChartCategorySource><howChartSeriesSource>total</howChartSeriesSource><howChartSource>user</howChartSource><howChartType>bar</howChartType><howLimitedMaxResults>false</howLimitedMaxResults><howMaxResults>0</howMaxResults><howPresentationMode>how-presentation-both</howPresentationMode><howSort>true</howSort><howSortAscending>false</howSortAscending><howSortBy>total</howSortBy><howTotalsBy><howTotalsBy>user</howTotalsBy></howTotalsBy><siteId/><what>what-visits</what><whatEventIds/><whatEventSelType>what-events-bytool</whatEventSelType><whatLimitedAction>false</whatLimitedAction><whatLimitedResourceIds>false</whatLimitedResourceIds><whatResourceAction>new</whatResourceAction><whatResourceIds/><whatToolIds><whatToolIds>all</whatToolIds></whatToolIds><when>when-all</when><whenFrom/><whenTo/><who>who-all</who><whoGroupId/><whoRoleId>access</whoRoleId><whoUserIds/></ReportParams>','preload',(SELECT current_date FROM dual),'preload',(SELECT current_date FROM dual));
--   5) Users with no visits (Show users who have never visited the site.)
insert into SST_REPORTS (ID,SITE_ID,TITLE,DESCRIPTION,HIDDEN,REPORT_DEF,CREATED_BY,CREATED_ON,MODIFIED_BY,MODIFIED_ON) values (SST_REPORTS_ID.NEXTVAL,NULL,'${predefined_report5_title}','${predefined_report5_description}',0,'<?xml version=''1.0'' ?><ReportParams><howChartCategorySource>none</howChartCategorySource><howChartSeriesSource>total</howChartSeriesSource><howChartSource>event</howChartSource><howChartType>bar</howChartType><howLimitedMaxResults>false</howLimitedMaxResults><howMaxResults>0</howMaxResults><howPresentationMode>how-presentation-table</howPresentationMode><howSort>false</howSort><howSortAscending>false</howSortAscending><howSortBy>default</howSortBy><howTotalsBy><howTotalsBy>user</howTotalsBy></howTotalsBy><siteId/><what>what-visits</what><whatEventIds/><whatEventSelType>what-events-bytool</whatEventSelType><whatLimitedAction>false</whatLimitedAction><whatLimitedResourceIds>false</whatLimitedResourceIds><whatResourceAction>new</whatResourceAction><whatResourceIds/><whatToolIds><whatToolIds>all</whatToolIds></whatToolIds><when>when-all</when><whenFrom/><whenTo/><who>who-none</who><whoGroupId/><whoRoleId>access</whoRoleId><whoUserIds/></ReportParams>','preload',(SELECT current_date FROM dual),'preload',(SELECT current_date FROM dual));
--   6) Users with no activity (Show users with no activity in site.)
insert into SST_REPORTS (ID,SITE_ID,TITLE,DESCRIPTION,HIDDEN,REPORT_DEF,CREATED_BY,CREATED_ON,MODIFIED_BY,MODIFIED_ON) values (SST_REPORTS_ID.NEXTVAL,NULL,'${predefined_report6_title}','${predefined_report6_description}',0,'<?xml version=''1.0'' ?><ReportParams><howChartCategorySource>none</howChartCategorySource><howChartSeriesPeriod>byday</howChartSeriesPeriod><howChartSeriesSource>total</howChartSeriesSource><howChartSource>event</howChartSource><howChartType>bar</howChartType><howLimitedMaxResults>false</howLimitedMaxResults><howMaxResults>0</howMaxResults><howPresentationMode>how-presentation-table</howPresentationMode><howSort>false</howSort><howSortAscending>true</howSortAscending><howSortBy>default</howSortBy><howTotalsBy><howTotalsBy>user</howTotalsBy></howTotalsBy><siteId/><what>what-events</what><whatEventIds/><whatEventSelType>what-events-bytool</whatEventSelType><whatLimitedAction>false</whatLimitedAction><whatLimitedResourceIds>false</whatLimitedResourceIds><whatResourceAction>new</whatResourceAction><whatResourceIds/><whatToolIds><whatToolIds>all</whatToolIds></whatToolIds><when>when-all</when><whenFrom/><whenTo/><who>who-none</who><whoGroupId/><whoRoleId>access</whoRoleId><whoUserIds/></ReportParams>','preload',(SELECT current_date FROM dual),'preload',(SELECT current_date FROM dual));
-- END SiteStats 2.1 (SAK-17773)

-- START Profile2 1.3 (SAK-17773)
-- IMPORTANT: Installations with previous (contrib) versions of Profile2 deployed should
--            comment out lines below and consult this url for possible conversion upgrades:
--            https://source.sakaiproject.org/svn//profile2/branches/profile2-1.3.x/docs/database/oracle/
create table PROFILE_FRIENDS_T (
    ID number(19,0) not null,
    USER_UUID varchar2(99) not null,
    FRIEND_UUID varchar2(99) not null,
    RELATIONSHIP number(10,0) not null,
    REQUESTED_DATE date not null,
    CONFIRMED number(1,0) not null,
    CONFIRMED_DATE date,
    primary key (ID)
);

create table PROFILE_IMAGES_EXTERNAL_T (
    USER_UUID varchar2(99) not null,
    URL_MAIN varchar2(4000) not null,
    URL_THUMB varchar2(4000),
    primary key (USER_UUID)
);

create table PROFILE_IMAGES_T (
    ID number(19,0) not null,
    USER_UUID varchar2(99) not null,
    RESOURCE_MAIN varchar2(255) not null,
    RESOURCE_THUMB varchar2(255) not null,
    IS_CURRENT number(1,0) not null,
    primary key (ID)
);

create table PROFILE_PREFERENCES_T (
    USER_UUID varchar2(99) not null,
    EMAIL_REQUEST number(1,0) not null,
    EMAIL_CONFIRM number(1,0) not null,
    TWITTER_ENABLED number(1,0) not null,
    TWITTER_USERNAME varchar2(255),
    TWITTER_PASSWORD varchar2(255),
    primary key (USER_UUID)
);

create table PROFILE_PRIVACY_T (
    USER_UUID varchar2(99) not null,
    PROFILE_IMAGE number(10,0) not null,
    BASIC_INFO number(10,0) not null,
    CONTACT_INFO number(10,0) not null,
    ACADEMIC_INFO number(10,0) not null,
    PERSONAL_INFO number(10,0) not null,
    BIRTH_YEAR number(1,0) not null,
    SEARCH number(10,0) not null,
    MY_FRIENDS number(10,0) not null,
    MY_STATUS number(10,0) not null,
    primary key (USER_UUID)
);

create table PROFILE_STATUS_T (
    USER_UUID varchar2(99) not null,
    MESSAGE varchar2(255) not null,
    DATE_ADDED date not null,
    primary key (USER_UUID)
);

create table SAKAI_PERSON_META_T (
    ID number(19,0) not null,
    USER_UUID varchar2(99) not null,
    PROPERTY varchar2(255) not null,
    VALUE varchar2(255) not null,
    primary key (ID)
);

create index PROFILE_FRIENDS_FRIEND_UUID_I on PROFILE_FRIENDS_T (FRIEND_UUID);
create index PROFILE_FRIENDS_USER_UUID_I on PROFILE_FRIENDS_T (USER_UUID);
create index PROFILE_IMAGES_USER_UUID_I on PROFILE_IMAGES_T (USER_UUID);
create index PROFILE_IMAGES_IS_CURRENT_I on PROFILE_IMAGES_T (IS_CURRENT);
create sequence PROFILE_FRIENDS_S;
create sequence PROFILE_IMAGES_S;
create sequence SAKAI_PERSON_META_S;
create index SAKAI_PERSON_META_USER_UUID_I on SAKAI_PERSON_META_T (USER_UUID);
create index SAKAI_PERSON_META_PROPERTY_I on SAKAI_PERSON_META_T (PROPERTY);

-- Replace Profile by Profile2 for new and existing sites:
-- update SAKAI_SITE_TOOL set REGISTRATION='sakai.profile2' where REGISTRATION='sakai.profile';
-- Replace Profile by Profile2 only for new sites:
update SAKAI_SITE_TOOL set REGISTRATION='sakai.profile2' where REGISTRATION='sakai.profile' and SITE_ID='!user';
-- END Profile2 1.3 (SAK-17773)

-- SAK-11740 email notification of new posts to forum
-- You may need to run these drop commands if this table still exists in your db
-- DROP TABLE MFR_EMAIL_NOTIFICATION_TIF EXISTS;
-- drop sequence MFR_EMAIL_NOTIFICATION_S;

CREATE TABLE  "MFR_EMAIL_NOTIFICATION_T"
   (    "ID" NUMBER(19,0) NOT NULL ENABLE,
        "VERSION" NUMBER(10,0) NOT NULL ENABLE,
        "USER_ID" VARCHAR2(255 BYTE) NOT NULL ENABLE,
        "CONTEXT_ID" VARCHAR2(255 BYTE) NOT NULL ENABLE,
        "NOTIFICATION_LEVEL" VARCHAR2(1) NOT NULL ENABLE,
         PRIMARY KEY ("ID")
   );
   
CREATE INDEX "MFR_EMAIL_USER_ID_I" ON  "MFR_EMAIL_NOTIFICATION_T" ("USER_ID")  ;
CREATE INDEX  "MFR_EMAIL_CONTEXT_ID_I" ON  "MFR_EMAIL_NOTIFICATION_T" ("CONTEXT_ID") ;

create sequence MFR_EMAIL_NOTIFICATION_S;

-- SAK-15052 update cafe versions to 2.7.0-SNAPSHOT
alter table MFR_MESSAGE_T add THREADID NUMBER(20);
alter table MFR_MESSAGE_T add LASTTHREADATE TIMESTAMP;
alter table MFR_MESSAGE_T add LASTTHREAPOST NUMBER(20);

update MFR_MESSAGE_T set THREADID=IN_REPLY_TO,LASTTHREADATE=CREATED;

-- SAK-10869 displaying all messages should mark them as read

-- SAK-10869 add AutoMarkThreadsRead functionality to Message Center
-- add column to allow AutoMarkThreadsRead as template setting
alter table MFR_AREA_T add (AUTO_MARK_THREADS_READ NUMBER(1,0));
update MFR_AREA_T set AUTO_MARK_THREADS_READ=0 where AUTO_MARK_THREADS_READ is NULL;
alter table MFR_AREA_T modify (AUTO_MARK_THREADS_READ NUMBER(1,0) not null);

-- add column to allow AutoMarkThreadsRead to be set at the forum level
alter table MFR_OPEN_FORUM_T add (AUTO_MARK_THREADS_READ NUMBER(1,0));
update MFR_OPEN_FORUM_T set AUTO_MARK_THREADS_READ=0 where AUTO_MARK_THREADS_READ is NULL;
alter table MFR_OPEN_FORUM_T modify (AUTO_MARK_THREADS_READ NUMBER(1,0) not null);

-- add column to allow AutoMarkThreadsRead to be set at the topic level
alter table MFR_TOPIC_T add (AUTO_MARK_THREADS_READ NUMBER(1,0));
update MFR_TOPIC_T set AUTO_MARK_THREADS_READ=0 where AUTO_MARK_THREADS_READ is NULL;
alter table MFR_TOPIC_T modify (AUTO_MARK_THREADS_READ NUMBER(1,0) not null);

-- SAK-10559 view who has read a message
-- if MFR_MESSAGE_T is missing NUM_READERS, run alter and update commands
-- alter table MFR_MESSAGE_T add NUM_READERS int;
-- update MFR_MESSAGE_T set NUM_READERS = 0;

-- SAK-15655 rework MyWorkspace Synoptic view of Messages & Forums
create table MFR_SYNOPTIC_ITEM
(SYNOPTIC_ITEM_ID number(19,0) not null,
VERSION number(10,0) not null,
USER_ID varchar2(36 char) not null,
SITE_ID varchar2(99 char) not null,
SITE_TITLE varchar2(255 char),
NEW_MESSAGES_COUNT number(10,0),
MESSAGES_LAST_VISIT_DT timestamp,
NEW_FORUM_COUNT number(10,0),
FORUM_LAST_VISIT_DT timestamp,
HIDE_ITEM NUMBER(1,0),
primary key (SYNOPTIC_ITEM_ID),
unique (USER_ID, SITE_ID));

create sequence MFR_SYNOPTIC_ITEM_S;

create index MRF_SYN_USER on MFR_SYNOPTIC_ITEM (USER_ID);

-- MSGCNTR-177 MyWorkspace/Home does now show the Messages & Forums Notifications by default
update SAKAI_SITE_TOOL
Set TITLE = 'Unread Messages and Forums'
Where REGISTRATION = 'sakai.synoptic.messagecenter'; 

INSERT INTO SAKAI_SITE_TOOL VALUES('!user-145', '!user-100', '!user', 'sakai.synoptic.messagecenter', 2, 'Unread Messages and Forums', '1,1' );

create table MSGCNTR_TMP(
    PAGE_ID VARCHAR2(99),
    SITE_ID VARCHAR2(99)
);

insert into MSGCNTR_TMP
(   
    Select PAGE_ID, SITE_ID 
    from SAKAI_SITE_PAGE 
    where SITE_ID like '~%' 
    and TITLE = 'Home'
    and PAGE_ID not in (Select PAGE_ID from SAKAI_SITE_TOOL where REGISTRATION = 'sakai.synoptic.messagecenter')
);

insert into SAKAI_SITE_TOOL
(select SYS_GUID(), PAGE_ID, SITE_ID, 'sakai.synoptic.messagecenter', 2, 'Unread Messages and Forums', '1,1' from MSGCNTR_TMP);

drop table MSGCNTR_TMP;

-- MSGCNTR-25 .UIPermissionsManagerImpl - query did not return a unique result: 4 Error in catalina.out
alter table MFR_AREA_T add constraint MFR_AREA_CONTEXT_UUID_UNIQUE unique (CONTEXT_ID, TYPE_UUID);

-- MSGCNTR-148 unique constraint not created on MFR_PRIVATE_FORUM_T
-- If this alter query fails, use this select query to find duplicates and remove the duplicate:
-- select OWNER, surrogateKey, COUNT(OWNER) FROM MFR_PRIVATE_FORUM_T GROUP BY OWNER, surrogateKey HAVING COUNT(OWNER)>1;
-- CREATE UNIQUE INDEX MFR_PVT_FRM_OWNER ON  MFR_PRIVATE_FORUM_T (OWNER, surrogateKey); 

-- MSGCNTR-132 drop unused MC table columns
ALTER TABLE MFR_MESSAGE_T
DROP COLUMN GRADEBOOK;

ALTER TABLE MFR_MESSAGE_T
DROP COLUMN GRADEBOOK_ASSIGNMENT;

ALTER TABLE MFR_MESSAGE_T
DROP COLUMN GRADECOMMENT;

ALTER TABLE MFR_TOPIC_T
DROP COLUMN GRADEBOOK;

ALTER TABLE MFR_TOPIC_T
DROP COLUMN GRADEBOOK_ASSIGNMENT;

-- SAK-17428
alter table GB_CATEGORY_T
add (
  IS_EQUAL_WEIGHT_ASSNS number(1,0),
  IS_UNWEIGHTED number(1,0),
  CATEGORY_ORDER number(10,0),
  ENFORCE_POINT_WEIGHTING number(1,0)
);

alter table GB_GRADEBOOK_T
add (
  IS_EQUAL_WEIGHT_CATS number(1,0),
  IS_SCALED_EXTRA_CREDIT number(1,0),
  DO_SHOW_MEAN number(1,0),
  DO_SHOW_MEDIAN number(1,0),
  DO_SHOW_MODE number(1,0),
  DO_SHOW_RANK number(1,0),
  DO_SHOW_ITEM_STATS number(1,0)
);

alter table GB_GRADABLE_OBJECT_T
add (
  IS_NULL_ZERO number(1,0)
);
-- END SAK-17428

-- SAK-15311
ALTER TABLE GB_GRADABLE_OBJECT_T 
ADD ( 
SORT_ORDER number(10,0) 
); 

-- SAK-17679/SAK-18116
alter table EMAIL_TEMPLATE_ITEM add VERSION number(10,0) DEFAULT NULL;

-- SAM-818
alter table SAM_ITEM_T add PARTIAL_CREDIT_FLAG number(1,0) NULL; 
alter table SAM_PUBLISHEDITEM_T add PARTIAL_CREDIT_FLAG number(1,0) NULL; 
alter table SAM_ANSWER_T add PARTIAL_CREDIT float NULL; 
alter table SAM_PUBLISHEDANSWER_T add PARTIAL_CREDIT float NULL; 

-- SAM-676
create table SAM_GRADINGATTACHMENT_T (ATTACHMENTID number(19,0) not null, ATTACHMENTTYPE varchar2(255 char) not null, RESOURCEID varchar2(255 char), FILENAME varchar2(255 char), MIMETYPE varchar2(80 char), FILESIZE number(19,0), DESCRIPTION varchar2(4000 char), LOCATION varchar2(4000 char), ISLINK number(1,0), STATUS number(10,0) not null, CREATEDBY varchar2(255 char) not null, CREATEDDATE timestamp not null, LASTMODIFIEDBY varchar2(255 char) not null, LASTMODIFIEDDATE timestamp not null, ITEMGRADINGID number(19,0), primary key (ATTACHMENTID));
create index SAM_GA_ITEMGRADINGID_I on SAM_GRADINGATTACHMENT_T (ITEMGRADINGID);
alter table SAM_GRADINGATTACHMENT_T add constraint FK28156C6C4D7EA7B3 foreign key (ITEMGRADINGID) references SAM_ITEMGRADING_T;
create sequence SAM_GRADINGATTACHMENT_ID_S;

-- SAM-834
UPDATE SAM_ASSESSFEEDBACK_T 
SET FEEDBACKDELIVERY = 3, SHOWSTUDENTRESPONSE = 0, SHOWCORRECTRESPONSE = 0, SHOWSTUDENTSCORE = 0, SHOWSTUDENTQUESTIONSCORE = 0, 
SHOWQUESTIONLEVELFEEDBACK = 0, SHOWSELECTIONLEVELFEEDBACK = 0, SHOWGRADERCOMMENTS = 0, SHOWSTATISTICS = 0
WHERE ASSESSMENTID in (SELECT ID FROM SAM_ASSESSMENTBASE_T WHERE TYPEID='142' AND ISTEMPLATE=1);

-- SAK-17206
alter table POLL_OPTION add DELETED number(1,0) DEFAULT NULL;-- This is the Oracle Sakai 2.7.0 -> 2.7.1 conversion script
-- --------------------------------------------------------------------------------------------------------------------------------------
-- 
-- use this to convert a Sakai database from 2.7.0 to 2.7.1.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
-- Script insertion format
-- -- [TICKET] [short comment]
-- -- [comment continued] (repeat as necessary)
-- SQL statement
-- --------------------------------------------------------------------------------------------------------------------------------------

-- PRFL-94 remove twitter from preferences
-- NOTE: users will need to re-add their Twitter details to Profile2
alter table PROFILE_PREFERENCES_T drop column TWITTER_ENABLED;
alter table PROFILE_PREFERENCES_T drop column TWITTER_USERNAME;
alter table PROFILE_PREFERENCES_T drop column TWITTER_PASSWORD;

-- PRFL-94 add external integration table
-- NOTE: users will need to re-add their Twitter details to Profile2
create table PROFILE_EXTERNAL_INTEGRATION_T (
  USER_UUID varchar2(99) not null,
  TWITTER_TOKEN varchar2(255),
  TWITTER_SECRET varchar2(255),
  primary key (USER_UUID)
);
-- SAK-5742 create SAKAI_PERSON_T indexes  
create index SAKAI_PERSON_SURNAME_I on SAKAI_PERSON_T (SURNAME);
create index SAKAI_PERSON_ferpaEnabled_I on SAKAI_PERSON_T (ferpaEnabled);
create index SAKAI_PERSON_GIVEN_NAME_I on SAKAI_PERSON_T (GIVEN_NAME);
create index SAKAI_PERSON_UID_I on SAKAI_PERSON_T (UID_C);
-- This is the Oracle Sakai 2.7.1 -> 2.7.2 conversion script
-- --------------------------------------------------------------------------------------------------------------------------------------
-- 
-- use this to convert a Sakai database from 2.7.1 to 2.7.2.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
-- Script insertion format
-- -- [TICKET] [short comment]
-- -- [comment continued] (repeat as necessary)
-- SQL statement
-- --------------------------------------------------------------------------------------------------------------------------------------

-- KNL-725 use a datetype with timezone
-- Make sure sakai is stopped when running this.
-- Empty the SAKAI_CLUSTER, Oracle refuses to alter the table with records in it..
delete from SAKAI_CLUSTER;
-- Change the datatype
alter table SAKAI_CLUSTER modify (UPDATE_TIME timestamp with time zone);

/* PRFL-392 change row size of image URI columns */
alter table PROFILE_IMAGES_T modify RESOURCE_MAIN varchar2(4000);
alter table PROFILE_IMAGES_T modify RESOURCE_THUMB varchar2(4000);

alter table PROFILE_IMAGES_EXTERNAL_T modify URL_MAIN varchar2(4000); 
alter table PROFILE_IMAGES_EXTERNAL_T modify URL_THUMB varchar2(4000);

-- Clean up Samigo duplicate entries
create or replace PROCEDURE sam_clean_duplicate_responses AS
BEGIN
 declare
  cuenta_null INTEGER;
  cuenta_notnull INTEGER;
  gradingId INTEGER;
  tmp DATE;
begin
  dbms_output.enable(1000000);
 FOR r in ( 
    SELECT g.PUBLISHEDITEMID, g.AGENTID, g.ASSESSMENTGRADINGID, g.PUBLISHEDITEMTEXTID FROM SAM_ITEMGRADING_T g, sam_publisheditem_t i
    where g.publisheditemid = i.itemid and (i.typeid=1 or i.typeid=4)
    GROUP BY g.PUBLISHEDITEMID, g.AGENTID, g.ASSESSMENTGRADINGID, g.PUBLISHEDITEMTEXTID HAVING COUNT(*) > 1
  ) LOOP
    select count(*) into cuenta_null from sam_itemgrading_t g where
      g.agentid = r.agentid and
      g.publisheditemid = r.publisheditemid and
      g.assessmentgradingid = r.assessmentgradingid and
      g.publisheditemtextid = r.publisheditemtextid and
      g.submitteddate is null;
    select count(*) into cuenta_notnull from sam_itemgrading_t g where
      g.agentid = r.agentid and
      g.publisheditemid = r.publisheditemid and
      g.assessmentgradingid = r.assessmentgradingid and
      g.publisheditemtextid = r.publisheditemtextid and
      g.submitteddate is not null;
    if (cuenta_notnull = 1 AND cuenta_null = 1) then
      delete from sam_itemgrading_t where itemgradingid in (
        select g.itemgradingid from sam_itemgrading_t g where
        g.agentid = r.agentid and
        g.publisheditemid = r.publisheditemid and
        g.assessmentgradingid = r.assessmentgradingid and
        g.publisheditemtextid = r.publisheditemtextid and
        g.submitteddate is null
      );
      dbms_output.put_line('Eliminated: ' || r.PUBLISHEDITEMID || ', ' || r.AGENTID  || ', ' || r.ASSESSMENTGRADINGID || ', ' || r.PUBLISHEDITEMTEXTID);
    ELSIF (cuenta_notnull = 0 AND cuenta_null >= 2) THEN
      delete from sam_itemgrading_t where itemgradingid in (
        select MIN(g.itemgradingid) from sam_itemgrading_t g where
        g.agentid = r.agentid and
        g.publisheditemid = r.publisheditemid and
        g.assessmentgradingid = r.assessmentgradingid and
        g.publisheditemtextid = r.publisheditemtextid
        GROUP BY g.PUBLISHEDITEMID, g.AGENTID, g.ASSESSMENTGRADINGID, g.PUBLISHEDITEMTEXTID
      );
      dbms_output.put_line('Doubles without dates: ' || r.PUBLISHEDITEMID || ', ' || r.AGENTID  || ', ' || r.ASSESSMENTGRADINGID || ', ' || r.PUBLISHEDITEMTEXTID);
    ELSIF (cuenta_notnull = 1 AND cuenta_null >= 2) THEN
      delete from sam_itemgrading_t where itemgradingid in (
        select g.itemgradingid from sam_itemgrading_t g where
        g.agentid = r.agentid and
        g.publisheditemid = r.publisheditemid and
        g.assessmentgradingid = r.assessmentgradingid and
        g.publisheditemtextid = r.publisheditemtextid and
        g.submitteddate is null
      );
      dbms_output.put_line('Multiple values: ' || r.PUBLISHEDITEMID || ', ' || r.AGENTID  || ', ' || r.ASSESSMENTGRADINGID || ', ' || r.PUBLISHEDITEMTEXTID);
    ELSE
      select max(g.submitteddate) into tmp from sam_itemgrading_t g where
        g.agentid = r.agentid and
        g.publisheditemid = r.publisheditemid and
        g.assessmentgradingid = r.assessmentgradingid and
        g.publisheditemtextid = r.publisheditemtextid and
        g.submitteddate is not null;
      delete from sam_itemgrading_t where itemgradingid in (
        select g.itemgradingid from sam_itemgrading_t g where
        g.agentid = r.agentid and
        g.publisheditemid = r.publisheditemid and
        g.assessmentgradingid = r.assessmentgradingid and
        g.publisheditemtextid = r.publisheditemtextid and
        g.submitteddate != tmp
      );
      dbms_output.put_line('Ignored: ' || r.PUBLISHEDITEMID || ', ' || r.AGENTID  || ', ' || r.ASSESSMENTGRADINGID || ', ' || r.PUBLISHEDITEMTEXTID || ', ' || tmp);
    end if;
  end loop;
  commit;
  exception
    when VALUE_ERROR then
        dbms_output.put_line('Error: ');
end;
END sam_clean_duplicate_responses;

call sam_clean_duplicate_responses ();

SELECT * FROM USER_ERRORS WHERE NAME='SAM_CLEAN_DUPLICATE_RESPONSES' ORDER BY SEQUENCE, LINE;

-- This is the Oracle Sakai 2.7.1 -> 2.8.0 conversion script
-- --------------------------------------------------------------------------------------------------------------------------------------
-- 
-- use this to convert a Sakai database from 2.7.1 to 2.8.0.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
-- Script insertion format
-- -- [TICKET] [short comment]
-- -- [comment continued] (repeat as necessary)
-- SQL statement
-- --------------------------------------------------------------------------------------------------------------------------------------

-- SAK-8005
alter table ANNOUNCEMENT_MESSAGE add MESSAGE_ORDER INT;

drop index IE_ANNC_MSG_ATTRIB;
create index IE_ANNC_MSG_ATTRIB on ANNOUNCEMENT_MESSAGE (DRAFT, PUBVIEW, OWNER, MESSAGE_ORDER);

drop index ANNOUNCEMENT_MESSAGE_CDD;
create index ANNOUNCEMENT_MESSAGE_CDD on ANNOUNCEMENT_MESSAGE (CHANNEL_ID, MESSAGE_DATE, MESSAGE_ORDER, DRAFT); 

-- SAK-17821 Add additional fields to SakaiPerson
alter table SAKAI_PERSON_T add STAFF_PROFILE varchar2(4000);
alter table SAKAI_PERSON_T add UNIVERSITY_PROFILE_URL varchar2(4000);
alter table SAKAI_PERSON_T add ACADEMIC_PROFILE_URL varchar2(4000);
alter table SAKAI_PERSON_T add PUBLICATIONS varchar2(4000);
alter table SAKAI_PERSON_T add BUSINESS_BIOGRAPHY varchar2(4000);

-- Samigo
-- SAM-666
alter table SAM_ASSESSFEEDBACK_T add FEEDBACKCOMPONENTOPTION number(10,0) default null;
update SAM_ASSESSFEEDBACK_T set FEEDBACKCOMPONENTOPTION = 2;
alter table SAM_PUBLISHEDFEEDBACK_T add FEEDBACKCOMPONENTOPTION number(10,0) default null;
update SAM_PUBLISHEDFEEDBACK_T set FEEDBACKCOMPONENTOPTION = 2;
 
-- SAM-756 (SAK-16822): oracle only
alter table SAM_ITEMTEXT_T add (TEMP_CLOB_TEXT clob);
update SAM_ITEMTEXT_T SET TEMP_CLOB_TEXT = TEXT;
alter table SAM_ITEMTEXT_T drop column TEXT;
alter table SAM_ITEMTEXT_T rename column TEMP_CLOB_TEXT to TEXT;
     
alter table SAM_PUBLISHEDITEMTEXT_T add (TEMP_CLOB_TEXT clob);
update SAM_PUBLISHEDITEMTEXT_T SET TEMP_CLOB_TEXT = TEXT;
alter table SAM_PUBLISHEDITEMTEXT_T drop column TEXT;
alter table SAM_PUBLISHEDITEMTEXT_T rename column TEMP_CLOB_TEXT to TEXT;
     
alter table SAM_ITEMGRADING_T add (TEMP_CLOB_TEXT clob);
update SAM_ITEMGRADING_T SET TEMP_CLOB_TEXT = ANSWERTEXT;
alter table SAM_ITEMGRADING_T drop column ANSWERTEXT;
alter table SAM_ITEMGRADING_T rename column TEMP_CLOB_TEXT to ANSWERTEXT; 

-- SAM-971
alter table SAM_ASSESSMENTGRADING_T add LASTVISITEDPART number(10,0) default null;
alter table SAM_ASSESSMENTGRADING_T add LASTVISITEDQUESTION number(10,0) default null;

-- SAM-775
-- If you get an error when running this script, you will need to clean the duplicates first. Please refer to SAM-775.
create UNIQUE INDEX ASSESSMENTGRADINGID ON SAM_ITEMGRADING_T (ASSESSMENTGRADINGID, PUBLISHEDITEMID, PUBLISHEDITEMTEXTID, AGENTID, PUBLISHEDANSWERID);

-- Gradebook2 support
-- SAK-19080 / GRBK-736
alter table GB_GRADE_RECORD_T add USER_ENTERED_GRADE varchar2(255 CHAR);


--MSGCNTR-309
--Start and End dates on Forums and Topics
alter table MFR_AREA_T add (AVAILABILITY_RESTRICTED NUMBER(1,0));
update MFR_AREA_T set AVAILABILITY_RESTRICTED=0 where AVAILABILITY_RESTRICTED is NULL;
alter table MFR_AREA_T modify (AVAILABILITY_RESTRICTED NUMBER(1,0) default 0 not null );

alter table MFR_AREA_T add (AVAILABILITY NUMBER(1,0));
update MFR_AREA_T set AVAILABILITY=1 where AVAILABILITY is NULL;
alter table MFR_AREA_T modify (AVAILABILITY NUMBER(1,0) default 1 not null);

alter table MFR_AREA_T add (OPEN_DATE timestamp);

alter table MFR_AREA_T add (CLOSE_DATE timestamp);


alter table MFR_OPEN_FORUM_T add (AVAILABILITY_RESTRICTED NUMBER(1,0));
update MFR_OPEN_FORUM_T set AVAILABILITY_RESTRICTED=0 where AVAILABILITY_RESTRICTED is NULL;
alter table MFR_OPEN_FORUM_T modify (AVAILABILITY_RESTRICTED NUMBER(1,0) default 0 not null );

alter table MFR_OPEN_FORUM_T add (AVAILABILITY NUMBER(1,0));
update MFR_OPEN_FORUM_T set AVAILABILITY=1 where AVAILABILITY is NULL;
alter table MFR_OPEN_FORUM_T modify (AVAILABILITY NUMBER(1,0) default 1 not null );

alter table MFR_OPEN_FORUM_T add (OPEN_DATE timestamp);

alter table MFR_OPEN_FORUM_T add (CLOSE_DATE timestamp);

alter table MFR_TOPIC_T add (AVAILABILITY_RESTRICTED NUMBER(1,0));
update MFR_TOPIC_T set AVAILABILITY_RESTRICTED=0 where AVAILABILITY_RESTRICTED is NULL;
alter table MFR_TOPIC_T modify (AVAILABILITY_RESTRICTED NUMBER(1,0) default 0 not null );

alter table MFR_TOPIC_T add (AVAILABILITY NUMBER(1,0));
update MFR_TOPIC_T set AVAILABILITY=1 where AVAILABILITY is NULL;
alter table MFR_TOPIC_T modify (AVAILABILITY NUMBER(1,0) default 1 not null );

alter table MFR_TOPIC_T add (OPEN_DATE timestamp);

alter table MFR_TOPIC_T add (CLOSE_DATE timestamp);


--MSGCNTR-355
insert into MFR_TOPIC_T (ID, UUID, MODERATED, AUTO_MARK_THREADS_READ, SORT_INDEX, MUTABLE, TOPIC_DTYPE, VERSION, CREATED, CREATED_BY, MODIFIED, MODIFIED_BY, TITLE, SHORT_DESCRIPTION, EXTENDED_DESCRIPTION, TYPE_UUID, pf_surrogateKey, USER_ID)

  (select MFR_TOPIC_S.nextval as ID, sys_guid() as UUID, MODERATED, 0 as AUTO_MARK_THREADS_READ, 3 as SORT_INDEX, 0 as MUTABLE, TOPIC_DTYPE, 0 as VERSION, sysdate as CREATED, CREATED_BY, sysdate as MODIFIED, MODIFIED_BY, 'pvt_drafts' as TITLE, 'short-desc' as SHORT_DESCRIPTION, 'ext-desc' as EXTENDED_DESCRIPTION, TYPE_UUID, pf_surrogateKey, USER_ID from (
    select count(*) as c1, mtt.MODERATED, mtt.TOPIC_DTYPE, mtt.CREATED_BY, mtt.MODIFIED_BY, mtt.TYPE_UUID, mtt.pf_surrogateKey, mtt.USER_ID
    from MFR_PRIVATE_FORUM_T mpft, MFR_TOPIC_T mtt
    where mpft.ID = mtt.pf_surrogateKey and mpft.TYPE_UUID = mtt.TYPE_UUID
    Group By mtt.USER_ID, mtt.pf_surrogateKey, mtt.MODERATED, mtt.TOPIC_DTYPE, mtt.CREATED_BY, mtt.MODIFIED_BY, mtt.TYPE_UUID) s1
  where s1.c1 = 3);
    

--MSGCNTR-360
--Hibernate could have missed this index, if this fails, then the index may already be in the table
CREATE INDEX user_type_context_idx ON MFR_PVT_MSG_USR_T ( USER_ID, TYPE_UUID, CONTEXT_ID, READ_STATUS);

-- New column for Email Template service
-- SAK-18532/SAK-19522
alter table EMAIL_TEMPLATE_ITEM add EMAILFROM varchar2(255 CHAR);

-- SAK-18855
alter table POLL_POLL add POLL_IS_PUBLIC number(1,0);


-- Profile2 1.3-1.4 upgrade start

-- add company profile table and index (PRFL-224)
create table PROFILE_COMPANY_PROFILES_T (
  ID number(19,0) not null,
  USER_UUID varchar2(99 CHAR) not null,
  COMPANY_NAME varchar2(255 CHAR),
  COMPANY_DESCRIPTION varchar2(4000),
  COMPANY_WEB_ADDRESS varchar2(255 CHAR),
  primary key (ID)
);
create sequence COMPANY_PROFILES_S;
create index PROFILE_CP_USER_UUID_I on PROFILE_COMPANY_PROFILES_T (USER_UUID);
 
-- add message tables and indexes
create table PROFILE_MESSAGES_T (
  ID varchar2(36 CHAR) not null,
  FROM_UUID varchar2(99 CHAR) not null,
  MESSAGE_BODY varchar2(4000) not null,
  MESSAGE_THREAD varchar2(36 CHAR) not null,
  DATE_POSTED timestamp(6) not null,
  primary key (ID)
);

create table PROFILE_MESSAGE_PARTICIPANTS_T (
  ID number(19,0) not null,
  MESSAGE_ID varchar2(36 CHAR) not null,
  PARTICIPANT_UUID varchar2(99 CHAR) not null,
  MESSAGE_READ number(1,0) not null,
  MESSAGE_DELETED number(1,0) not null,
  primary key (ID)
);

create table PROFILE_MESSAGE_THREADS_T (
  ID varchar2(36 CHAR) not null,
  SUBJECT varchar2(255 CHAR) not null,
  primary key (ID)
);

create sequence PROFILE_MESSAGE_PARTICIPANTS_S;
create index PROFILE_M_THREAD_I on PROFILE_MESSAGES_T (MESSAGE_THREAD);
create index PROFILE_M_DATE_POSTED_I on PROFILE_MESSAGES_T (DATE_POSTED);
create index PROFILE_M_FROM_UUID_I on PROFILE_MESSAGES_T (FROM_UUID);
create index PROFILE_M_P_UUID_I on PROFILE_MESSAGE_PARTICIPANTS_T (PARTICIPANT_UUID);
create index PROFILE_M_P_MESSAGE_ID_I on PROFILE_MESSAGE_PARTICIPANTS_T (MESSAGE_ID);
create index PROFILE_M_P_DELETED_I on PROFILE_MESSAGE_PARTICIPANTS_T (MESSAGE_DELETED);
create index PROFILE_M_P_READ_I on PROFILE_MESSAGE_PARTICIPANTS_T (MESSAGE_READ);

-- add gallery table and indexes (PRFL-134, PRFL-171)
create table PROFILE_GALLERY_IMAGES_T (
  ID number(19,0) not null,
  USER_UUID varchar2(99 CHAR) not null,
  RESOURCE_MAIN varchar2(4000) not null,
  RESOURCE_THUMB varchar2(4000) not null,
  DISPLAY_NAME varchar2(255 CHAR) not null,
  primary key (ID)
);
create sequence GALLERY_IMAGES_S;
create index PROFILE_GI_USER_UUID_I on PROFILE_GALLERY_IMAGES_T (USER_UUID);

-- add social networking table (PRFL-252, PRFL-224)
create table PROFILE_SOCIAL_INFO_T (
  USER_UUID varchar2(99 CHAR) not null,
  FACEBOOK_URL varchar2(255 CHAR),
  LINKEDIN_URL varchar2(255 CHAR),
  MYSPACE_URL varchar2(255 CHAR),
  SKYPE_USERNAME varchar2(255 CHAR),
  TWITTER_URL varchar2(255 CHAR),
  primary key (USER_UUID)
);

-- add official image table
create table PROFILE_IMAGES_OFFICIAL_T (
  USER_UUID varchar2(99 CHAR) not null,
  URL varchar2(4000) not null,
  primary key (USER_UUID)
);

-- add kudos table
create table PROFILE_KUDOS_T (
  USER_UUID varchar2(99 CHAR) not null,
  SCORE number(10,0) not null,
  PERCENTAGE number(19,2) not null,
  DATE_ADDED timestamp(6) not null,
  primary key (USER_UUID)
);

-- add the new email message preference columns, default to 0, (PRFL-152, PRFL-186)
alter table PROFILE_PREFERENCES_T add EMAIL_MESSAGE_NEW number(1,0) default 0 not null;
alter table PROFILE_PREFERENCES_T add EMAIL_MESSAGE_REPLY number(1,0) default 0 not null;

-- add social networking privacy column (PRFL-285)
alter table PROFILE_PRIVACY_T add SOCIAL_NETWORKING_INFO number(10,0) default 0 not null;

-- add the new gallery column (PRFL-171)
alter table PROFILE_PRIVACY_T add MY_PICTURES number(10,0) default 0 not null;

-- add the new message column (PRFL-194), default to 1 (PRFL-593)
alter table PROFILE_PRIVACY_T add MESSAGES number(10,0) default 1 not null;

-- add the new businessInfo column (PRFL-210)
alter table PROFILE_PRIVACY_T add BUSINESS_INFO number(10,0) default 0 not null;

-- add the new staff and student info columns and copy old ACADEMIC_INFO value into them to maintain privacy (PRFL-267)
alter table PROFILE_PRIVACY_T add STAFF_INFO number(10,0) default 0 not null;
alter table PROFILE_PRIVACY_T add STUDENT_INFO number(10,0) default 0 not null;
update PROFILE_PRIVACY_T set STAFF_INFO = ACADEMIC_INFO;
update PROFILE_PRIVACY_T set STUDENT_INFO = ACADEMIC_INFO;
alter table PROFILE_PRIVACY_T drop column ACADEMIC_INFO;

-- add the new useOfficialImage column (PRFL-90)
alter table PROFILE_PREFERENCES_T add USE_OFFICIAL_IMAGE number(1,0) default 0 not null;

-- remove search privacy setting (PRFL-293)
alter table PROFILE_PRIVACY_T drop column SEARCH;

-- add kudos preference (PRFL-336)
alter table PROFILE_PREFERENCES_T add SHOW_KUDOS number(1,0) default 1 not null;

-- add kudos privacy (PRFL-336)
alter table PROFILE_PRIVACY_T add MY_KUDOS number(10,0) default 0 not null;

-- add gallery feed preference (PRFL-382)
alter table PROFILE_PREFERENCES_T add SHOW_GALLERY_FEED number(1,0) default 1 not null;

-- adjust size of the profile images resource uri columns (PRFL-392)
alter table PROFILE_IMAGES_T modify RESOURCE_MAIN varchar2(4000);
alter table PROFILE_IMAGES_T modify RESOURCE_THUMB varchar2(4000);
alter table PROFILE_IMAGES_EXTERNAL_T modify URL_MAIN varchar2(4000);
alter table PROFILE_IMAGES_EXTERNAL_T modify URL_THUMB varchar2(4000);

-- add indexes to commonly searched columns (PRFL-540)
create index PROFILE_FRIENDS_CONFIRMED_I on PROFILE_FRIENDS_T (CONFIRMED);
create index PROFILE_STATUS_DATE_ADDED_I on PROFILE_STATUS_T (DATE_ADDED);

-- Profile2 1.3-1.4 upgrade end

-- SHORTURL-26 shortenedurlservice 1.0
create table URL_RANDOMISED_MAPPINGS_T (
  ID number(19,0) not null,
  TINY varchar2(255 CHAR) not null,
  URL varchar2(4000) not null,
  primary key (ID)
);

create index URL_INDEX on URL_RANDOMISED_MAPPINGS_T (URL);
create index KEY_INDEX on URL_RANDOMISED_MAPPINGS_T (TINY);
create sequence URL_RANDOMISED_MAPPINGS_S;

-- SAK-18864/SAK-19951/SAK-19965 added create statement for scheduler_trigger_events
create table SCHEDULER_TRIGGER_EVENTS (
  UUID varchar2(36 CHAR) NOT NULL,
  EVENTTYPE varchar2(255 CHAR) NOT NULL,
  JOBNAME varchar2(255 CHAR) NOT NULL,
  TRIGGERNAME varchar2(255 CHAR),
  EVENTTIME timestamp NOT NULL,
  MESSAGE clob,
  primary key (UUID)
);

-- STAT-241: Tracking of time spent in site
create table SST_PRESENCES (
  ID number(19,0) not null,
  SITE_ID varchar2(99 char) not null,
  USER_ID varchar2(99 char) not null,
  P_DATE date not null,
  DURATION number(19,0) default 0 not null,
  LAST_VISIT_START_TIME timestamp default null,
  primary key (ID)
);

-- STAT-286: missing SiteStats sequence
create sequence SST_PRESENCE_ID;

-- SAK-20076: missing Sitestats indexes
create index SST_PRESENCE_DATE_IX on SST_PRESENCES (P_DATE);
create index SST_PRESENCE_USER_ID_IX on SST_PRESENCES (USER_ID);
create index SST_PRESENCE_SITE_ID_IX on SST_PRESENCES (SITE_ID);
create index SST_PRESENCE_SUD_ID_IX on SST_PRESENCES (SITE_ID, USER_ID, P_DATE);

-- KNL-563: dynamic bundling loading
CREATE TABLE SAKAI_MESSAGE_BUNDLE(
        ID NUMBER(19) NOT NULL,
        MODULE_NAME VARCHAR2(255 CHAR) NOT NULL,
        BASENAME VARCHAR2(255 CHAR) NOT NULL,
        PROP_NAME VARCHAR2(255 CHAR) NOT NULL,
        PROP_VALUE VARCHAR2(4000 CHAR),
        LOCALE VARCHAR2(255 CHAR) NOT NULL,
        DEFAULT_VALUE VARCHAR2(4000 CHAR) NOT NULL,
        PRIMARY KEY (ID)
);
create sequence SAKAI_MESSAGEBUNDLE_S; 

create sequence VALIDATIONACCOUNT_ITEM_ID_SEQ;-- SAK-20005 
-- Starting up sakai-2.8.0 in order to populate an empty Oracle database (auto.ddl=true) can result 
-- in certain tools relying on Hibernate 3.2.7.ga to generate indexes to fail to do so.

-- Check your database and run this script if indexes are missing.

-- Note: create index statements that have been commented out have been included for review purposes.

-- --------------------------------------------------------------------------------------------------------------------------------------
--
-- Script insertion format
-- -- [TICKET] [short comment]
-- -- [comment continued] (repeat as necessary)
-- SQL statement
-- --------------------------------------------------------------------------------------------------------------------------------------

-- MSGCNTR-360
create index user_type_context_idx ON MFR_PVT_MSG_USR_T ( USER_ID, TYPE_UUID, CONTEXT_ID, READ_STATUS);

-- PRFL-224
create index PROFILE_CP_USER_UUID_I on PROFILE_COMPANY_PROFILES_T (USER_UUID);
create index PROFILE_M_THREAD_I on PROFILE_MESSAGES_T (MESSAGE_THREAD);
create index PROFILE_M_DATE_POSTED_I on PROFILE_MESSAGES_T (DATE_POSTED);
create index PROFILE_M_FROM_UUID_I on PROFILE_MESSAGES_T (FROM_UUID);
create index PROFILE_M_P_UUID_I on PROFILE_MESSAGE_PARTICIPANTS_T (PARTICIPANT_UUID);
create index PROFILE_M_P_MESSAGE_ID_I on PROFILE_MESSAGE_PARTICIPANTS_T (MESSAGE_ID);
create index PROFILE_M_P_DELETED_I on PROFILE_MESSAGE_PARTICIPANTS_T (MESSAGE_DELETED);
create index PROFILE_M_P_READ_I on PROFILE_MESSAGE_PARTICIPANTS_T (MESSAGE_READ);

-- PRFL-134, PRFL-171
create index PROFILE_GI_USER_UUID_I on PROFILE_GALLERY_IMAGES_T (USER_UUID);

-- PRFL-540
create index PROFILE_FRIENDS_CONFIRMED_I on PROFILE_FRIENDS_T (CONFIRMED);
create index PROFILE_STATUS_DATE_ADDED_I on PROFILE_STATUS_T (DATE_ADDED);

-- SAM-775 if you get an error when running this script, you will need to clean the duplicates first. See SAM-775 for details.
-- create UNIQUE INDEX ASSESSMENTGRADINGID ON SAM_ITEMGRADING_T (ASSESSMENTGRADINGID, PUBLISHEDITEMID, PUBLISHEDITEMTEXTID, AGENTID, PUBLISHEDANSWERID);

-- SAK-20076 missing Sitestats indexes
create index SST_PRESENCE_DATE_IX on SST_PRESENCES (P_DATE);
create index SST_PRESENCE_USER_ID_IX on SST_PRESENCES (USER_ID);
create index SST_PRESENCE_SITE_ID_IX on SST_PRESENCES (SITE_ID);
create index SST_PRESENCE_SUD_ID_IX on SST_PRESENCES (SITE_ID, USER_ID, P_DATE);

-- SHORTURL-27
create index URL_INDEX on URL_RANDOMISED_MAPPINGS_T (URL);
create index KEY_INDEX on URL_RANDOMISED_MAPPINGS_T (TINY);
-- This is the Oracle Sakai 2.8.0 -> 2.8.1 conversion script
-- --------------------------------------------------------------------------------------------------------------------------------------
-- 
-- use this to convert a Sakai database from 2.8.0 to 2.8.1.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
-- Script insertion format
-- -- [TICKET] [short comment]
-- -- [comment continued] (repeat as necessary)
-- SQL statement
-- --------------------------------------------------------------------------------------------------------------------------------------

-- SAK-8005/SAK-20560
-- The conversion for SAK-8005 in 2.8.0 conversion do not handle the message_order data in the xml clob
-- The next three statements are needed if the xml field is of type Long 
-- alter table announcement_message modify xml clob; 
-- select 'alter index '||index_name||' rebuild online;' from user_indexes where status = 'INVALID' or status = 'UNUSABLE'; 
-- execute all resulting statements from the previous step 
update ANNOUNCEMENT_MESSAGE set MESSAGE_ORDER='1', XML=replace(XML, ' subject=', ' message_order="1" subject=') where MESSAGE_ORDER is null; 

-- KNL-563 correction
-- sakai-2.8.0 conversion script set DEFAULT_VALUE incorrectly to not null.  Set to null to match Hibernate mapping.
alter table SAKAI_MESSAGE_BUNDLE modify DEFAULT_VALUE null;

-- KNL-725 use a datetype with timezone
-- Make sure sakai is stopped when running this.
-- Empty the SAKAI_CLUSTER, Oracle refuses to alter the table with records in it..
delete from SAKAI_CLUSTER;
-- Change the datatype
alter table SAKAI_CLUSTER modify (UPDATE_TIME timestamp with time zone); 

-- SAK-20717 mailarchive messages need updating with new field
update MAILARCHIVE_MESSAGE set XML=replace(XML, ' mail-from="', ' message_order="1" mail-from="') where XML not like '% message_order="1" %';

-- SAK-20926 / PRFL-392 fix null status
alter table PROFILE_IMAGES_T modify RESOURCE_MAIN varchar2(4000);
alter table PROFILE_IMAGES_T modify RESOURCE_THUMB varchar2(4000);
alter table PROFILE_IMAGES_EXTERNAL_T modify URL_MAIN varchar2(4000);
alter table PROFILE_IMAGES_EXTERNAL_T modify URL_THUMB varchar2(4000);

-- SAK-20598 change column type to mediumtext (On Oracle we need to copy the column content first though)
alter table SAKAI_PERSON_T add (TMP_NOTES clob);
alter table SAKAI_PERSON_T add (TMP_FAVOURITE_BOOKS clob);
alter table SAKAI_PERSON_T add (TMP_FAVOURITE_TV_SHOWS clob);
alter table SAKAI_PERSON_T add (TMP_FAVOURITE_MOVIES clob);
alter table SAKAI_PERSON_T add (TMP_FAVOURITE_QUOTES clob);
alter table SAKAI_PERSON_T add (TMP_EDUCATION_COURSE clob);
alter table SAKAI_PERSON_T add (TMP_EDUCATION_SUBJECTS clob);
alter table SAKAI_PERSON_T add (TMP_STAFF_PROFILE clob);
alter table SAKAI_PERSON_T add (TMP_UNIVERSITY_PROFILE_URL clob);
alter table SAKAI_PERSON_T add (TMP_ACADEMIC_PROFILE_URL clob);
alter table SAKAI_PERSON_T add (TMP_PUBLICATIONS clob);
alter table SAKAI_PERSON_T add (TMP_BUSINESS_BIOGRAPHY clob);

update SAKAI_PERSON_T set TMP_NOTES = NOTES;
update SAKAI_PERSON_T set TMP_FAVOURITE_BOOKS = FAVOURITE_BOOKS;
update SAKAI_PERSON_T set TMP_FAVOURITE_TV_SHOWS = FAVOURITE_TV_SHOWS;
update SAKAI_PERSON_T set TMP_FAVOURITE_MOVIES = FAVOURITE_MOVIES;
update SAKAI_PERSON_T set TMP_FAVOURITE_QUOTES = FAVOURITE_QUOTES;
update SAKAI_PERSON_T set TMP_EDUCATION_COURSE = EDUCATION_COURSE;
update SAKAI_PERSON_T set TMP_EDUCATION_SUBJECTS = EDUCATION_SUBJECTS;
update SAKAI_PERSON_T set TMP_STAFF_PROFILE = STAFF_PROFILE;
update SAKAI_PERSON_T set TMP_UNIVERSITY_PROFILE_URL = UNIVERSITY_PROFILE_URL;
update SAKAI_PERSON_T set TMP_ACADEMIC_PROFILE_URL = ACADEMIC_PROFILE_URL;
update SAKAI_PERSON_T set TMP_PUBLICATIONS = PUBLICATIONS;
update SAKAI_PERSON_T set TMP_BUSINESS_BIOGRAPHY = BUSINESS_BIOGRAPHY;

alter table SAKAI_PERSON_T drop column NOTES;
alter table SAKAI_PERSON_T drop column FAVOURITE_BOOKS;
alter table SAKAI_PERSON_T drop column FAVOURITE_TV_SHOWS;
alter table SAKAI_PERSON_T drop column FAVOURITE_MOVIES;
alter table SAKAI_PERSON_T drop column FAVOURITE_QUOTES;
alter table SAKAI_PERSON_T drop column EDUCATION_COURSE;
alter table SAKAI_PERSON_T drop column EDUCATION_SUBJECTS;
alter table SAKAI_PERSON_T drop column STAFF_PROFILE;
alter table SAKAI_PERSON_T drop column UNIVERSITY_PROFILE_URL;
alter table SAKAI_PERSON_T drop column ACADEMIC_PROFILE_URL;
alter table SAKAI_PERSON_T drop column PUBLICATIONS;
alter table SAKAI_PERSON_T drop column BUSINESS_BIOGRAPHY;

alter table SAKAI_PERSON_T rename column TMP_NOTES to NOTES;
alter table SAKAI_PERSON_T rename column TMP_FAVOURITE_BOOKS to FAVOURITE_BOOKS;
alter table SAKAI_PERSON_T rename column TMP_FAVOURITE_TV_SHOWS to FAVOURITE_TV_SHOWS;
alter table SAKAI_PERSON_T rename column TMP_FAVOURITE_MOVIES to FAVOURITE_MOVIES;
alter table SAKAI_PERSON_T rename column TMP_FAVOURITE_QUOTES to FAVOURITE_QUOTES;
alter table SAKAI_PERSON_T rename column TMP_EDUCATION_COURSE to EDUCATION_COURSE;
alter table SAKAI_PERSON_T rename column TMP_EDUCATION_SUBJECTS to EDUCATION_SUBJECTS;
alter table SAKAI_PERSON_T rename column TMP_STAFF_PROFILE to STAFF_PROFILE;
alter table SAKAI_PERSON_T rename column TMP_UNIVERSITY_PROFILE_URL to UNIVERSITY_PROFILE_URL;
alter table SAKAI_PERSON_T rename column TMP_ACADEMIC_PROFILE_URL to ACADEMIC_PROFILE_URL;
alter table SAKAI_PERSON_T rename column TMP_PUBLICATIONS to PUBLICATIONS;
alter table SAKAI_PERSON_T rename column TMP_BUSINESS_BIOGRAPHY to BUSINESS_BIOGRAPHY;
-- end SAK-20598
-- This is the Oracle Sakai 2.8.1 -> 2.8.2 conversion script
-- --------------------------------------------------------------------------------------------------------------------------------------
-- 
-- use this to convert a Sakai database from 2.8.1 to 2.8.2.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
-- Script insertion format
-- -- [TICKET] [short comment]
-- -- [comment continued] (repeat as necessary)
-- SQL statement
-- --------------------------------------------------------------------------------------------------------------------------------------


-- PRFL-687 incorrect default value for messages setting
update PROFILE_PRIVACY_T set MESSAGES=1 where MESSAGES=0;

-- Tables that were autoddled on unidev but aren't in the upgrade scripts

CREATE TABLE "TAGGABLE_LINK"
  ( "LINK_ID" VARCHAR2(36 CHAR) NOT NULL ENABLE, 
    "VERSION" NUMBER(10,0) NOT NULL ENABLE, 
    "ACTIVITY_REF" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
    "TAG_CRITERIA_REF" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
    "RUBRIC" CLOB, 
    "RATIONALE" CLOB, 
    "EXPORT_STRING" NUMBER(10,0) NOT NULL ENABLE, 
    "VISIBLE" NUMBER(1,0) NOT NULL ENABLE, 
    "LOCKED" NUMBER(1,0) NOT NULL ENABLE, 
     PRIMARY KEY ("LINK_ID")
  );

CREATE TABLE "ENTITY_PROPERTIES" 
  ( "ID" NUMBER(20,0) NOT NULL ENABLE, 
    "ENTITYREF" VARCHAR2(255) NOT NULL ENABLE, 
    "ENTITYPREFIX" VARCHAR2(255) NOT NULL ENABLE, 
    "PROPERTYNAME" VARCHAR2(255) NOT NULL ENABLE, 
    "PROPERTYVALUE" CLOB NOT NULL ENABLE, 
     PRIMARY KEY ("ID")
  );

CREATE TABLE "ENTITY_TAG_APPLICATIONS" 
  ( "ID" NUMBER(20,0) NOT NULL ENABLE, 
    "ENTITYREF" VARCHAR2(255) NOT NULL ENABLE, 
    "ENTITYPREFIX" VARCHAR2(255) NOT NULL ENABLE, 
    "TAG" VARCHAR2(255) NOT NULL ENABLE, 
    PRIMARY KEY ("ID")
  );

-- SAK-19047
update ANNOUNCEMENT_MESSAGE set MESSAGE_ORDER='1', XML=REPLACE(XML, ' subject=', ' message_order="1" subject=') WHERE MESSAGE_ORDER is null;

-- Case insensitive EIDs
delete from SAKAI_USER_ID_MAP where EID in (select lower(e1.EID) from SAKAI_USER_ID_MAP e1, SAKAI_USER_ID_MAP e2 where e1.EID = upper(e1.EID) and lower(e1.EID) = e2.EID);
update SAKAI_USER_ID_MAP set EID=lower(EID);

-- Gradebook 2
alter table GB_GRADEBOOK_T
add (
	DO_SHOW_STATISTICS_CHART number(1,0)
);

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_ID'
where PROPERTY_NAME='ID';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_NM'
where PROPERTY_NAME='NAME';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='D_WGHT'
where PROPERTY_NAME='WEIGHT';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_EQL_WGHT'
where PROPERTY_NAME='EQUAL_WEIGHT';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_X_CRDT'
where PROPERTY_NAME='EXTRA_CREDIT';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_INCLD'
where PROPERTY_NAME='INCLUDED';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_RMVD'
where PROPERTY_NAME='REMOVED';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_GB_NAME'
where PROPERTY_NAME='GRADEBOOK';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='I_DRP_LWST'
where PROPERTY_NAME='DROP_LOWEST';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_CTGRY_NAME'
where PROPERTY_NAME='CATEGORY_NAME';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='L_CTGRY_ID'
where PROPERTY_NAME='CATEGORY_ID';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='W_DUE'
where PROPERTY_NAME='DUE_DATE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='D_PNTS'
where PROPERTY_NAME='POINTS';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_PNTS'
where PROPERTY_NAME='POINTS_STRING';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_RLSD'
where PROPERTY_NAME='RELEASED';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_NLLS_ZEROS'
where PROPERTY_NAME='NULLSASZEROS';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_SOURCE'
where PROPERTY_NAME='SOURCE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_ITM_TYPE'
where PROPERTY_NAME='ITEM_TYPE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='D_PCT_GRD'
where PROPERTY_NAME='PERCENT_COURSE_GRADE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_PCT_GRD'
where PROPERTY_NAME='PERCENT_COURSE_GRADE_STRING';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='D_PCT_CTGRY'
where PROPERTY_NAME='PERCENT_CATEGORY';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_PCT_CTGRY'
where PROPERTY_NAME='PERCENT_CATEGORY_STRING';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_IS_PCT'
where PROPERTY_NAME='IS_PERCENTAGE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='O_LRNR_KEY'
where PROPERTY_NAME='STUDENT_MODEL_KEY';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='L_ITM_ID'
where PROPERTY_NAME='ASSIGNMENT_ID';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_NM'
where PROPERTY_NAME='NAME';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_DATA_TYPE'
where PROPERTY_NAME='DATA_TYPE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='C_CTGRY_TYPE'
where PROPERTY_NAME='CATEGORYTYPE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='G_GRD_TYPE'
where PROPERTY_NAME='GRADETYPE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_REL_GRDS'
where PROPERTY_NAME='RELEASEGRADES';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_REL_ITMS'
where PROPERTY_NAME='RELEASEITEMS';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='I_SRT_ORDR'
where PROPERTY_NAME='ITEM_ORDER';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='L_GRD_SCL_ID'
where PROPERTY_NAME='GRADESCALEID';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_RECALC_PTS'
where PROPERTY_NAME='DO_RECALCULATE_POINTS';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_WT_BY_PTS'
where PROPERTY_NAME='ENFORCE_POINT_WEIGHTING';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_SHW_MEAN'
where PROPERTY_NAME='SHOWMEAN';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_SHW_MEDIAN'
where PROPERTY_NAME='SHOWMEDIAN';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_SHW_MODE'
where PROPERTY_NAME='SHOWMODE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_SHW_RANK'
where PROPERTY_NAME='SHOWRANK';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_SHW_ITM_STATS'
where PROPERTY_NAME='SHOWITEMSTATS';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='A_CHILDREN'
where PROPERTY_NAME='CHILDREN';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_ACTIVE'
where PROPERTY_NAME='IS_ACTIVE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_EDITABLE'
where PROPERTY_NAME='IS_EDITABLE';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_CHKD'
where PROPERTY_NAME='IS_CHECKED';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='S_PARENT'
where PROPERTY_NAME='PARENT_NAME';

update GB_ACTION_RECORD_PROPERTY_T
set PROPERTY_NAME='B_ALW_SCL_X_CRDT'
where PROPERTY_NAME='ALLOW_SCALED_EXTRA_CREDIT';

commit;

-- melete

ALTER TABLE melete_user_preference add LTI_CHOICE number(1);
alter table melete_user_preference add LICENSE_CODE number(11);
alter table melete_user_preference add CC_LICENSE_URL varchar2(275);
alter table melete_user_preference add REQ_ATTR number(1);
alter table melete_user_preference add ALLOW_CMRCL number(1);
alter table melete_user_preference add ALLOW_MOD number(11);
alter table melete_user_preference add COPYRIGHT_OWNER varchar2(255);
alter table melete_user_preference add COPYRIGHT_YEAR varchar2(25);

alter table melete_module_shdates add START_EVENT_ID varchar2(99);
alter table melete_module_shdates add END_EVENT_ID varchar2(99);
alter table melete_module_shdates add ADDTO_SCHEDULE number(1);

alter table melete_resource modify CC_LICENSE_URL varchar2(275);
alter table melete_resource modify COPYRIGHT_OWNER varchar2(255);

drop table melete_migrate_status;
 
CREATE TABLE melete_bookmark (
   BOOKMARK_ID NUMBER(11) DEFAULT '0' NOT NULL,
   SECTION_ID NUMBER(11) DEFAULT '0' NOT NULL,
   USER_ID VARCHAR2(99) DEFAULT NULL,
   SITE_ID VARCHAR2(99) DEFAULT NULL,
   TITLE VARCHAR2(99) DEFAULT '' NOT NULL,
   NOTES CLOB,
   LAST_VISITED NUMBER(1) DEFAULT NULL,
   PRIMARY KEY (BOOKMARK_ID),
   CONSTRAINT FK_MB_MS FOREIGN KEY (SECTION_ID) REFERENCES melete_section(SECTION_ID)
); 

alter table melete_resource modify COPYRIGHT_YEAR varchar2(255);
alter table melete_user_preference modify COPYRIGHT_YEAR varchar2(255); 

CREATE TABLE melete_special_access (
  ACCESS_ID number(11) default '0',
  MODULE_ID number(11) default '0',
  USERS CLOB NOT NULL,
  START_DATE timestamp default NULL,
  END_DATE timestamp default NULL,
  PRIMARY KEY (ACCESS_ID),
  CONSTRAINT FK_MSA_MM FOREIGN KEY(MODULE_ID) REFERENCES melete_module(MODULE_ID)
); 

