*-------------------------------------------------------------------------------------------------------
* <Rating>-10</Rating>
*-------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.E.SELECT.SAVE.ACCTS(ENQ.DATA)
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.SELECT.SAVE.ACCTS
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.SELECT.SAVE.ACCTS
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
  Y.SEL.CATEG.VAL = ''
  Y.SAV.SEL.CATEG.VAL = ''
  LOCATE 'CATEGORY' IN ENQ.DATA<2,1> SETTING Y.SEL.CATEG.VAL.POS THEN
    Y.SEL.CATEG.VAL = ENQ.DATA<4,Y.SEL.CATEG.VAL.POS>
  END
  IF Y.SEL.CATEG.VAL THEN
    IF Y.SEL.CATEG.VAL GE 1000 AND Y.SEL.CATEG.VAL LE 9999 THEN
      Y.SAV.SEL.CATEG.VAL = Y.SEL.CATEG.VAL
    END ELSE
      ENQ.ERROR = 'Selection should be Customers Account'
    END
  END
  RETURN
END
