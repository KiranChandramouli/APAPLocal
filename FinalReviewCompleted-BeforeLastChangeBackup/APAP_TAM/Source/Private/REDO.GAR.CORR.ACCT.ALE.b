* @ValidationCode : MjoxNTY5ODQ1MzE6Q3AxMjUyOjE2ODA2OTc3ODc4MTc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 17:59:47
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
SUBROUTINE REDO.GAR.CORR.ACCT.ALE
*------------------------------------------------------------------------------
*Written by :Prabhu
*This routine is  correction to the table REDO.ACCT.ALE. This table should have
*only valid garnishment records
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - $INCLUDE TO $INSERT
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON          ;** R22 Auto conversion - $INCLUDE TO $INSERT
    $INSERT I_EQUATE          ;** R22 Auto conversion - $INCLUDE TO $INSERT

    FN.REDO.ACCT.ALE='F.REDO.ACCT.ALE'
    F.REDO.ACCT.ALE =''
    CALL OPF(FN.REDO.ACCT.ALE,F.REDO.ACCT.ALE)

    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS =''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------

    Y.SEL.CMD='SELECT ':FN.REDO.ACCT.ALE
    CALL EB.READLIST(Y.SEL.CMD,Y.SEL.LIST,'',Y.SEL.CNT,Y.ERR)

    LOOP
        REMOVE Y.ACCT.ALE.ID FROM Y.SEL.LIST SETTING Y.ACCT.ALE.POS
    WHILE Y.ACCT.ALE.ID:Y.ACCT.ALE.POS

        R.REDO.ACCT.ALE=''

        CALL F.READ(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.REDO.ACCT.ALE,F.REDO.ACCT.ALE,Y.ERR)
        IF R.REDO.ACCT.ALE THEN
            GOSUB PROCESS.ACCT.ALE
        END
        ELSE
            CALL F.DELETE(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID)
        END
        Y.ACCT.ALE.ID = ''
    REPEAT
RETURN
*----------------
PROCESS.ACCT.ALE:
*----------------
    Y.ALE.ID.LIST    =R.REDO.ACCT.ALE
    Y.NEW.ALE.ID.LIST=''

    LOOP
        REMOVE Y.ALE.ID FROM Y.ALE.ID.LIST SETTING Y.ALE.POS
    WHILE Y.ALE.ID:Y.ALE.POS
        CALL F.READ(FN.AC.LOCKED.EVENTS,Y.ALE.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,Y.ERR)
        IF R.AC.LOCKED.EVENTS THEN
            Y.NEW.ALE.ID.LIST<-1>=Y.ALE.ID
        END
        Y.ALE.ID=''
    REPEAT
    R.REDO.ACCT.ALE=Y.NEW.ALE.ID.LIST
    CALL F.WRITE(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.REDO.ACCT.ALE)
    CALL JOURNAL.UPDATE(Y.ACCT.ALE.ID)
RETURN
END
