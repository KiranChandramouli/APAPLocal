*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.E.CONV.SEL.CRIT.38
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.E.CONV.SEL.CRIT.38
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.CONV.SEL.CRIT.38 is a conversion routine attached to the enquiry
*                    REDO.CASHIER.RPT.ENQ, this routine fetches the value from ENQ.SELECTION,
*                    formats them according to the selection criteria and returns the value back to O.DATA
*Linked With       : Enquiry REDO.CASHIER.RPT.ENQ
*In Parameter      : N/A
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                      Reference                Description
*   ------            ------                  -------------             -------------
* 14 Dec 2010      Shiva Prasad Y            ODR-2010-03-0175          Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
  Y.CRITERIA = ''

  LOCATE 'USER.NAME' IN ENQ.SELECTION<2,1> SETTING Y.USER.POS THEN
    Y.CRITERIA := 'Nomre del cajero -  ':ENQ.SELECTION<4,Y.USER.POS>
  END
  IF Y.CRITERIA THEN
    Y.CRITERIA := ', ':
  END
  LOCATE 'COMPANY.CODE' IN ENQ.SELECTION<2,1> SETTING Y.COMP.POS THEN
    Y.CRITERIA := 'Agencia - ':ENQ.SELECTION<4,Y.COMP.POS>
  END
  IF Y.CRITERIA EQ '' THEN
    Y.CRITERIA = 'ALL'
  END

  O.DATA =  Y.CRITERIA

  RETURN
*--------------------------------------------------------------------------------------------------------
END
