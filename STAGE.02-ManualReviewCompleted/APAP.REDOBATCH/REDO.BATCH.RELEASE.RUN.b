* @ValidationCode : MjotNDI3Mzg2NzM2OkNwMTI1MjoxNjgxNzA5Mjk3OTIxOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:58:17
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
SUBROUTINE REDO.BATCH.RELEASE.RUN

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : KAVITHA S
* Program Name  : REDO.BATCH.RELEASE.RUN
*-------------------------------------------------------------------------
* Description: This routine is a RUN routine used to release clearing batch
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-12-10          TAM-ODR-2010-09-0148              Initial Creation
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND CONVERT TO CHANGE
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES

*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.BATCH.RELEASE
    $INSERT I_F.REDO.CLEARING.OUTWARD

    FN.REDO.OUT = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.OUT = ''
    CALL OPF(FN.REDO.OUT,F.REDO.OUT)



    BATCH.NO = R.NEW(BATCH.REL.BATCH.NO)

    SEL.CMD = 'SELECT ':FN.REDO.OUT:' WITH BATCH EQ ':BATCH.NO:' AND BATCH.RELEASED EQ N AND DATE LT ':TODAY

    CALL EB.READLIST(SEL.CMD,SEL.LST,'',NO.REC,SEL.ERR)
    IF NOT(SEL.LST) THEN
        AF = BATCH.REL.BATCH.NO
        ETEXT = 'EB-INVALID.BATCH'
        CALL STORE.END.ERROR

    END ELSE
        LOOP
            REMOVE RCO.ID FROM SEL.LST SETTING RCO.POS
        WHILE RCO.ID:RCO.POS

            CALL F.READ(FN.REDO.OUT,RCO.ID,R.RCO,F.REDO.OUT,RCO.ERR)
            IF R.RCO THEN
                R.RCO<CLEAR.OUT.CHQ.STATUS> = "CLEARED"
                R.RCO<CLEAR.OUT.BATCH.RELEASED> = "Y"
                TEMP.V = V
                V = CLEAR.OUT.AUDIT.DATE.TIME
                CALL F.LIVE.WRITE(FN.REDO.OUT,RCO.ID,R.RCO)
                V = TEMP.V
                ALE.IDS =  R.RCO<CLEAR.OUT.AC.LOCK.ID>
            END
            IF ALE.IDS THEN
                ALE.CNTR = DCOUNT(ALE.IDS,@VM)
                CHANGE @VM TO @FM IN ALE.IDS  ;*R22 AUTO CONVERSTION CONVERT TO CHANGE

                LOOP.CNTR = 1
                LOOP
                WHILE LOOP.CNTR LE ALE.CNTR
                    AC.LOCK.ID = ALE.IDS<LOOP.CNTR>
                    GOSUB REVERSE.ALE

                    LOOP.CNTR += 1
                REPEAT
            END
        REPEAT
        CALL JOURNAL.UPDATE("")
    END

RETURN

*---------------------------------------------------------------------
REVERSE.ALE:

    OFS.STR = "AC.LOCKED.EVENTS,OFS/R/PROCESS,/":ID.COMPANY:",":AC.LOCK.ID:","

    OFS.SRC= 'REDO.CHQ.ISSUE'
    OFS.MSG.ID = ''
    OPTIONS = ''
    CALL OFS.POST.MESSAGE(OFS.STR,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN
*------------------------------------------------------------------------

END
