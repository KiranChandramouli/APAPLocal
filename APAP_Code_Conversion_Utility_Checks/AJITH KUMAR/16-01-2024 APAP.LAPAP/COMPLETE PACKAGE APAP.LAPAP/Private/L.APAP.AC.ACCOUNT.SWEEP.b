* @ValidationCode : MjoxOTY5NTkyNTI4OkNwMTI1MjoxNzAyOTg4MzQ0MzcxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.AC.ACCOUNT.SWEEP
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND REM TO DISPLAY.MESSAGE(TEXT, '')
* 21-04-2023         ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023         Santosh C             MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.ACCOUNT.LINK
    $USING EB.OverrideProcessing ;*R22 Manual Code Conversion_Utility Check
 
*DEBUG

    FN.AC = "F.ACCOUNT"
    F.AC = ""
    CALL OPF(FN.AC, F.AC) ;*R22 Manual Code Conversion_Utility Check
*   F.AC2 = "" ;*R22 Manual Code Conversion_Utility Check
    F.CUST.ID.AC1 = ""
    F.CUST.ID.AC2 = ""
    F.ACC1 = R.NEW(AC.LINK.ACCOUNT.TO)
    F.ACC2 = R.NEW(AC.LINK.ACCOUNT.FROM)
    CALL F.READ(FN.AC, F.ACC1 , R.AC, F.AC, '')
*   CALL F.READ(FN.AC, F.ACC2 , R.AC2, F.AC2, '')  ;*R22 Manual Code Conversion_Utility Check
    CALL F.READ(FN.AC, F.ACC2 , R.AC2, F.AC, '')

    F.CUST.ID.AC1 = R.AC<AC.CUSTOMER>
    F.CUST.ID.AC2 = R.AC2<AC.CUSTOMER>

*DEBUG

    IF F.ACC1 EQ F.ACC2 THEN

        TEXT = "AMBAS CUENTAS SON IGUALES"
*       CALL DISPLAY.MESSAGE(TEXT, '') ;*R22 Manual Code Conversion_Utility Check
        EB.OverrideProcessing.DisplayMessage(TEXT, '')
        ETEXT = TEXT
        PRINT E
        CALL STORE.END.ERROR

    END

    IF F.CUST.ID.AC1 NE F.CUST.ID.AC2 THEN

        TEXT = "CUENTA INVALIDA, NO PERTENECE AL MISMO CLIENTE"
*       CALL DISPLAY.MESSAGE(TEXT, '') ;*R22 Manual Code Conversion_Utility Check
        EB.OverrideProcessing.DisplayMessage(TEXT, '')
        ETEXT = TEXT
        PRINT E
        CALL STORE.END.ERROR
    END
RETURN
END
