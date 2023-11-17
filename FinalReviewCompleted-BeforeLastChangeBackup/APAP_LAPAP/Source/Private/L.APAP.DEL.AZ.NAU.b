* @ValidationCode : MjotMTY2MDgxMDY6Q3AxMjUyOjE2ODIzMzEzMjEzODY6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.DEL.AZ.NAU
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START

    $INSERT I_EQUATE

    $INSERT I_F.AZ.ACCOUNT ;*R22 Auto conversion - END

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT$NAU'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    SELECT.STATEMENT = 'SELECT ':FN.AZ.ACCOUNT : ' WITH CURR.NO EQ 1'
    ACCOUNT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,ACCOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE ACCOUNT.ID FROM ACCOUNT.LIST SETTING ACCOUNT.MARK
    WHILE ACCOUNT.ID : ACCOUNT.MARK

        R.ACCOUNT = ''
        YERR = ''
        CALL F.DELETE(FN.AZ.ACCOUNT,ACCOUNT.ID)

        CALL OCOMO('SE BORRO EL ID ' : ACCOUNT.ID)

    REPEAT


    SELECT.STATEMENT2 = 'SELECT ':FN.AZ.ACCOUNT
    ACCOUNT.LIST2 = ''
    LIST.NAME2 = ''
    SELECTED2 = ''
    SYSTEM.RETURN.CODE2 = ''
    CALL EB.READLIST(SELECT.STATEMENT2,ACCOUNT.LIST2,LIST.NAME2,SELECTED2,SYSTEM.RETURN.CODE2)

    LOOP
        REMOVE ACCOUNT.ID FROM ACCOUNT.LIST2 SETTING ACCOUNT.MARK2
    WHILE ACCOUNT.ID : ACCOUNT.MARK2

        R.ACCOUNT = ''
        YERR = ''

        Y.ID = ACCOUNT.ID

        Y.APP.NAME = "AZ.ACCOUNT"

        Y.VER.NAME = Y.APP.NAME :",MB.DM.LOAD"

        Y.FUNC = "D"

        Y.PRO.VAL = "PROCESS"

        Y.GTS.CONTROL = ""

        Y.NO.OF.AUTH = ""

        FINAL.OFS = ""

        OPTIONS = ""

        R.ACC = ""

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.ID,R.ACC,FINAL.OFS)

        CALL OCOMO('STRING OFS : ' : FINAL.OFS )

        CALL OFS.POST.MESSAGE(FINAL.OFS,"","DM.OFS.SRC.VAL","")

        CALL OCOMO('SE REVERSO EL ID ' : ACCOUNT.ID)

    REPEAT

END
