SUBROUTINE REDO.DS.ST.ALT.IDS(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.SECURITY.TERM
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*28-Mar-10      Pradeep S     PACS00051213      Mapping changed to Alt Sec ID
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''

RETURN

OPENFILES:
**********
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
RETURN

PROCESS:
********

    SEC.TRADE.ID = Y.RET

    SEC.CODE.ID = R.NEW(SC.SBS.SECURITY.CODE)

    CALL F.READ(FN.SECURITY.MASTER,SEC.CODE.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,SECURITY.MASTER.ERR)
    Y.ALT.SECURITY.ID = R.SECURITY.MASTER<SC.SCM.ALT.SECURITY.ID>
    Y.ALT.SECURITY.NO = R.SECURITY.MASTER<SC.SCM.ALT.SECURITY.NO>       ;*PACS00051213 - S/E

    LOCATE "ALT-COD-EMI" IN Y.ALT.SECURITY.ID<1,1> SETTING POS THEN
*PACS00051213 - S
*  Y.SERIES.NO = Y.ALT.SECURITY.ID<1,POS>
        Y.SERIES.NO = Y.ALT.SECURITY.NO<1,POS>
*PACS00051213 - E
    END

    Y.RET = Y.SERIES.NO
RETURN

END
