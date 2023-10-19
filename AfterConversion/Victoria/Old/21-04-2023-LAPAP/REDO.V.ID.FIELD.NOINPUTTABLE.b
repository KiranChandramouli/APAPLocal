$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.ID.FIELD.NOINPUTTABLE
*---------------------------------------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is an Check Rec routine attached to TELLER, FUNDS.TRANSFER
*This routine is to make the fields no inputtable when the version is opened for raising the RTE override
*
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 18-Jan-2017          APAP          RTE Fix              Initial Creation
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM,VM TO @VM
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     IF CONDITION MODIFIED
*------------------------------------------------------------------------------------------


    $INSERT I_COMMON  ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.REDO.BRANCH.STATUS
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_GTS.COMMON
    $INSERT I_RC.COMMON

    $INSERT I_F.BROWSER.TOOLS ;*R22 AUTO CONVERSION END

    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
        RETURN
    END

    GOSUB INIT
    IF ID.NEW[1,2] EQ 'TT' THEN
        Y.INITIAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.IN.ID>
    END ELSE
        IF ID.NEW[1,2] EQ 'FT' THEN
            Y.INITIAL.ID = R.NEW(FT.LOCAL.REF)<1,POS.FT.INIT.ID>
        END
    END

    IF V$FUNCTION NE 'A' AND V$FUNCTION NE 'D' AND V$FUNCTION NE 'S' THEN
        READ R.TMP.RTC.REC FROM F.REDO.TRANSACTION.CHAIN,Y.INITIAL.ID THEN
            LOCATE ID.NEW IN R.TMP.RTC.REC<RTC.TRANS.ID,1> SETTING TMP.POS THEN
                GET.RTE.TXNS = System.getVariable('CURRENT.RTE.TXNS')
                IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CONVERSION START
                    GET.RTE.TXNS = ""
                END ;*R22 AUTO CONVERSION END
            END ELSE
                GET.RTE.TXNS = ''
            END
        END ELSE
            GET.RTE.TXNS = ''
        END
        IF GET.RTE.TXNS NE 'CURRENT.RTE.TXNS' AND GET.RTE.TXNS NE '' THEN
            IF ID.NEW[1,2] EQ 'TT' THEN
                T(TT.TE.CUSTOMER.2)<3> = "NOINPUT"
                T(TT.TE.ACCOUNT.2)<3> = "NOINPUT"
                T(TT.TE.AMOUNT.LOCAL.1)<3> = "NOINPUT"
                T(TT.TE.NARRATIVE.2)<3> = "NOINPUT"
                T.LOCREF<POS.TT.NXT.VER,7>="NOINPUT"
                T(TT.TE.CURRENCY.1)<3> = "NOINPUT"
                T(TT.TE.ACCOUNT.1)<3> = "NOINPUT"
                T.LOCREF<POS.TT.BEN.LIST,7> = "NOINPUT"
                T.LOCREF<POS.TT.BENEFICIAR,7> = "NOINPUT"
                T.LOCREF<POS.TT.CONCEPT,7> = "NOINPUT"
                T.LOCREF<POS.TT.CR.CARD.NO,7> = "NOINPUT"
                T.LOCREF<POS.TT.CLIENT.NME,7> = "NOINPUT"
                T.LOCREF<POS.TT.CLIENT.COD,7> = "NOINPUT"
            END ELSE
                IF ID.NEW[1,2] EQ 'FT' THEN
                    T(FT.CREDIT.ACCT.NO)<3> = "NOINPUT"
                    T(FT.CREDIT.VALUE.DATE)<3> = "NOINPUT"
                    T(FT.CREDIT.AMOUNT)<3> = "NOINPUT"
                    T(FT.CREDIT.ACCT.NO)<3> = "NOINPUT"
                    T.LOCREF<POS.FT.NO.INSTAL,7> = "NOINPUT"
                    T.LOCREF<POS.FT.ADV.INS.CNT,7> = "NOINPUT"
                    T.LOCREF<POS.FT.AA.PART.ALLOW,7> = "NOINPUT"
                    T.LOCREF<POS.FT.NXT.VER,7> = "NOINPUT"
                    T.LOCREF<POS.FT.CERT.CHEQUE.NO,7> = "NOINPUT"
                    T.LOCREF<POS.FT.L.COMMENTS,7> = "NOINPUT"
                END
            END
        END
    END

RETURN

*-----
INIT:
*-----

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'
    F.REDO.TRANSACTION.CHAIN = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    Y.APPLN = 'TELLER':@FM:'FUNDS.TRANSFER' ;*R22 AUTO CONVERSION
    Y.LOC.FIELDS = 'L.INITIAL.ID':@VM:'L.NEXT.VERSION':@VM:'L.TT.BEN.LIST':@VM:'L.TT.BENEFICIAR':@VM:'L.TT.CONCEPT':@VM:'L.TT.CR.CARD.NO':@VM:'L.TT.CLIENT.NME':@VM:'L.TT.CLIENT.COD':@FM:'L.INITIAL.ID':@VM:'L.NEXT.VERSION':@VM:'L.NO.OF.INSTAL':@VM:'L.ADV.INS.CNT':@VM:'L.AA.PART.ALLOW':@VM:'CERT.CHEQUE.NO':@VM:'L.COMMENTS' ;*R22 AUTO CONVERSION

    CALL MULTI.GET.LOC.REF(Y.APPLN,Y.LOC.FIELDS,LRF.POS)
    POS.IN.ID  = LRF.POS<1,1>
    POS.TT.NXT.VER = LRF.POS<1,2>
    POS.TT.BEN.LIST = LRF.POS<1,3>
    POS.TT.BENEFICIAR = LRF.POS<1,4>
    POS.TT.CONCEPT = LRF.POS<1,5>
    POS.TT.CR.CARD.NO = LRF.POS<1,6>
    POS.TT.CLIENT.NME = LRF.POS<1,7>
    POS.TT.CLIENT.COD = LRF.POS<1,8>
    POS.FT.INIT.ID = LRF.POS<2,1>
    POS.FT.NXT.VER = LRF.POS<2,2>
    POS.FT.NO.INSTAL = LRF.POS<2,3>
    POS.FT.ADV.INS.CNT = LRF.POS<2,4>
    POS.FT.AA.PART.ALLOW = LRF.POS<2,5>
    POS.FT.CERT.CHEQUE.NO = LRF.POS<2,6>
    POS.FT.L.COMMENTS = LRF.POS<2,7>
RETURN

END
