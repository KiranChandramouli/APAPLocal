*-----------------------------------------------------------------------------
* <Rating>-67</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.PROVISION.PARAMETER.AUTHORISE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.PROVISION.PARAMETER.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.H.PROVISION.PARAMETER.AUTHORISE is an authorisation routine attached to the TEMPLATE
*                    - REDO.H.PROVISION.PARAMETER; the routine updates the frequency to the batch file
*Linked With       : TEMPLATE-REDO.H.PROVISION.PARAMETER
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.H.PROVISION.PARAMETER             As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 24 Sep 2010        Mudassir V         ODR-2010-09-0167 B.23B        Initial Creation
*******************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.PROVISION.PARAMETER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB PROCESS.PARA

  RETURN
*-------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
  GOSUB GET.FREQUENCY

  RETURN
*-------------------------------------------------------------------------------------------------------
**************
GET.FREQUENCY:
**************
  FLAG = '' ; Y.VAL.DT.TYPE = ''
  Y.DATE.FREQ = R.NEW(PROV.COB.FREQUENCY)
  Y.FREQ = Y.DATE.FREQ[9,LEN(Y.DATE.FREQ)]

  COMI = Y.DATE.FREQ
  CALL CFQ
  Y.NEXT.RUN.DATE = COMI[1,8]

  BEGIN CASE
  CASE Y.FREQ EQ 'DAILY'
    GOSUB HOLIDAY.CHECK.DAILY
  CASE Y.FREQ NE 'DAILY'
    GOSUB HOLIDAY.CHECK
  END CASE
  R.NEW(PROV.NEXT.RUN.DATE) = Y.NEXT.RUN.DATE

  RETURN

*-------------------------------------------------------------------------
HOLIDAY.CHECK.DAILY:
*-------------------------------------------------------------------------

  Y.COUNT = 1
  LOOP
  WHILE Y.VAL.DT.TYPE NE 'W'
    Y.REGION = ''
    CALL AWD(Y.REGION,Y.NEXT.RUN.DATE,Y.VAL.DT.TYPE)
    Y.DIFF = Y.NEXT.RUN.DATE
    DAYS = '-':Y.COUNT:'C'

    IF FLAG EQ '' THEN
      CALL CDT('',Y.DIFF,DAYS)
    END
    IF Y.VAL.DT.TYPE EQ 'H' THEN
      IF Y.DIFF EQ TODAY THEN
        CALL CDT('',Y.NEXT.RUN.DATE,'+1C')
        Y.COUNT = Y.COUNT +1
      END ELSE
        CALL CDT('',Y.NEXT.RUN.DATE,'-1C')
      END
    END
  REPEAT
  RETURN
*-------------------------------------------------------------------------
HOLIDAY.CHECK:
*-------------------------------------------------------------------------
  LOOP
  WHILE Y.VAL.DT.TYPE NE 'W'
    Y.REGION = ''
    CALL AWD(Y.REGION,Y.NEXT.RUN.DATE,Y.VAL.DT.TYPE)
    IF Y.VAL.DT.TYPE EQ 'H' THEN
      CALL CDT('',Y.NEXT.RUN.DATE,'-1C')
    END
  REPEAT
  RETURN
*-------------------------------------------------------------------------
END
