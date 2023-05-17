*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-75</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.USER.ACT.LOG.CRM
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for the Following
* versions of REDO.ISSUE.CLAIMS,PROCESS , REDO.ISSUE.CLAIMS,SPECIAL , REDO.ISSUE.REQUESTS,PROCESS , REDO.ISSUE.REQUESTS,SPECIAL & REDO.ISSUE.COMPLAINTS,PROCESS
* It is used to update the REDO.USER.ACT.LOG.CRM table when the user is open and closed without committing the record for maintaining log details.
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.CHK.USER.ACT.LOG.CRM
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO               REFERENCE         DESCRIPTION
* 08-09-2011     Sudharsanan S      PACS00115273    Initial Creation.
* -----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.ISSUE.CLAIMS
$INSERT I_F.REDO.ISSUE.REQUESTS
$INSERT I_F.REDO.ISSUE.COMPLAINTS
$INSERT I_F.REDO.USER.ACT.LOG.CRM
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------
  FN.REDO.ISSUE.CLAIMS='F.REDO.ISSUE.CLAIMS'
  F.REDO.ISSUE.CLAIMS = ''
  CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

  FN.REDO.ISSUE.REQUESTS = 'F.REDO.ISSUE.REQUESTS'
  F.REDO.ISSUE.REQUESTS = ''
  CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)

  FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
  F.REDO.ISSUE.COMPLAINTS = ''
  CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

  FN.REDO.USER.ACT.LOG.CRM = 'F.REDO.USER.ACT.LOG.CRM'
  F.REDO.USER.ACT.LOG.CRM = ''
  CALL OPF(FN.REDO.USER.ACT.LOG.CRM,F.REDO.USER.ACT.LOG.CRM)

  VAR.USER = OPERATOR ; FLAG =  ''

  RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
* This is the main para used to check and update the REDO.USER.AUT.LOG.CRM table
  GOSUB GET.VALUES
  GOSUB GET.APP.VALUES
  GOSUB UPDATE.USER.ACT.LOG.CRM
  RETURN
*---------------------------------------------------------------------------------------
GET.VALUES:
*----------------------------------------------------------------------------------------
*This para is used to get the values of REDO.USER.AUT.LOG.CRM for the current user
  CALL F.READ(FN.REDO.USER.ACT.LOG.CRM,VAR.USER,R.USER.ACT.LOG.CRM,F.REDO.USER.ACT.LOG.CRM,USER.ERR)
  Y.CASE.ID=R.USER.ACT.LOG.CRM<USER.ACT.CASE.ID>
  Y.CASE.TYPE=R.USER.ACT.LOG.CRM<USER.ACT.CASE.TYPE>
  Y.CUST.ID=R.USER.ACT.LOG.CRM<USER.ACT.CUSTOMER.ID>
  Y.DATE =R.USER.ACT.LOG.CRM<USER.ACT.DATE>
  CHANGE VM TO FM IN Y.CASE.ID
  FM.CNT = DCOUNT(Y.CASE.ID,FM)
  RETURN
*----------------------------------------------------------------------------------------
GET.APP.VALUES:
*---------------------------------------------------------------------------------------
*This para is used to get the TYPE and CUSTOMER.CODE field values based on application
  BEGIN CASE
  CASE APPLICATION EQ 'REDO.ISSUE.CLAIMS'
    VAR.CASE.TYPE = R.NEW(ISS.CL.TYPE)
    VAR.CUST.CODE = R.NEW(ISS.CL.CUSTOMER.CODE)
  CASE APPLICATION EQ 'REDO.ISSUE.REQUESTS'
    VAR.CASE.TYPE = R.NEW(ISS.REQ.TYPE)
    VAR.CUST.CODE = R.NEW(ISS.REQ.CUSTOMER.CODE)
  CASE APPLICATION EQ 'REDO.ISSUE.COMPLAINTS'
    VAR.CASE.TYPE = R.NEW(ISS.COMP.TYPE)
    VAR.CUST.CODE = R.NEW(ISS.COMP.CUSTOMER.CODE)
  END CASE
  RETURN
*---------------------------------------------------------------------------------------
UPDATE.USER.ACT.LOG.CRM:
*-----------------------------------------------------------------------------------------
  IF NOT(R.USER.ACT.LOG.CRM) THEN
    FM.CNT = 0
    GOSUB UPDATE.VALUES.LOG
  END ELSE
    GOSUB CHECK.EXISTING.VALUES
  END
  RETURN
*-----------------------------------------------------------------------------------------------------------
UPDATE.VALUES.LOG:
*------------------------------------------------------------------------------------------------------------
*This para is used to update the values in REDO.USER.ACT.LOG.CRM table
  ADD.POS = FM.CNT+1
  R.USER.ACT.LOG.CRM<USER.ACT.CASE.ID,ADD.POS> = ID.NEW
  R.USER.ACT.LOG.CRM<USER.ACT.CASE.TYPE,ADD.POS> = VAR.CASE.TYPE
  R.USER.ACT.LOG.CRM<USER.ACT.CUSTOMER.ID,ADD.POS> = VAR.CUST.CODE
  R.USER.ACT.LOG.CRM<USER.ACT.DATE,ADD.POS> = TODAY
  WRITE R.USER.ACT.LOG.CRM ON F.REDO.USER.ACT.LOG.CRM, VAR.USER ON ERROR
  END
  RETURN
*--------------------------------------------------------------------------------------------------------------
CHECK.EXISTING.VALUES:
*---------------------------------------------------------------------------------------------------------------
*If user record is already available in the table then checks condition for updating the details.
  CNT = 1
  LOOP
  WHILE CNT LE FM.CNT
    LOCATE ID.NEW IN Y.CASE.ID,CNT SETTING POS1 THEN
      IF TODAY NE Y.DATE<1,POS1> THEN
        GOSUB UPDATE.VALUES.LOG
        CNT = FM.CNT+1  ; FLAG = 1
      END ELSE
        IF VAR.CASE.TYPE NE Y.CASE.TYPE<1,POS1> THEN
          GOSUB UPDATE.VALUES.LOG
          CNT = FM.CNT+1  ; FLAG = 1
        END
      END
      IF NOT(FLAG) THEN
        CNT = POS1+1
      END
    END ELSE
      GOSUB UPDATE.VALUES.LOG
      CNT = FM.CNT+1
    END
  REPEAT
  RETURN
*---------------------------------------------------------------------------------------------------------------
END
