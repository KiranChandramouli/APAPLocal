* @ValidationCode : MjotNTE2MTM3Njg5OkNwMTI1MjoxNjg0MjIyNzgyNTgxOklUU1M6LTE6LTE6Mjg5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 289
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ACT.MENORES
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------------------------
    $INSERT I_COMMON

    $INSERT I_EQUATE

    $INSERT I_F.CUSTOMER

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

        CALL GET.LOC.REF("CUSTOMER","L.APAP.INDUSTRY",CUS.POS)
        CALL GET.LOC.REF("CUSTOMER","L.TIP.CLI",CUS.POS2)

        R.CUS<EB.CUS.LOCAL.REF,CUS.POS> = "930992"

        R.CUS<EB.CUS.LOCAL.REF,CUS.POS2> = "521"

*PRINT R.CUS
*PRINT Y.TRANS.ID

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.CUS,FINAL.OFS)

*PRINT FINAL.OFS
        OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS)
        CALL OFS.CALL.BULK.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
*PRINT @(15,12) : FINAL.OFS
*PRINT @(16,13) : Y.CAN.NUM
*PRINT @(17,14) : Y.CAN.MULT
*INPUT XX

    REPEAT

    PRINT @(17,14) : "PROCESO TERMINADO"

END
