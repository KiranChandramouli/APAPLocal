* @ValidationCode : MjotOTY5MTQwNzQwOkNwMTI1MjoxNzAzMDc0NzgyMjQ3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Dec 2023 17:49:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.GET.EXPIRED.LOCK
*--------------------------------------------------------------------------------
* select account numbers from ac.locked.events
* save the ids to a concat table REDO.LOCK.EXP.LIST
* RUN this job before FILE.TIDY.UP

** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.AC.LOCKED.EVENTS
*************************************************************************

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS)

    FN.REDO.LOCK.EXP.LIST = 'F.REDO.LOCK.EXP.LIST'
    F.REDO.LOCK.EXP.LIST = ''
    CALL OPF(FN.REDO.LOCK.EXP.LIST, F.REDO.LOCK.EXP.LIST)
    REC.IDS =''
    L.WORK.DATE = TODAY

*  SEL.CMD  = 'SELECT ' :FN.AC.LOCKED.EVENTS : ' WITH TO.DATE LE ' : L.WORK.DATE : " AND TO.DATE NE '' SAVING UNIQUE ACCOUNT.NUMBER BY ACCOUNT.NUMBER"
    SEL.CMD  = 'SELECT ' :FN.AC.LOCKED.EVENTS : ' WITH TO.DATE LE ' : DQUOTE(L.WORK.DATE) : " AND TO.DATE NE ''"
    CALL EB.READLIST(SEL.CMD, AC.NOS, '', '', '')
    LOOP
        REMOVE Y.AC.LOCK.ID FROM AC.NOS SETTING Y.POS
    WHILE Y.AC.LOCK.ID:Y.POS
        CALL F.READ(FN.AC.LOCKED.EVENTS,Y.AC.LOCK.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,AC.ERR)
        IF R.AC.LOCKED.EVENTS THEN
            AC.ID =R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>
            IF NOT(NUM(AC.ID)) THEN
                AC.ID = FIELD(AC.ID,'\',1)
            END
            LOCATE AC.ID IN REC.IDS BY 'AL' SETTING POS THEN
            END ELSE
*                REC.IDS<-1> = AC.ID
                INS AC.ID BEFORE REC.IDS<POS>
            END
        END
    REPEAT

    CALL F.WRITE(FN.REDO.LOCK.EXP.LIST, L.WORK.DATE, REC.IDS)

RETURN

END
