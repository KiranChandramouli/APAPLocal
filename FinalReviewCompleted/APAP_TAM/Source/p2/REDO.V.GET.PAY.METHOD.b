* @ValidationCode : MjotMTMxMTI2MTAwODpDcDEyNTI6MTY4MjY4MTkxOTk5ODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Apr 2023 17:08:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*--------------------------------------------------------------------
SUBROUTINE REDO.V.GET.PAY.METHOD
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.GET.PAY.METHOD
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.If Credit card status is Back log then it will
*                  show an override message
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0526    Initial Creation
* 19-JAN-2011         Prabhu.N       B126                TFS part added
* 26-AUG-2011        Marimuthu S     PACS00085821
* 28.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 28.04.2023       Shanmugapriya M       R22            Manual Conversion   - FM TO @FM, VM TO @VM
*
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.COMPANY
    $INSERT I_F.FUNDS.TRANSFER
*
    $INSERT I_F.REDO.INTERFACE.PARAMETER
*
    $INSERT I_F.T24.FUND.SERVICES
*
    Y.COMP.CODE = R.COMPANY(EB.COM.SUB.DIVISION.CODE)[2,3]
    LREF.POS    = ''

    IF APPLICATION EQ 'TELLER' THEN
        CALL MULTI.GET.LOC.REF(APPLICATION,'L.TT.SN.PAYMTHD',LREF.POS)
        Y.PAY.METHOD=R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS>
        R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS>=Y.PAY.METHOD[1,5]:Y.COMP.CODE:Y.PAY.METHOD[9,4]
    END
    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
        Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
        CHANGE @VM TO @FM IN Y.TXN.CODES
        LOCATE 'CREDCARDPAYMENT' IN Y.TXN.CODES<1> SETTING Y.TXN.POS THEN
            CALL MULTI.GET.LOC.REF(APPLICATION,'L.TT.SN.PAYMTHD',LREF.POS)
            Y.PAY.METHOD=R.NEW(TFS.LOCAL.REF)<1,LREF.POS>
            R.NEW(TFS.LOCAL.REF)<1,LREF.POS>=Y.PAY.METHOD[1,5]:Y.COMP.CODE:Y.PAY.METHOD[9,4]
        END
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        CALL MULTI.GET.LOC.REF(APPLICATION,'L.FT.SN.PAYMTHD',LREF.POS)
        Y.PAY.METHOD = R.NEW(FT.LOCAL.REF)<1,LREF.POS>
        R.NEW(FT.LOCAL.REF)<1,LREF.POS> = Y.PAY.METHOD[1,5]:Y.COMP.CODE:Y.PAY.METHOD[9,4]
    END
RETURN
END
