* @ValidationCode : MjotNDM5MjM4NzAzOkNwMTI1MjoxNzAyOTg4MzQ0NTEyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
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
SUBROUTINE L.APAP.ACT.MENORES
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023       Santosh C               MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*------------------------------------------------------------------------------------------------
    $INSERT I_COMMON

    $INSERT I_EQUATE

    $INSERT I_F.CUSTOMER
    $USING EB.LocalReferences ;*R22 Manual Code Conversion_Utility Check
    $USING EB.Interface ;*R22 Manual Code Conversion_Utility Check

    Y.APP.NAME="CUSTOMER"

    Y.VER.NAME="CUSTOMER,RAD"

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    SELECT.STATEMENT = 'SELECT ':FN.CUSTOMER : " WITH L.CU.TIPO.CL EQ 'CLIENTE MENOR' AND L.CU.AGE LT 18 AND SECTOR EQ 9999  "
    CUSTOMER.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,CUSTOMER.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE CUSTOMER.ID FROM CUSTOMER.LIST SETTING CUSTOMER.MARK
    WHILE CUSTOMER.ID : CUSTOMER.MARK

        R.CUSTOMER = ''
        YERR = ''
        CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,YERR)

*Y.TRANS.ID = ID.NEW

        Y.TRANS.ID = CUSTOMER.ID

        Y.APP.NAME = "CUSTOMER"

        Y.VER.NAME = Y.APP.NAME :",RAD"

        Y.FUNC = "I"

        Y.PRO.VAL = "PROCESS"

        Y.GTS.CONTROL = ""

        Y.NO.OF.AUTH = ""

        FINAL.OFS = ""

        OPTIONS = ""

        Y.CAN.NUM = 0

        Y.CAN.MULT = ""

        R.CUS = ""

*       CALL GET.LOC.REF("CUSTOMER","L.APAP.INDUSTRY",CUS.POS)
*       CALL GET.LOC.REF("CUSTOMER","L.TIP.CLI",CUS.POS2)
        EB.LocalReferences.GetLocRef("CUSTOMER","L.APAP.INDUSTRY",CUS.POS) ;*R22 Manual Code Conversion_Utility Check
        EB.LocalReferences.GetLocRef("CUSTOMER","L.TIP.CLI",CUS.POS2) ;*R22 Manual Code Conversion_Utility Check

        R.CUS<EB.CUS.LOCAL.REF,CUS.POS> = "930992"

        R.CUS<EB.CUS.LOCAL.REF,CUS.POS2> = "521"

*PRINT R.CUS
*PRINT Y.TRANS.ID

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.CUS,FINAL.OFS)

*PRINT FINAL.OFS
        OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS)
*       CALL OFS.CALL.BULK.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
        EB.Interface.OfsCallBulkManager("DM.OFS.SRC.VAL", FINAL.OFS, OFS.RESP, TXN.COMMIT)  ;*R22 Manual Code Conversion_Utility Check
*PRINT @(15,12) : FINAL.OFS
*PRINT @(16,13) : Y.CAN.NUM
*PRINT @(17,14) : Y.CAN.MULT
*INPUT XX

    REPEAT

    PRINT @(17,14) : "PROCESO TERMINADO"

END
