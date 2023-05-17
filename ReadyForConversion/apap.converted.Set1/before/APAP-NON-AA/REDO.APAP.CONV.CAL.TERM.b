*-----------------------------------------------------------------------------
* <Rating>-71</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CONV.CAL.TERM
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.CAL.TERM
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the
*                    from account and calculates the TERM and returns it to O.DATA
*Linked With       : Enquiry REDO.ENQ.REP.INVESTMENT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who             Reference                                 Description
*     ------         -----           -------------                             -------------
* 30 Sep 2010     Arulpraksam P   ODR-2010-03-0183                           Initial Creation
*
*********************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------------------------------
***********
OPEN.FILES:
***********

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  RETURN

*---------------------------------------------------------------------------------------------------------
********
PROCESS:
********

  SEL.CMD.AZ = 'SELECT ':FN.AZ.ACCOUNT
  CALL EB.READLIST(SEL.CMD.AZ,Y.ACC.LIST,'',NO.OF.REC,ERR)
  LOOP
    REMOVE Y.AZ.ID FROM Y.ACC.LIST SETTING POS
  WHILE Y.AZ.ID:POS
    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,F.ERR)
    Y.BDY.OPENING.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    Y.DATE1 = Y.BDY.OPENING.DATE
    Y.BDY.MATURITY.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    Y.DATE2 = Y.BDY.MATURITY.DATE
    Y.DT1.YR = Y.DATE1[1,4]
    Y.DT1.MM = Y.DATE1[5,2]
    Y.DT1.DY = Y.DATE1[7,2]

    Y.DT2.YR = Y.DATE2[1,4]
    Y.DT2.MM = Y.DATE2[5,2]
    Y.DT2.DY = Y.DATE2[7,2]

    Y.YEAR.CNT = ''
    Y.TEMP.DATE.1 = Y.DATE1
    Y.DAYS = 'C'
    Y.NOF.DAYS = 'W'
    Y.ACT.YEAR = 1
    Y.INC = 1
    GOSUB YEAR.CHECK

    IF Y.INC EQ 1 THEN
      Y.YEAR.CNT = 0
    END
  REPEAT
  GOSUB MNTH.CHK

  Y.BDY.TERM = Y.YEAR.CNT:'Y':':':Y.NO.OF.MONTHS:'M':':':ABS(Y.DAYS):'D'

  RETURN

*---------------------------------------------------------------------------------------------------------
***********
YEAR.CHECK:
***********

  IF Y.DT1.YR NE Y.DT2.YR THEN
    LOOP
    WHILE Y.INC LE 100
      Y.YEAR = '1Y'
      CALL CALENDAR.DAY(Y.TEMP.DATE.1,'+',Y.YEAR)
      IF Y.YEAR LE Y.DATE2 THEN
        Y.YEAR.CNT += 1
        Y.TEMP.DATE.1 = Y.YEAR
      END ELSE
        RETURN
      END
      Y.INC++
    REPEAT
  END ELSE
    Y.YEAR.CNT = 0
    GOSUB MNTH.CHK
  END

  RETURN

*---------------------------------------------------------------------------------------------------------
*********
MNTH.CHK:
*********

  Y.NO.OF.MONTHS = ''
  CALL EB.NO.OF.MONTHS(Y.TEMP.DATE.1,Y.DATE2,Y.NO.OF.MONTHS)
  GOSUB DAY.CHECK

  RETURN

*---------------------------------------------------------------------------------------------------------
**********
DAY.CHECK:
**********

  Y.MNTH = Y.NO.OF.MONTHS:'M'
  CALL CALENDAR.DAY(Y.TEMP.DATE.1,'+',Y.MNTH)
  CALL CDD('',Y.MNTH,Y.DATE2,Y.DAYS)

  RETURN
*---------------------------------------------------------------------------------------------------------
END
