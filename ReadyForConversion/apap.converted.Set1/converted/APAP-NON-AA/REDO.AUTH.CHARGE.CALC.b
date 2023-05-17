SUBROUTINE REDO.AUTH.CHARGE.CALC
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.AUTH.CHARGE.CALC
* ODR NO      : ODR-2009-10-0324
*----------------------------------------------------------------------
*DESCRIPTION: This is AUTHORISATION Routine for both TELLER & FT to post an OFS message
* to repay the calculated charges



*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*02.06.2010  H GANESH     ODR-2009-10-0324  INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.OFS.PARAM

    GOSUB INIT
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN


*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.REDO.OFS.PARAM='F.REDO.OFS.PARAM'
    R.TELLER=''
    Y.DISB.AMOUNT=0
    Y.AMOUNT=''
    Y.DISBURSE.AMT=''
RETURN

*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------

    LOC.REF.APPLICATION="TELLER":@FM:"FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.DISB.AMT':@FM:'L.DISB.AMT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.TT.L.DISB.AMT=LOC.REF.POS<1,1>
    POS.FT.L.DISB.AMT=LOC.REF.POS<2,1>
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    IF APPLICATION EQ 'TELLER' THEN
        Y.DISB.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.1)
        Y.DISBURSE.AMT=R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.DISB.AMT>
        Y.AMOUNT=Y.DISBURSE.AMT-Y.DISB.AMOUNT
        Y.ACCOUNT=R.NEW(TT.TE.ACCOUNT.2)
        GOSUB PARAM.READ
        GOSUB OFSDISB
        GOSUB OFSBILL
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.DISB.AMOUNT=R.NEW(FT.DEBIT.AMOUNT)
        Y.DISBURSE.AMT=R.NEW(FT.LOCAL.REF)<1,POS.FT.L.DISB.AMT>
        Y.AMOUNT=Y.DISBURSE.AMT-Y.DISB.AMOUNT
        Y.ACCOUNT=R.NEW(FT.DEBIT.ACCT.NO)
        GOSUB PARAM.READ
        GOSUB OFSDISB
        GOSUB OFSBILL
    END
RETURN
*----------------------------------------------------------------------
OFSDISB:
*----------------------------------------------------------------------
* This part post the OFS message to disburse the amount

    IF Y.AMOUNT GT 0 THEN

        OFS.STR="TELLER,OFS.DISB/I/PROCESS,":Y.USERNAME:"/":Y.PASSWORD:",,AMOUNT.LOCAL.1=":Y.AMOUNT:",ACCOUNT.2=":Y.ACCOUNT:",VALUE.DATE.2=":TODAY
        OFS.MSG.ID=''
        OPTIONS=''
        CALL OFS.POST.MESSAGE(OFS.STR,OFS.MSG.ID,OFS.SRC,OPTIONS)

    END
RETURN
*----------------------------------------------------------------------
OFSBILL:
*----------------------------------------------------------------------
* This part post the OFS message to pay the BILL amount

    IF Y.AMOUNT GT 0 THEN

        OFS.STR="TELLER,OFS.REPAY/I/PROCESS,":Y.USERNAME:"/":Y.PASSWORD:",,AMOUNT.LOCAL.1=":Y.AMOUNT:",ACCOUNT.2=":Y.ACCOUNT:",VALUE.DATE.2=":TODAY
        OFS.MSG.ID=''
        OPTIONS=''
        CALL OFS.POST.MESSAGE(OFS.STR,OFS.MSG.ID,OFS.SRC,OPTIONS)

    END

RETURN
*----------------------------------------------------------------------
PARAM.READ:
*----------------------------------------------------------------------
* Gets the USERNAME and PASSWORD for OFS Message
    CALL CACHE.READ(FN.REDO.OFS.PARAM,ID.COMPANY,R.REDO.OFS.PARAM,PARAM.ERR)
    Y.USERNAME= R.REDO.OFS.PARAM<REDO.OFS.USER.NAME>
    Y.PASSWORD= R.REDO.OFS.PARAM<REDO.OFS.USER.PASSWORD>
    OFS.SRC= R.REDO.OFS.PARAM<REDO.OFS.OFS.SOURCE.ID>

RETURN
END
