*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AZ.MIG.PERIOD.END(Y.AZ.ACCOUNT.ID)
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.AZ.MIG.PERIOD.END
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*       This batch routine is used to maintain the month end frequency of migrated az
* on renewal
*---------------------------------------------------------------------------------
* Linked with   : None
* In Parameter  : Y.AZ.ACCOUNT.ID
* Out Parameter : None
*--------------------------------------------------------------------------------

$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_REDO.B.AZ.MIG.PERIOD.END.COMMON

  GOSUB PROCESS
  RETURN

*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  CALL F.READ(FN.AZACCOUNT,Y.AZ.ACCOUNT.ID,R.AZACCOUNT,F.AZACCOUNT,AZ.ACC.ERR)

  Y.DATE = R.AZACCOUNT<AZ.VALUE.DATE>

*    Y.YEAR.MONTH = Y.DATE[1,6]
*    Y.MONTH = Y.DATE[5,2]

*    BEGIN CASE
*
*   CASE (Y.MONTH EQ 01) OR (Y.MONTH EQ 03) OR (Y.MONTH EQ 05) OR (Y.MONTH EQ 07) OR (Y.MONTH EQ 08) OR (Y.MONTH EQ 10) OR (Y.MONTH EQ 12)
*       YLAST.DAY = "31"
*
*  CASE (Y.MONTH EQ 02)
*     IF MOD(Y.DATE[1,4],4) EQ 0 THEN
*        YLAST.DAY = "29"
*   END ELSE
*       YLAST.DAY = "28"
*  END
*
* CASE (Y.MONTH EQ 04) OR (Y.MONTH EQ 06) OR (Y.MONTH EQ 09) OR (Y.MONTH EQ 11)
*    YLAST.DAY = "30"
*
*CASE OTHERWISE
*  YLAST.DAY = "31"
*
* END CASE

*Y.FREQ = Y.YEAR.MONTH:YLAST.DAY:"M0131"

  Y.MONTH.FREQ = "M0130"
  TEMP.COMI = COMI
  COMI = Y.DATE:Y.MONTH.FREQ
  CALL CFQ
  Y.FREQ = COMI
  COMI = TEMP.COMI

  VAR.TYPE.OF.SCHDLE   = R.AZACCOUNT<AZ.TYPE.OF.SCHDLE,1>

  IF VAR.TYPE.OF.SCHDLE EQ "I" THEN
    Y.ACCT.ARRAY = ''
    Y.ACCT.ARRAY<AZ.FREQUENCY> = Y.FREQ

    OFS.SRC.ID = 'AZ.MIG.PERIOD'
    ACTUAL.APP.NAME = 'AZ.ACCOUNT'
    OFS.FUNCTION = 'I'
    PROCESS = 'PROCESS'
    OFS.VERSION = ''
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = Y.AZ.ACCOUNT.ID
    OFS.RECORD = ''
    VERSION.ACCT = 'AZ.ACCOUNT,OFS'
    MSG.ID = ''
    ERR.OFS =''
    OPTION = ''
    CALL OFS.BUILD.RECORD(ACTUAL.APP.NAME,OFS.FUNCTION,PROCESS,VERSION.ACCT,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,Y.ACCT.ARRAY,Y.OFS.POST.ARRAY)
    CALL OFS.POST.MESSAGE(Y.OFS.POST.ARRAY,MSG.ID,OFS.SRC.ID,ERR.OFS)
  END

  RETURN
*-----------------------------------------------------------------------------------
END
