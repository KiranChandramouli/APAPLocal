* @ValidationCode : MjoxMTEzMzIzMzk5OkNwMTI1MjoxNjgxMTIxMjU0MzMxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 15:37:34
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.UPDATE.TRANSIT.BALANCE
*--------------------------------------------------------------------------
*Description: This routine is to update the L.AC.TRAN.AVAIL in Account
*             when the ALE gets created/Reversed during clearing.
*--------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.LOCKED.EVENTS

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------
OPENFILES:
*--------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.TRANSIT.ALE = 'F.REDO.TRANSIT.ALE'
    F.REDO.TRANSIT.ALE  = ''
    CALL OPF(FN.REDO.TRANSIT.ALE,F.REDO.TRANSIT.ALE)

    LOC.REF.APPLICATION   = "ACCOUNT"
    LOC.REF.FIELDS        = 'L.AC.TRAN.AVAIL'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.TRAN.AVAIL = LOC.REF.POS<1,1>

RETURN
*--------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------

    IF V$FUNCTION EQ 'I' OR R.NEW(AC.LCK.RECORD.STATUS)[1,2] EQ 'IN' THEN         ;* During Input, Logic to handle both single and zero Auth.
        GOSUB PROCESS.INPUT
    END

    IF V$FUNCTION EQ 'R' OR R.NEW(AC.LCK.RECORD.STATUS)[1,2] EQ 'RN' THEN         ;* During Reverse, Logic to handle both single and zero Auth.
        GOSUB PROCESS.REVERSAL
    END
RETURN
*--------------------------------------------------------------------------
PROCESS.INPUT:
*--------------------------------------------------------------------------
* During Input of ALE.
    GOSUB UPDATE.CONCAT.INPUT
    IF R.NEW(AC.LCK.CURR.NO) EQ 1 THEN
        Y.NEW.LOCK.BAL = R.NEW(AC.LCK.LOCKED.AMOUNT)
    END ELSE          ;* If ALE has been modified for second time. then check the amount diff, if amt diff exist update. else dont update.
        IF R.NEW(AC.LCK.LOCKED.AMOUNT) NE R.OLD(AC.LCK.LOCKED.AMOUNT) THEN
            Y.NEW.LOCK.BAL = R.NEW(AC.LCK.LOCKED.AMOUNT) - R.OLD(AC.LCK.LOCKED.AMOUNT)
        END ELSE
            RETURN
        END
    END


    Y.ACC.ID = R.NEW(AC.LCK.ACCOUNT.NUMBER)
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.TRANSIT.BALANCE = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.TRAN.AVAIL>

    R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.TRAN.AVAIL> = Y.TRANSIT.BALANCE + Y.NEW.LOCK.BAL

    TEMP.V = V
    V = AC.AUDIT.DATE.TIME
    CALL F.LIVE.WRITE(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT)
    V = TEMP.V

RETURN
*--------------------------------------------------------------------------
UPDATE.CONCAT.INPUT:
*--------------------------------------------------------------------------

    IF R.NEW(AC.LCK.TO.DATE) EQ R.OLD(AC.LCK.TO.DATE) THEN
        Y.TO.DATE = R.NEW(AC.LCK.TO.DATE)
        IF Y.TO.DATE THEN
            CALL F.READU(FN.REDO.TRANSIT.ALE,Y.TO.DATE,R.REDO.TRANSIT.ALE,F.REDO.TRANSIT.ALE,ERR,'')
            LOCATE ID.NEW IN R.REDO.TRANSIT.ALE<1> SETTING POS1 ELSE
                R.REDO.TRANSIT.ALE<-1> = ID.NEW
                CALL F.WRITE(FN.REDO.TRANSIT.ALE,Y.TO.DATE,R.REDO.TRANSIT.ALE)
            END
        END
    END ELSE
        Y.NEW.DATE = R.NEW(AC.LCK.TO.DATE)
        Y.OLD.DATE = R.OLD(AC.LCK.TO.DATE)
        IF Y.NEW.DATE THEN
            CALL F.READU(FN.REDO.TRANSIT.ALE,Y.NEW.DATE,R.REDO.TRANSIT.ALE,F.REDO.TRANSIT.ALE,ERR,'')
            LOCATE ID.NEW IN R.REDO.TRANSIT.ALE<1> SETTING POS1 ELSE
                R.REDO.TRANSIT.ALE<-1> = ID.NEW
                CALL F.WRITE(FN.REDO.TRANSIT.ALE,Y.NEW.DATE,R.REDO.TRANSIT.ALE)
            END
        END
        CALL F.READU(FN.REDO.TRANSIT.ALE,Y.OLD.DATE,R.REDO.TRANSIT.ALE,F.REDO.TRANSIT.ALE,ERR,'')
        IF R.REDO.TRANSIT.ALE THEN
            LOCATE ID.NEW IN R.REDO.TRANSIT.ALE<1> SETTING POS1 THEN
                DEL R.REDO.TRANSIT.ALE<POS1>
                CALL F.WRITE(FN.REDO.TRANSIT.ALE,Y.OLD.DATE,R.REDO.TRANSIT.ALE)
            END
        END
    END

RETURN
*--------------------------------------------------------------------------
PROCESS.REVERSAL:
*--------------------------------------------------------------------------
* During Reversal of ALE.

    Y.ACC.ID = R.NEW(AC.LCK.ACCOUNT.NUMBER)
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)


    Y.TRANSIT.BALANCE = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.TRAN.AVAIL>
    Y.LOCK.AMOUNT     = R.NEW(AC.LCK.LOCKED.AMOUNT)
    IF (Y.TRANSIT.BALANCE - Y.LOCK.AMOUNT) LT 0 THEN
        R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.TRAN.AVAIL> = 0         ;* Transit Balance cannot be negative, So updated as 0.
    END ELSE
        R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.TRAN.AVAIL> = Y.TRANSIT.BALANCE - Y.LOCK.AMOUNT
    END

    TEMP.V = V
    V = AC.AUDIT.DATE.TIME
    CALL F.LIVE.WRITE(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT)
    V = TEMP.V
    Y.TO.DATE = R.NEW(AC.LCK.TO.DATE)
    CALL F.READU(FN.REDO.TRANSIT.ALE,Y.TO.DATE,R.REDO.TRANSIT.ALE,F.REDO.TRANSIT.ALE,ERR,'')
    IF R.REDO.TRANSIT.ALE THEN
        LOCATE ID.NEW IN R.REDO.TRANSIT.ALE<1> SETTING POS1 THEN
            DEL R.REDO.TRANSIT.ALE<POS1>
            CALL F.WRITE(FN.REDO.TRANSIT.ALE,Y.TO.DATE,R.REDO.TRANSIT.ALE)
        END
    END
RETURN
END
