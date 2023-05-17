SUBROUTINE REDO.APAP.CONV.STMT.CONSULT
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.LAST.TRANS.DATE
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to fetch the value of LAST.TRANS.DATE from ACCOUNT
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  Date            Who                        Reference                    Description
* ------          ------                      -------------                -------------
* 12-11-2010      Sakthi Sellappillai         ODR-2010-08-0173 N.73       Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------
    Y.ENQ.DISPLAY.LIST = ''
    Y.TRANS.DATE.VAL = ''
    Y.TRANS.DOC.NO.VAL = ''
    Y.TRANS.REF.NO.VL = ''
    Y.TRANS.DESC.VAL = ''
    Y.TRANS.DEBIT.AMT.VAL = ''
    Y.TRANS.CREDIT.AMT.VAL = ''
    Y.TRANS.AMT.BAL.VAL = ''
    Y.TRANS.CONSULT.INIT.ARRAY = ''
RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
    Y.ENQ.DISPLAY.LIST = FORMATTED.DATA
    IF Y.ENQ.DISPLAY.LIST THEN
        Y.TRANS.DATE.VAL = Y.ENQ.DISPLAY.LIST<45>
        Y.TRANS.DOC.NO.VAL = Y.ENQ.DISPLAY.LIST<60>
        Y.TRANS.REF.NO.VL = Y.ENQ.DISPLAY.LIST<61>
        Y.TRANS.DESC.VAL = Y.ENQ.DISPLAY.LIST<62>
        Y.TRANS.DEBIT.AMT.VAL = Y.ENQ.DISPLAY.LIST<111>
        Y.TRANS.CREDIT.AMT.VAL = Y.ENQ.DISPLAY.LIST<113>
        Y.TRANS.AMT.BAL.VAL = Y.ENQ.DISPLAY.LIST<121>
    END
    Y.TRANS.CONSULT.INIT.ARRAY = Y.TRANS.DATE.VAL:"##":Y.TRANS.DOC.NO.VAL:"##":Y.TRANS.REF.NO.VL:"##":Y.TRANS.DESC.VAL:"##":Y.TRANS.DEBIT.AMT.VAL:"##":Y.TRANS.CREDIT.AMT.VAL:"##":Y.TRANS.AMT.BAL.VAL
    IF Y.TRANS.CONSULT.INIT.ARRAY THEN
        O.DATA = Y.TRANS.CONSULT.INIT.ARRAY
    END ELSE
        O.DATA = ''
    END
RETURN
*-------------------------------------------------------------------------------------
END
