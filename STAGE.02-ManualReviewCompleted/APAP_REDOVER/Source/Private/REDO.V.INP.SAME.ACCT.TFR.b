* @ValidationCode : Mjo2Mjk0MjUwMjI6Q3AxMjUyOjE2ODQ4NDU2MjIxNTc6SVRTUzotMTotMToxOTA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 190
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.SAME.ACCT.TFR
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.INP.SAME.ACCT.TFR
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is the input routine to restrict same account transfer
*
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who                 Reference                 Description
* 16-APR-2010        Prabhu.N           ODR-2010-08-0031            Initial Creation
*12-04-2023         Conversion Tool    R22 Auto Code conversion     FM TO @FM, IF CONDITION ADDED
*12-04-2023          Samaran T         R22 Manual Code conversion       No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.BENEFICIARY
    $INSERT I_System

    FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
    F.CUS.BEN.LIST  = ''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)

    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------

    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CODE CONVERSION.START
        CUSTOMER.ID = ""   ;*R22 AUTO CODE CONVERSION
    END   ;*R22 AUTO CODE CONVERSION.END

    CUS.BEN.LIST.ID = CUSTOMER.ID:'-OWN'
    CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)
    CHANGE '*' TO @FM IN R.CUS.BEN.LIST
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.CREDIT.ACCT.NO  = R.NEW(FT.CREDIT.ACCT.NO)
        R.NEW(FT.CREDIT.THEIR.REF)=ID.NEW
        IF R.NEW(FT.DEBIT.ACCT.NO) EQ Y.CREDIT.ACCT.NO THEN
            AF = FT.CREDIT.ACCT.NO
            ETEXT = 'EB-SAME.DR.CR.ACCT'
            CALL STORE.END.ERROR
        END
        LOCATE Y.CREDIT.ACCT.NO IN R.CUS.BEN.LIST SETTING Y.BEN.POS THEN
            CR.BEN.ID = R.CUS.BEN.LIST<Y.BEN.POS+1>
            R.NEW(FT.BENEFICIARY.ID) = CR.BEN.ID
        END


    END

    IF APPLICATION EQ 'STANDING.ORDER' THEN
        Y.CREDIT.ACCT.NO = FIELD(ID.NEW,'.',1)
        IF R.NEW(STO.CPTY.ACCT.NO) EQ Y.CREDIT.ACCT.NO THEN
            AF = STO.CPTY.ACCT.NO
            ETEXT = 'EB-SAME.DR.CR.ACCT'
            CALL STORE.END.ERROR
        END
        LOCATE Y.CREDIT.ACCT.NO IN R.CUS.BEN.LIST SETTING Y.BEN.POS THEN
            CR.BEN.ID = R.CUS.BEN.LIST<Y.BEN.POS+1>
            R.NEW(STO.BENEFICIARY.ID) = CR.BEN.ID
        END
    END

RETURN
END
