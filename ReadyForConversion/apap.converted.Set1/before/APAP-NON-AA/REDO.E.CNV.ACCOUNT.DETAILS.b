*-------------------------------------------------------------------------------------------------------
* <Rating>-11</Rating>
*-------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.ACCOUNT.DETAILS
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.ACCOUNT.DETAILS
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.CNV.ACCOUNT.DETAILS
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  30-10-2010       Sakthi Sellappillai            ODR-2010-08-0173            Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
*---------------------------------------------------------------------------------------------------------
  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------

  Y.CNV.ACCT.TYPE = ''
  Y.SEL.CNV.ACCT.TYPE = ''
  LOCATE "CATEGORY" IN ENQ.SELECTION<2,1> SETTING Y.CNV.ACCT.TYPE.POS THEN
    Y.SEL.CNV.ACCT.TYPE = ENQ.SELECTION<4,Y.CNV.ACCT.TYPE.POS>
  END
  IF Y.SEL.CNV.ACCT.TYPE NE '' THEN
    Y.CNV.ACCT.TYPE = "TIPO DE CUENTA - ":Y.SEL.CNV.ACCT.TYPE
  END
  IF Y.SEL.CNV.ACCT.TYPE EQ '' THEN
*       Y.CNV.ACCT.TYPE = 'TIPO DE CUENTA - 1000 TO 9999'
    Y.CNV.ACCT.TYPE = 'TODOS'
  END
  IF Y.CNV.ACCT.TYPE THEN
    O.DATA = Y.CNV.ACCT.TYPE
  END ELSE
    O.DATA = ''
  END
  RETURN
END
