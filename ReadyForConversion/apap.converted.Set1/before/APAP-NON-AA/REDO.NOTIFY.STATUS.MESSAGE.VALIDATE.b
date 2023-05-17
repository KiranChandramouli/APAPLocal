*-----------------------------------------------------------------------------
* <Rating>-14</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOTIFY.STATUS.MESSAGE.VALIDATE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.NOTIFY.STATUS.MESSAGE.VALIDATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to check for the Account field name with the Application of @ID

*LINKED WITH       :
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*   21 Jul 2011   Ganesh R              PACS00033637       issue fix for TDN4 delivery
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STANDARD.SELECTION
$INSERT I_F.REDO.NOTIFY.STATUS.MESSAGE

  IF V$FUNCTION EQ 'I' THEN
    GOSUB PROCESS
  END

  RETURN

PROCESS:
*Checking for the field present in the SS and throw an Error if not

  APPL = ID.NEW

*Get the Application Records

  CALL GET.STANDARD.SELECTION.DETS(APPL,REC.STORE)
  Y.SYS.FIELD.NAME = REC.STORE<SSL.SYS.FIELD.NAME>
  CHANGE VM TO FM IN Y.SYS.FIELD.NAME

  USR.FIELD.VALUE = REC.STORE<SSL.USR.FIELD.NAME>
  CHANGE VM TO FM IN USR.FIELD.VALUE

  LOCATE 'LOCAL.REF' IN Y.SYS.FIELD.NAME SETTING LOC.POS THEN
    VAR.LOCAL.POS = REC.STORE<SSL.SYS.FIELD.NO,LOC.POS,1>
  END

  Y.FIELD.NAME = R.NEW(REDO.NOTIF.ACCT.FIELD.NAME)
  FIELD.CNT = DCOUNT(Y.FIELD.NAME,VM)

*Locate the field in SS of the Application of @ID

  Y.FIELD.INIT = 1
  LOOP
    REMOVE Y.FIELD.ID FROM Y.FIELD.NAME SETTING FLD.POS
  WHILE Y.FIELD.INIT LE FIELD.CNT

    LOCATE Y.FIELD.ID IN USR.FIELD.VALUE SETTING LOC.FIELD.POS THEN
      Y.FIELD.VALUE = REC.STORE<SSL.USR.FIELD.NO,LOC.FIELD.POS,1>
      Y.ID.LOCREF.POSN = FIELD(Y.FIELD.VALUE,",",2)
      Y.ID.LOCREF.POSN = TRIM(FIELD(Y.ID.LOCREF.POSN,'>',1))
      VAR.FIELD.POSITION = VAR.LOCAL.POS:',':Y.ID.LOCREF.POSN
      R.NEW(REDO.NOTIF.ACCT.FIELD.POS)<1,Y.FIELD.INIT> = VAR.FIELD.POSITION
    END ELSE
      LOCATE Y.FIELD.ID IN Y.SYS.FIELD.NAME SETTING FIELD.POS THEN
        R.NEW(REDO.NOTIF.ACCT.FIELD.POS)<1,Y.FIELD.INIT> = REC.STORE<SSL.SYS.FIELD.NO,FIELD.POS,1>
      END ELSE
        AF = REDO.NOTIF.ACCT.FIELD.NAME
        AV = Y.FIELD.INIT
        ETEXT = "EB-REDO.NO.ACCT.NAME"
        CALL STORE.END.ERROR
      END
    END
    Y.FIELD.INIT++
  REPEAT

  RETURN
END
