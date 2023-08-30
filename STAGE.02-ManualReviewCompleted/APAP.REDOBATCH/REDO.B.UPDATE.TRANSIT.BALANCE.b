* @ValidationCode : MjotMzI4NDAxNTY1OkNwMTI1MjoxNjgxNzA3Njc3NDQzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:31:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPDATE.TRANSIT.BALANCE(Y.TRANS.ID)
*--------------------------------------------------------------
*Description: This is the batch routine to update the transit balance
*             based on the release of ALE.
*Modification
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND ++ TO += 1 
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_REDO.B.UPDATE.TRANSIT.BALANCE.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
* Main Process

    CALL OCOMO("Processing for the date: ":Y.TRANS.ID)
    CALL F.READ(FN.REDO.TRANSIT.ALE,Y.TRANS.ID,R.REDO.TRANSIT.ALE,F.REDO.TRANSIT.ALE,TRANS.ERR)

    IF R.REDO.TRANSIT.ALE ELSE
        CALL OCOMO("Record not exist for the date - ":Y.TRANS.ID)
        CALL F.DELETE(FN.REDO.TRANSIT.ALE,Y.TRANS.ID)
        RETURN
    END
    Y.FINAL.IDS = ''
    Y.ALE.IDS = R.REDO.TRANSIT.ALE
    Y.ALE.CNT = DCOUNT(Y.ALE.IDS,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.ALE.CNT
        Y.ALE.ID = Y.ALE.IDS<Y.VAR1>
        R.ALE = ''
        CALL F.READ(FN.AC.LOCKED.EVENTS,Y.ALE.ID,R.ALE,F.AC.LOCKED.EVENTS,ALE.ERR)
        IF R.ALE THEN
            CALL OCOMO("ALE Record exist - ":Y.ALE.ID)
            Y.FINAL.IDS<-1> = Y.ALE.ID
        END ELSE        ;*If ALE not exist then it has been reversed by Core. Then Update Transit balance.
            GOSUB UPDATE.PROCESS
        END

        Y.VAR1 += 1
    REPEAT
    GOSUB REMOVE.ID

RETURN
*-------------------------------------------------
UPDATE.PROCESS:
*-------------------------------------------------
    CALL EB.READ.HISTORY.REC(F.AC.LOCKED.EVENTS.HIS,Y.ALE.ID,R.ALE.HIS,ALE.HIS.ERR)
    IF R.ALE.HIS THEN
        CALL OCOMO("Updation Process started for the ALE - ":Y.ALE.ID)
    END ELSE
        RETURN
    END
    Y.ACCOUNT.ID = R.ALE.HIS<AC.LCK.ACCOUNT.NUMBER>
    Y.LOCK.AMT   = R.ALE.HIS<AC.LCK.LOCKED.AMOUNT>
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        Y.TRANSIT.BALANCE = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.TRAN.AVAIL>
        IF (Y.TRANSIT.BALANCE - Y.LOCK.AMT) LT 0 THEN
            R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.TRAN.AVAIL> = 0       ;* Transit Balance cannot be negative, So update
        END ELSE
            R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.TRAN.AVAIL> = Y.TRANSIT.BALANCE - Y.LOCK.AMT
        END

        TEMP.V = V
        V = AC.AUDIT.DATE.TIME
        CALL F.LIVE.WRITE(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT)
        V = TEMP.V
        CALL OCOMO("Updation Process completed for the ALE - ":Y.ALE.ID)
    END ELSE
        CALL OCOMO("No Account record exist")
    END

RETURN
*----------------------------------------------------
REMOVE.ID:
*----------------------------------------------------
    IF Y.FINAL.IDS THEN
        CALL F.WRITE(FN.REDO.TRANSIT.ALE,Y.TRANS.ID,Y.FINAL.IDS)
        CALL OCOMO("Unprocessed IDS has been updated.")
    END ELSE
        CALL F.DELETE(FN.REDO.TRANSIT.ALE,Y.TRANS.ID)
    END

RETURN
END
