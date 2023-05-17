*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-100</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.RISK.LIMIT.PARAM.VALIDATE
*-----------------------------------------------------------------------------
*!** Template FOR validation routines
* @author:    anoriega@temenos.com
* @stereotype validator:
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 31/March/2011 - BG_100011433
*                 Creation Routine
* 13/April/2011 - vpanchi
*                 Modify for various applications
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
  GOSUB INITIALISE
  GOSUB PROCESS.MESSAGE
  RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
* TODO - Add the validation code here.
* Set AF, AV and AS to the field, multi value and sub value and invoke STORE.END.ERROR
* Set ETEXT to point to the EB.ERROR.TABLE

*      AF = MY.FIELD.NAME                 <== Name of the field
*      ETEXT = 'EB-EXAMPLE.ERROR.CODE'    <== The error code
*      CALL STORE.END.ERROR               <== Needs to be invoked per error
*
*
  Y.CNT.APP  = DCOUNT(R.NEW(REDO.CCRG.RLP.APPLICATION),VM)
  Y.CNT.FLDS = DCOUNT(R.NEW(REDO.CCRG.RLP.FIELD.NO),SM)

* If the ID is RISK.INDIV.SECURED or RISK.INDIV.UNSECURED or RISK.GROUP.TOTAL or RISK.INDIV.TOTAL,
* is not required to input the conditions fields
* IF  Y.RL.ID MATCHES 'RISK.INDIV.SECURED':VM:'RISK.INDIV.UNSECURED':VM:'RISK.GROUP.TOTAL':VM:'RISK.INDIV.TOTAL' THEN

* << PP moved to RECORD routine
*  IF  Y.RL.ID MATCHES 'RISK.GROUP.TOTAL' THEN
*      IF Y.CNT.FLDS GT 0 AND R.NEW(REDO.CCRG.RLP.FIELD.NO)<1,1,1> NE '' THEN
*         AF    = REDO.CCRG.RLP.APPLICATION
*         ETEXT = 'ST-REDO.CCRG.CONDTS.NOT.APPLY.TO.RL':FM:Y.RL.ID
*         CALL STORE.END.ERROR
*         RETURN
*      END
*      RETURN
*   END
* >>
*
  I  = ''
  FOR I = 1 TO Y.CNT.APP
* Set fields to indicate the messages
    AV = I
* Validate APPLICATION
    Y.APPLICATION = R.NEW(REDO.CCRG.RLP.APPLICATION)<1,I>
    CALL REDO.CCRG.ALLOWED.APP('VALIDATE', Y.APPLICATION)
    IF END.ERROR THEN
      RETURN
    END

* ------- Validate that an application is not duplicated ------------*
    IF I GT 1 AND Y.APPLICATION MATCHES Y.APPS THEN
      ETEXT = 'ST-REDO.CCRG.APPLICATION.DUPLICATED':FM:Y.APPLICATION
      CALL STORE.END.ERROR
      RETURN
    END
    Y.APPS = Y.APPS:VM:Y.APPLICATION
* ----------------------------------------------------------------------*

    J = ''
    Y.CNT.FLDS = ''
    Y.CNT.FLDS = DCOUNT(R.NEW(REDO.CCRG.RLP.FIELD.NO)<1,I>,SM)
    IF NOT(Y.CNT.FLDS) THEN
      AF    = REDO.CCRG.RLP.FIELD.NO
      AV    = I
      AS    = 1
      ETEXT = 'ST-REDO.CCRG.FIELD.NO.INPUT'
      CALL STORE.END.ERROR
      RETURN
    END

    GOSUB VALIDATE.FIELDS

  NEXT I  ;*Application
*
  RETURN
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.FIELDS>
VALIDATE.FIELDS:
***
  Y.FIELDS = ''
  FOR J = 1 TO Y.CNT.FLDS
* Set fields to indicate the messages
    AS = J
* Validate de Fields in Application entered
    Y.FIELD.NO = R.NEW(REDO.CCRG.RLP.FIELD.NO)<1,I,J>
    Y.FIELD.POS = ''
    R.STANDARD.SELECTION = ''
    CALL REDO.R.MULTI.GET.FIELD.NO(Y.APPLICATION,Y.FIELD.NO, R.STANDARD.SELECTION, Y.FIELD.POS)
    IF NOT(Y.FIELD.POS) THEN
      AF    = REDO.CCRG.RLP.FIELD.NO
      AV    = I
      AS    = J
      ETEXT = 'ST-REDO.CCRG.FIELD.NOT.APPLY.FOR.APP': FM :Y.FIELD.NO: VM :Y.APPLICATION
      CALL STORE.END.ERROR
      RETURN
    END

* ------- Validate that an field is not duplicated ------------*
    IF J GT 1 AND Y.FIELD.NO MATCHES Y.FIELDS THEN
      AF    = REDO.CCRG.RLP.FIELD.NO
      AV    = I
      ETEXT = 'ST-REDO.CCRG.FIELD.DUPLICATED':FM:Y.FIELD.NO
      CALL STORE.END.ERROR
      RETURN
    END
    Y.FIELDS = Y.FIELDS:VM:Y.FIELD.NO
*---------------------------------------------------------------*

* If there is data in the FIELD.NO has to be information in these fields: OPERATOR and MIN.VALUE or MAX.VALUE
    R.CONDITIONS = ''

* Modified for extract the correct values by each application
    R.CONDITIONS<REDO.CCRG.RLP.OPERATOR>  = R.NEW(REDO.CCRG.RLP.OPERATOR)<1,I,J>
    R.CONDITIONS<REDO.CCRG.RLP.MIN.VALUE> = R.NEW(REDO.CCRG.RLP.MIN.VALUE)<1,I,J>
    R.CONDITIONS<REDO.CCRG.RLP.MAX.VALUE> = R.NEW(REDO.CCRG.RLP.MAX.VALUE)<1,I,J>
    R.CONDITIONS<REDO.CCRG.RLP.BOOL.OPER> = R.NEW(REDO.CCRG.RLP.BOOL.OPER)<1,I,J>

    R.VALUES    = ''
    R.VALUES<1> = I
    R.VALUES<2> = Y.CNT.APP
    R.VALUES<3> = J
    R.VALUES<4> = Y.CNT.FLDS
* All fields
    CALL REDO.CCRG.VALIDATE.CONDITIONS(R.CONDITIONS, R.VALUES)
    IF END.ERROR THEN
      RETURN
    END
  NEXT J  ;*Fields
  RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***
  R.CONDITIONS  = ''
  Y.RL.ID       = ID.NEW
  Y.APPS        = ''
  Y.FIELDS      = ''
*
  RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Process Message>
PROCESS.MESSAGE:
  BEGIN CASE
  CASE MESSAGE EQ ''          ;* Only during commit...
    BEGIN CASE
    CASE V$FUNCTION EQ 'D'
      GOSUB VALIDATE.DELETE
    CASE V$FUNCTION EQ 'R'
      GOSUB VALIDATE.REVERSE
    CASE OTHERWISE  ;* The real VALIDATE...
      GOSUB VALIDATE
    END CASE
  CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER'       ;* During authorisation and verification...
    GOSUB VALIDATE.AUTHORISATION
  END CASE
*
  RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.DELETE>
VALIDATE.DELETE:
* Any special checks for deletion

  RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.REVERSE>
VALIDATE.REVERSE:
* Any special checks for reversal

  RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.AUTHORISATION>
VALIDATE.AUTHORISATION:
* Any special checks for authorisation

  RETURN
*** </region>
*-----------------------------------------------------------------------------
END
