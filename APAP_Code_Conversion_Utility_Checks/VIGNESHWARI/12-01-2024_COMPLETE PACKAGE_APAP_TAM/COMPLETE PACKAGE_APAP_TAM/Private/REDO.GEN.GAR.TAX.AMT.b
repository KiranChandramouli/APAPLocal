* @ValidationCode : MjoxMzU1NjQ3NTkxOkNwMTI1MjoxNjgxMTE1MjA4NzcwOklUU1M6LTE6LTE6Mjc1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:56:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 275
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GEN.GAR.TAX.AMT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.GEN.TAX.ENTRY
*---------------------------------------------------------------------------------
*date           who        ref
*25-09-2011     Prabhu    PACS00133294
*
* Modification History:
*
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, F TO CACHE,
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the tax amount and raise the entry

*LINKED WITH       :
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TAX
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER
*   $INSERT I_F.TAX           ** R22 Auto Conversion
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_System
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

INIT:

    LOC.APPLICATION = 'FUNDS.TRANSFER'
    LOC.FIELDS = 'WAIVE.TAX':@VM:'L.FT.TAX.TYPE'
    LOC.POS    = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    FT.WAIVE.TAX.POS = LOC.POS<1,1>
    FT.TAX.POS = LOC.POS<1,2>

RETURN

OPENFILE:
*Opening the Files

    FN.TAX = 'F.TAX'
    F.TAX  = ''
    CALL OPF(FN.TAX,F.TAX)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.COMMISSION.TYPE = ''
    R.COMMISSION.TYPE = ''
    CALL OPF(FN.COMMISSION.TYPE,F.COMMISSION.TYPE)


    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESS.FT
    END
RETURN

PROCESS.FT:

    FT.DR.CURRENCY  = R.NEW(FT.DEBIT.CURRENCY)
    VAL.DATE        = R.NEW(FT.DEBIT.VALUE.DATE)
    ACCOUNT.ID      = R.NEW(FT.DEBIT.ACCT.NO)
    FT.CR.CURRENCY  = R.NEW(FT.CREDIT.CURRENCY)
    TRANS.CR.AMT    = R.NEW(FT.DEBIT.AMOUNT)
    VAL.DATE        = R.NEW(FT.CREDIT.VALUE.DATE)
    Y.ACCOUNT       = R.NEW(FT.CREDIT.ACCT.NO)
    Y.COMM.TYPE     = R.NEW(FT.COMMISSION.TYPE)
    TRANS.DR.AMT=System.getVariable('CURRENT.GAR.AMT')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;** R22 Auto Conversion - Start
        TRANS.DR.AMT = ""
    END                                    ;** R22 Auto Conversion - End

    CALL CACHE.READ(FN.COMMISSION.TYPE, Y.COMM.TYPE, R.COMMISSION.TYPE, FT.COMM.ERR)  ;** R22 Auto conversion - F TO CACHE
    TAXATION.CODE = R.NEW(FT.LOCAL.REF)<1,FT.TAX.POS>
    LOC.WAIVE.TAX = R.NEW(FT.LOCAL.REF)<1,FT.WAIVE.TAX.POS>
RETURN
PROCESS:
    SEL.CMD = "SELECT ":FN.TAX:" WITH @ID LIKE ":TAXATION.CODE:"... BY-DSND @ID"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,RET.ERR)
    TAXATION.CODE = SEL.LIST<1>
    CALL CACHE.READ(FN.TAX, TAXATION.CODE, R.TAX, ERR.TAX)     ;** R22 Auto conversion - F TO CACHE
    Y.DR.TAX.CODE = R.TAX<EB.TAX.TR.CODE.DR>
    Y.CR.TAX.CODE = R.TAX<EB.TAX.TR.CODE.CR>
    Y.TAX.CATEG   = R.TAX<EB.TAX.CATEGORY>
    Y.TAX.RATE    = R.TAX<EB.TAX.RATE>
    Y.TAX.AMT='0'
    Y.TAX.AMT     = (TRANS.DR.AMT*Y.TAX.RATE)/100
    CALL System.setVariable('CURRENT.GAR.TAX.AMT',Y.TAX.AMT)
    R.NEW(FT.DEBIT.AMOUNT)=TRANS.DR.AMT-Y.TAX.AMT
RETURN
END
