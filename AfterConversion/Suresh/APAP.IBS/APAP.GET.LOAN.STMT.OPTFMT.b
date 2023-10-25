$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>280</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE APAP.GET.LOAN.STMT.OPTFMT(MOB.REQUEST, MOB.RESPONSE)
*---------------------------------------------------------------------------------------------------
* Description :
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.MOB.FRMWRK.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TRANSACTION
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:

    MOB.RESPONSE.SAVE = MOB.RESPONSE

    NO.OF.FLDS = DCOUNT(MOB.RESPONSE<1, 1>, @SM)

    LOCATE 'TXN.CONTRACT.ID' IN MOB.RESPONSE<1, 1, 1> SETTING TXN.POS ELSE NULL
    LOCATE 'ID' IN MOB.RESPONSE<1, 1, 1> SETTING AAA.POS ELSE NULL
    LOCATE 'TRANSACTION.TYPE' IN MOB.RESPONSE<1, 1, 1> SETTING TYP.POS ELSE NULL
    LOCATE 'EFFECTIVE.DATE' IN MOB.RESPONSE<1, 1, 1> SETTING EFF.POS ELSE NULL

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

    FN.FT.TXN.TYPE.COND = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.COND = ''
    CALL OPF(FN.FT.TXN.TYPE.COND, F.FT.TXN.TYPE.COND)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION, F.TRANSACTION)

    MOB.RESPONSE<1, 1, -1> = 'TRANSACTION.NARRATIVE'

RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:


    APPL.IDS.CNT = DCOUNT(MOB.RESPONSE, @VM)

    FOR ID.CNT = 2 TO APPL.IDS.CNT
        FT.ID = MOB.RESPONSE<1, ID.CNT, TXN.POS>
        AAA.ID = MOB.RESPONSE<1, ID.CNT, AAA.POS>
        TYP.ID = MOB.RESPONSE<1, ID.CNT, TYP.POS>

        CALL F.READ(FN.FT.TXN.TYPE.COND, TYP.ID, R.TYP, F.FT.TXN.TYPE.COND, E.TYP)

        IF NOT(E.TYP) THEN
            TXN.ID = R.TYP<FT6.TXN.CODE.DR>
            CALL F.READ(FN.TRANSACTION, TXN.ID, R.TXN, F.TRANSACTION, E.TXN)
            IF NOT(E.TXN) THEN
                TRANSACTION.NARRATIVE = R.TXN<AC.TRA.NARRATIVE, LNGG>
                MOB.RESPONSE<1, ID.CNT, -1> = TRANSACTION.NARRATIVE
                IF TXN.ID EQ 895 THEN
                    MOB.RESPONSE<1, ID.CNT, EFF.POS> = ""
                END
            END
        END
    NEXT ID.CNT

RETURN

*---------------------------------------------------------------------------------------------------

END
