* @ValidationCode : MjotMTg4NTUyNDY1MTpDcDEyNTI6MTY4MjQxMjMyODE2MTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.HANDOVER.CHQ
*-----------------------------------------------
*Description: This auth routine is to update the account
*             by removing the cheque return notification.
*-----------------------------------------------
*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO		REFERENCE			 DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.OUTWARD.RETURN

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------
OPEN.FILES:
*-----------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.OUTWARD.RETURN = 'F.REDO.OUTWARD.RETURN'
    F.REDO.OUTWARD.RETURN  = ''
    CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)

    FN.REDO.OUTWARD.RETURN.CHQ = 'F.REDO.OUTWARD.RETURN.CHQ'
    F.REDO.OUTWARD.RETURN.CHQ  = ''
    CALL OPF(FN.REDO.OUTWARD.RETURN.CHQ,F.REDO.OUTWARD.RETURN.CHQ)


    LOC.REF.APPLICATION   = "ACCOUNT"
    LOC.REF.FIELDS        = 'L.AC.NOTIFY.1'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.NOTIFY.1     = LOC.REF.POS<1,1>

RETURN
*-----------------------------------------------
PROCESS:
*-----------------------------------------------
    Y.ACC.ID = R.NEW(CLEAR.RETURN.ACCOUNT)
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        GOSUB CHECK.RETURN.CHEQUES          ;* We need to check whether all return cheques has been handover to customer.
        IF R.REDO.OUTWARD.RETURN.CHQ THEN   ;* Other return cheque for this account available in the system.
            RETURN
        END

        LOCATE 'RETURNED.CHEQUE' IN R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.NOTIFY.1,1> SETTING POS1 THEN
            DEL R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.NOTIFY.1,POS1>
            TEMP.V = V
            V = AC.AUDIT.DATE.TIME
            CALL F.LIVE.WRITE(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT)
            V = TEMP.V
        END

    END

RETURN
*-----------------------------------------------
CHECK.RETURN.CHEQUES:
*-----------------------------------------------

*SEL.CMD = 'SELECT ':FN.REDO.OUTWARD.RETURN:' WITH RETURN.ACCOUNT EQ ':Y.ACC.ID:' AND HANDOVER.STATUS NE Y'
*CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
*LOCATE ID.NEW IN SEL.LIST SETTING POS2 THEN
*DEL SEL.LIST<POS2>
*END
    R.REDO.OUTWARD.RETURN.CHQ = ''
    CALL F.READU(FN.REDO.OUTWARD.RETURN.CHQ,Y.ACC.ID,R.REDO.OUTWARD.RETURN.CHQ,F.REDO.OUTWARD.RETURN.CHQ,CHQ.ERR,'')
    LOCATE ID.NEW IN R.REDO.OUTWARD.RETURN.CHQ SETTING POS1 THEN
        DEL R.REDO.OUTWARD.RETURN.CHQ<POS1>
    END
    CALL F.WRITE(FN.REDO.OUTWARD.RETURN.CHQ,Y.ACC.ID,R.REDO.OUTWARD.RETURN.CHQ)
    CALL F.RELEASE(FN.REDO.OUTWARD.RETURN.CHQ,Y.ACC.ID,F.REDO.OUTWARD.RETURN.CHQ)

RETURN
END
