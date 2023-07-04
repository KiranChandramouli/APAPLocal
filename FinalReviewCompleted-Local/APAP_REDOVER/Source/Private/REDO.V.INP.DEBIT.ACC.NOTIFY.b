* @ValidationCode : MjotMTU4ODg0MzUzOkNwMTI1MjoxNjgyNDEyMzUwNTkzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
*
* Subroutine Type : VERSION ROUTINE
* Attached to     :  AZ.ACCOUNT OPENING VERSIONS
* Attached as     : FIELD VALIDATION

SUBROUTINE REDO.V.INP.DEBIT.ACC.NOTIFY
*----------------------------------------------------------------------------------------------------------------------
* DESCRIPTION
* -----------
* Routine to check the debit account notification
*----------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM, ++ TO +=1
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_GTS.COMMON

    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT


    IF OFS$OPERATION EQ 'PROCESS' AND APPLICATION EQ 'AZ.ACCOUNT' THEN

        LREF.APP = 'ACCOUNT':@FM:'AZ.ACCOUNT'
        LREF.FIELD = 'L.AC.NOTIFY.1':@FM:'L.AZ.DEBIT.ACC'

        GOSUB GET.LRF.POS
        L.AC.NOTIFY.1.POS = LREF.POS<1,1>
        L.AZ.DEBIT.ACC.POS = LREF.POS<2,1>

        GOSUB NOTIFY.VERSION.CHECK
    END

RETURN

*----------------------------------------------------------------------------------------------------------------------
NOTIFY.VERSION.CHECK:
*----------------------------------------------------------------------------------------------------------------------

    IF PGM.VERSION EQ ',REDO.OPEN.SMB' OR PGM.VERSION EQ ',REDO.OPEN.REINV.SMB' OR PGM.VERSION EQ ',REDO.OPEN.CPH' OR PGM.VERSION EQ ',REDO.OPEN.REINV.CPH' OR PGM.VERSION EQ ',REDO.OPEN.INDEX' OR PGM.VERSION EQ ',REDO.OPEN.REINV.INDEX' THEN

        VIRTUAL.TAB.ID = 'L.AC.NOTIFY.1'
        CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)

        Y.LOOKUP.LIST = VIRTUAL.TAB.ID<2>
        Y.LOOKUP.DESC = VIRTUAL.TAB.ID<11>
        CHANGE '_' TO @FM IN Y.LOOKUP.LIST
        CHANGE '_' TO @FM IN Y.LOOKUP.DESC

        FN.ACCOUNT = 'F.ACCOUNT'
        F.ACCOUNT = ''
        CALL OPF(FN.ACCOUNT,F.ACCOUNT)

        DEBIT.ACCT.ARR = R.NEW(AZ.LOCAL.REF)<1,L.AZ.DEBIT.ACC.POS>
        CHANGE @SM TO @FM IN DEBIT.ACCT.ARR
        CHANGE @VM TO @FM IN DEBIT.ACCT.ARR

        LOOP
            REMOVE GET.DEBIT.ACCT FROM DEBIT.ACCT.ARR SETTING DEBIT.ACCT.POS
        WHILE GET.DEBIT.ACCT:DEBIT.ACCT.POS

            GOSUB GET.NOTIFY.MSG
        REPEAT
    END

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.NOTIFY.MSG:
*----------------------------------------------------------------------------------------------------------------------

    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,GET.DEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    GET.NOTIFY.VALUES = R.ACCOUNT<AC.LOCAL.REF,L.AC.NOTIFY.1.POS>
    CHANGE @SM TO @FM IN GET.NOTIFY.VALUES
    NOTIFY.CNT = DCOUNT(GET.NOTIFY.VALUES,@FM)
    CNT = 1
    LOOP
    WHILE CNT LE NOTIFY.CNT
        GET.NOTIFY.VAL =  GET.NOTIFY.VALUES<CNT>
        GOSUB CHECK.NOTIFY
        CNT += 1
    REPEAT
RETURN
*----------------------------------------------------------------------------------------------------------------------
CHECK.NOTIFY:
*----------------------------------------------------------------------------------------------------------------------

    IF R.ACCOUNT AND GET.NOTIFY.VAL NE '' THEN
        LOCATE GET.NOTIFY.VAL IN Y.LOOKUP.LIST SETTING POS1 THEN
            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN        ;* This is for english user
                Y.MESSAGE = Y.LOOKUP.DESC<POS1,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
                Y.MESSAGE = Y.LOOKUP.DESC<POS1,2>         ;* This is for spanish user
            END ELSE
                Y.MESSAGE = Y.LOOKUP.DESC<POS1,1>
            END
        END

        TEXT = 'REDO.DEBIT.PAYMENT':@FM:GET.DEBIT.ACCT:@VM:Y.MESSAGE
        CURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),@VM)+1
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------
GET.LRF.POS:
*----------------------------------------------------------------------------------------------------------------------

    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)

RETURN

*----------------------------------------------------------------------------------------------------------------------
END
