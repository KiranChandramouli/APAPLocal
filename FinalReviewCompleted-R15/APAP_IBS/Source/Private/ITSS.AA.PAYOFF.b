$PACKAGE APAP.IBS
**===========================================================================================================================================
*-----------------------------------------------------------------------------
* <Rating>179</Rating>
*-----------------------------------------------------------------------------
PROGRAM ITSS.AA.PAYOFF
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    DEBUG
**===========================================================================================================================================
    GOSUB INIT
    GOSUB PROCESS

RETURN
**===========================================================================================================================================

INIT:

    OFS.SOURCE = ""
    OFS.SOURCE = "OFS.AA.PAYOFF"




    FN.FTR = "FBNK.FUNDS.TRANSFER"
    F.FTR = ""
    CALL OPF(FN.FTR,F.FTR)


    OPEN '&SAVEDLISTS&' TO TMP.SAVE ELSE NULL
    READ AA.ACCOUNT.LIST FROM TMP.SAVE, 'CONTRACTS.LIST' ELSE NULL

    EFF.DATE = ""

RETURN

**===========================================================================================================================================
PROCESS:

    LOOP
        DEBUG
        REMOVE AA.ID FROM AA.ACCOUNT.LIST SETTING AA.POS
    WHILE AA.ID : AA.POS

        AA.ARR=""
        AA.ARR=AA.ID
        CALL E.AA.GET.FIN.SUMMARY(AA.ARR)
        R.FTR= ""
        R.FTR<FT.DEBIT.ACCT.NO> = "DOP1007052030052"
        R.FTR<FT.DEBIT.CURRENCY> = "DOP"
        R.FTR<FT.DEBIT.VALUE.DATE> = TODAY
        R.FTR<FT.CREDIT.ACCT.NO> = AA.ID
        R.FTR<FT.ORDERING.BANK> = "APAP"

        CALL OFS.BUILD.RECORD("FUNDS.TRANSFER","I","PROCESS","FUNDS.TRANSFER,AA.PAYOFF","1","0",'',R.FTR,OFS.MESSAGE)
        CALL OFS.GLOBUS.MANAGER(OFS.SOURCE,OFS.MESSAGE)
        Y.ERR=""
        Y.ERR = FIELD(OFS.MESSAGE,"/",4)

        CRT Y.ERR


    REPEAT

RETURN

END
