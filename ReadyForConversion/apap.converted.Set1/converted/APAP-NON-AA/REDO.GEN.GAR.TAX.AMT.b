SUBROUTINE REDO.GEN.GAR.TAX.AMT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.GEN.TAX.ENTRY
*---------------------------------------------------------------------------------
*date           who        ref
*25-09-2011     Prabhu    PACS00133294
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
*   $INSERT I_F.TAX
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
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        TRANS.DR.AMT = ""
    END

    CALL CACHE.READ(FN.COMMISSION.TYPE, Y.COMM.TYPE, R.COMMISSION.TYPE, FT.COMM.ERR)
    TAXATION.CODE = R.NEW(FT.LOCAL.REF)<1,FT.TAX.POS>
    LOC.WAIVE.TAX = R.NEW(FT.LOCAL.REF)<1,FT.WAIVE.TAX.POS>
RETURN
PROCESS:
    SEL.CMD = "SELECT ":FN.TAX:" WITH @ID LIKE ":TAXATION.CODE:"... BY-DSND @ID"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,RET.ERR)
    TAXATION.CODE = SEL.LIST<1>
    CALL CACHE.READ(FN.TAX, TAXATION.CODE, R.TAX, ERR.TAX)
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
