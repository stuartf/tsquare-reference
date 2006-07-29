-- This is the MySQL Sakai 2.2.0 -> 2.2.1 conversion script
----------------------------------------------------------------------------------------------------------------------------------------
--
-- use this to convert a Sakai database from 2.2.0 to 2.2.1.  Run this before you run your first app server.
-- auto.ddl does not need to be enabled in your app server - this script takes care of all new TABLEs, changed TABLEs, and changed data.
--
----------------------------------------------------------------------------------------------------------------------------------------

-- OSP-1607
-- http://bugs.osportfolio.org/jira/browse/OSP-1607
-- Increasing the size of fields that hold a site id to 99.  Some were not specifying a length and would result in a length of 255.  I'm leaving those alone for now.

alter table osp_guidance modify column site_id varchar(99);
alter table osp_review modify column site_id varchar(99);
alter table osp_style modify column site_id varchar(99);
alter table osp_site_tool modify column site_id varchar(99);
alter table osp_presentation_template modify column site_id varchar(99);
alter table osp_presentation modify column site_id varchar(99);
alter table osp_presentation_layout modify column site_id varchar(99);
alter table osp_wizard modify column site_id varchar(99);

-- SAK-5595
-- http://bugs.sakaiproject.org/jira/browse/SAK-5595
-- Conversion script error: missing column DURATION in SAM_MEDIA_T

alter table SAM_MEDIA_T add column DURATION varchar(36); 
