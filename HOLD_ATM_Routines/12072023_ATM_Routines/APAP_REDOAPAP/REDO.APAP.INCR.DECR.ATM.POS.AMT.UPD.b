SUBROUTINE REDO.APAP.INCR.DECR.ATM.POS.AMT.UPD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.INCR.DECR.ATM.POS.AMT.UPD
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.INCR.DECR.ATM.POS.AMT.UPD is a mainline routine for the template LATAM.CARD.LIM.DEF,
*                    the routine is called in the authorisation routine LATAM.CARD.LIM.DEF.AUTHORISE and is used to update the local concat file REDO.INCR.DECR.ATM.POS.AMT
*                    on authorising the template LATAM.CARD.LIM.DEF
*In Parameter      :N/A
*Out Parameter     :N/A
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference                      Description
*   ------         ------               -------------                    -------------
*  02/09/2010      MD.PREETHI          ODR-2010-03-0106 131             Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.LIM.DEF
    $INSERT I_F.REDO.INCR.DECR.ATM.POS.AMT

    GOSUB INIT
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN

INIT:
*****
    FN.REDO.INCR.DECR.ATM.POS.AMT='F.REDO.INCR.DECR.ATM.POS.AMT'
    F.REDO.INCR.DECR.ATM.POS.AMT=''

RETURN

OPEN.PARA:
**********
    CALL OPF(FN.REDO.INCR.DECR.ATM.POS.AMT,F.REDO.INCR.DECR.ATM.POS.AMT)

RETURN

PROCESS.PARA:
*************
    Y.CALI.CARD.TYPE = ID.NEW

    Y.CALI.CARD.LIM.CCY=R.NEW(LATAM.CALI.DEF.CCY.OF.BIN)

    CHECK.DATE=DATE()
    Y.TODAY=OCONV(CHECK.DATE,"DY4"):FMT(OCONV(CHECK.DATE,"DM"),'R%2'):FMT(OCONV(CHECK.DATE,"DD"),'R%2')

    REDO.INCR.DECR.ATM.POS.AMT.ID = Y.TODAY:'-':Y.CALI.CARD.TYPE

    CALL F.READ(FN.REDO.INCR.DECR.ATM.POS.AMT,REDO.INCR.DECR.ATM.POS.AMT.ID,R.REDO.INCR.DECR.ATM.POS.AMT,F.REDO.INCR.DECR.ATM.POS.AMT,Y.INCR.DECR.ERR)
    Y.CARD.CCY.DETAILS=DCOUNT(Y.CALI.CARD.LIM.CCY,@VM)
    Y.CARD.CCY.INIT=1

    LOOP
    WHILE Y.CARD.CCY.INIT LE Y.CARD.CCY.DETAILS
        R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.MX.ATM.TRAN.LIM,Y.CARD.CCY.INIT> = R.NEW(LATAM.CALI.DEF.MX.ATM.TRAN.LIM)<1,Y.CARD.CCY.INIT>
        R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.MX.POS.TRAN.LIM,Y.CARD.CCY.INIT> = R.NEW(LATAM.CALI.DEF.MX.POS.TRAN.LIM)<1,Y.CARD.CCY.INIT>
        R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.LIM.CCY,Y.CARD.CCY.INIT>=R.NEW(LATAM.CALI.DEF.CCY.OF.BIN)<1,Y.CARD.CCY.INIT>

        Y.TEMPTIME=OCONV(TIME(),"MTS")
        Y.TEMPTIME=Y.TEMPTIME[1,5]
        CHANGE ':' TO '' IN Y.TEMPTIME
        CHECK.DATE=DATE()
        Y.DATE.TIME=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),'R%2'):FMT(OCONV(CHECK.DATE,"DD"),'R%2'):Y.TEMPTIME
        R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.REC.DATE.TIME>=Y.DATE.TIME

        CALL F.WRITE(FN.REDO.INCR.DECR.ATM.POS.AMT,REDO.INCR.DECR.ATM.POS.AMT.ID,R.REDO.INCR.DECR.ATM.POS.AMT)
        Y.CARD.CCY.INIT += 1

    REPEAT
RETURN
END
