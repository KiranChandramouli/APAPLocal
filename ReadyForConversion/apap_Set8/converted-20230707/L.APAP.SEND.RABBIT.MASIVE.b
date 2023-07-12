* Version 2 02/06/00 GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.SEND.RABBIT.MASIVE(APP,VERSION,RECORDID,QUEUEOUT)
*-----------------------------------------------------------------------------
* Modification History

*-----------------------------------------------------------------------------
* Creation: ARCADIO RUIZ
* Creation Date: 2020/05/14
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_TSS.COMMON
    $INSERT I_F.ST.L.APAP.RABBIT.QUEUE
    $INSERT I_F.DATES


    GOSUB INITIALISE
    GOSUB WRITEQUEUE

RETURN

INITIALISE:


    FN.L.APAP.RABBIT.QUEUE = 'F.ST.L.APAP.RABBIT.QUEUE'
    F.L.APAP.RABBIT.QUEUEE = ''
    CALL OPF(FN.L.APAP.RABBIT.QUEUE, F.L.APAP.RABBIT.QUEUE)

RETURN

WRITEQUEUE:

    Y.MSG<1> = APP : VERSION
    Y.MSG<2> = APP : '>' : RECORDID
    Y.MSG<3> = QUEUEOUT
    Y.DATE = DATE()

    Y.MSG<8> = R.DATES(EB.DAT.TODAY)


    Y.DATE = OCONV(Y.DATE,"DY") : FMT(OCONV(Y.DATE,"DM"),"2'0'R") : FMT(OCONV(Y.DATE,"DD"),"2'0'R")

    Y.TIME = TIME()
    Y.TIME = OCONV(Y.TIME,'MTS')

    CALL ALLOCATE.UNIQUE.TIME(Y.MSG.ID)

    Y.ID.SEQ = EREPLACE(Y.MSG.ID,'.','')
    Y.ID.SEQ = DATE(): Y.ID.SEQ
    Y.MSG.ID = DATE(): Y.MSG.ID

    CALL F.WRITE(FN.L.APAP.RABBIT.QUEUE, Y.MSG.ID, Y.MSG)

RETURN

END
