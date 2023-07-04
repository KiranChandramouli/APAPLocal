* @ValidationCode : MjotMTYxNTAxNjkxMjpDcDEyNTI6MTY4MDY3MTUyMjg0MDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:42:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
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
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
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
