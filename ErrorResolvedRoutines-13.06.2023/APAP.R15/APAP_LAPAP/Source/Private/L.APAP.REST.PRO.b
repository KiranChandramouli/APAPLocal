* @ValidationCode : Mjo3MTc4MjIxODpDcDEyNTI6MTY4NTk1MjIxMjEwNzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:33:32
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
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.REST.PRO
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 02-June-2023      Conversion Tool       R22 Auto Conversion - No changes
* 02-June-2023      Harsha                R22 Manual Conversion - OFS.GLOBUS.MANAGER to OFS.CALL.BULK.MANAGER
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RESTRICTIVE.LIST


    Y.APP.NAME= 'REDO.RESTRICTIVE.LIST'
    Y.VER.NAME= 'REDO.RESTRICTIVE.LIST,INPUT'

    FN.REDO.REST = 'F.REDO.RESTRICTIVE.LIST'
    FV.REDO.REST = ''
    CALL OPF(FN.REDO.REST,FV.REDO.REST)

    SELECT.STATEMENT = 'SELECT ':FN.REDO.REST : " WITH LISTA.RESTRICTIVA EQ CEDULAS.CANCELADAS "
    REST.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,REST.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)


    LOOP
        REMOVE REST.ID FROM REST.LIST SETTING REST.MARK
    WHILE REST.ID : REST.MARK

        Y.TRANS.ID = REST.ID

        Y.APP.NAME = "REDO.RESTRICTIVE.LIST"

        Y.VER.NAME = Y.APP.NAME :",INPUT"

        Y.FUNC = "R"

        Y.PRO.VAL = "PROCESS"

        Y.GTS.CONTROL = ""

        Y.NO.OF.AUTH = ""

        FINAL.OFS = ""

        OPTIONS = ""

        Y.CAN.NUM = 0

        Y.CAN.MULT = ""

        R.ACC = ""

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACC,FINAL.OFS)

        CALL OFS.CALL.BULK.MANAGER("DM.OFS.SRC.VAL", FINAL.OFS)  ;*R22 Manual Conversion - OFS.GLOBUS.MANAGER to OFS.CALL.BULK.MANAGER


    REPEAT

    PRINT @(17,14) : "PRESIONAR TECLA PARA TERMINAR"
    INPUT XX

END
