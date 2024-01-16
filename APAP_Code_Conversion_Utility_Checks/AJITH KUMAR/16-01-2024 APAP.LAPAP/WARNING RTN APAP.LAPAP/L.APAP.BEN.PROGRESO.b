* @ValidationCode : Mjo3MTI2NDUzNjc6Q3AxMjUyOjE3MDI5ODgzNDY0MzM6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:06
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
SUBROUTINE L.APAP.BEN.PROGRESO
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND F.READ TO CACHE.READ AND REMOVED F.BENEFICIARY
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 18-12-2023    Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
   $USING EB.LocalReferences
   $USING ST.CompanyCreation

    $INSERT I_EQUATE

    $INSERT I_F.BENEFICIARY
    $USING EB.Interface


    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)


    SELECT.STATEMENT = 'SELECT ':FN.BENEFICIARY : " WITH L.BEN.BANK EQ 10101110 "
    BENEFICIARY.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,BENEFICIARY.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE BENEFICIARY.ID FROM BENEFICIARY.LIST SETTING BENEFICIARY.MARK
    WHILE BENEFICIARY.ID : BENEFICIARY.MARK

        PRINT @(16,13) : BENEFICIARY.ID

        R.BENEFICIARY = ''
        YERR = ''
        CALL CACHE.READ(FN.BENEFICIARY, BENEFICIARY.ID, R.BENEFICIARY, YERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.BENEFICIARY

        Y.ID = BENEFICIARY.ID

        Y.APP.NAME = "BENEFICIARY"

        Y.VER.NAME = "BENEFICIARY,APAP.OTHER"

        Y.FUNC = "I"

        Y.PRO.VAL = "PROCESS"

        Y.GTS.CONTROL = ""

        Y.NO.OF.AUTH = ""

        FINAL.OFS = ""

        OPTIONS = ""

        R.BEN = ""

*        CALL GET.LOC.REF("BENEFICIARY","L.BEN.BANK",ACC.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY","L.BEN.BANK",ACC.POS);* R22 UTILITY AUTO CONVERSION

        R.BEN<ARC.BEN.LOCAL.REF,ACC.POS> = "10101030"

        YCO.CODE = R.BENEFICIARY<ARC.BEN.CO.CODE>

*        CALL LOAD.COMPANY(YCO.CODE)
ST.CompanyCreation.LoadCompany(YCO.CODE);* R22 UTILITY AUTO CONVERSION

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.ID,R.BEN,FINAL.OFS)
        OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER("DIARY.OFS", FINAL.OFS)
*       CALL OFS.CALL.BULK.MANAGER("DIARY.OFS", FINAL.OFS, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
        EB.Interface.OfsCallBulkManager("DIARY.OFS", FINAL.OFS, OFS.RESP, TXN.COMMIT) ;*R22 Manual Code Conversion_Utility Check
    REPEAT

    PRINT @(17,14) : "PROCESO TERMINADO"

END
