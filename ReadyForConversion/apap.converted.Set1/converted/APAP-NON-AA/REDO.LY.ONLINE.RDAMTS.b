SUBROUTINE  REDO.LY.ONLINE.RDAMTS
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to make to round the quantity/amount of available and used points
*              in record <CUS.ID>ONLINEDEB in REDO.LY.POINTS.TOT during use of points for DC txns.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.ONLINE.RDAMTS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*29.05.2014    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.LY.POINTS.US
    $INSERT I_F.REDO.LY.MASTERPRGDR
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    FN.REDO.LY.MASTERPRGDR = 'F.REDO.LY.MASTERPRGDR'
    F.REDO.LY.MASTERPRGDR = ''
    CALL OPF(FN.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR)

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

RETURN

*-------
PROCESS:
*-------

    CUS.ID = R.NEW(REDO.PT.US.CUSTOMER.NO)
    Y.PTS.QTYORVAL = R.NEW(REDO.PT.US.QTYORVAL)
    Y.PTS.QTYORVAL.AMT = R.NEW(REDO.PT.US.QTYORVAL.TO.US)

    Y.PTS.QTYORVAL.AMT = FMT(Y.PTS.QTYORVAL.AMT,0)

    GOSUB READ.MASTER.PROGRAM

    IF Y.PTS.QTYORVAL EQ 'Puntos' THEN
        Y.POINT.VAL = Y.PTS.QTYORVAL.AMT * Y.PT.VALUE
        Y.POINT.VAL = FMT(Y.POINT.VAL,0)
        Y.POINT = FMT(Y.PTS.QTYORVAL.AMT,0)
    END ELSE
        Y.POINT = Y.PTS.QTYORVAL.AMT / Y.PT.VALUE
        Y.POINT = FMT(Y.POINT,0)
        Y.POINT.VAL = FMT(Y.PTS.QTYORVAL.AMT,0)
    END

    GOSUB UPD.PTS.ONLINE

RETURN

*-------------------
READ.MASTER.PROGRAM:
*-------------------

    MASPRG.ID = 'SYSTEM'
    R.MASPRG = ''; MASPRG.ERR = ''
    CALL CACHE.READ(FN.REDO.LY.MASTERPRGDR,MASPRG.ID,R.MASPRG,MASPRG.ERR)
    IF R.MASPRG THEN
        Y.PRG.ID = R.MASPRG<REDO.MASPRG.MASTER.PRG>
    END

    R.PRG = ''; PRG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.PRG.ID,R.PRG,F.REDO.LY.PROGRAM,PRG.ERR)
    IF R.PRG THEN
        Y.PT.VALUE = R.PRG<REDO.PROG.POINT.VALUE>
    END

RETURN

*--------------
UPD.PTS.ONLINE:
*--------------

    TOT.POINTS.ID = CUS.ID:'ONLINEDEB'
    R.REDO.LY.POINTS.TOT =''
    CALL F.READ(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
    Y.REST.TO.AV = 'Y'
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT.TOT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)

RETURN

*-----------
UPD.PROCESS:
*-----------

    VAR.AVAIL = 0 ; VAR.AVAIL.VALUE = 0
    VAR.USED = 0 ; VAR.USED.VALUE = 0

    IF R.REDO.LY.POINTS.TOT EQ '' THEN
        VAR.AVAIL = 0
        VAR.AVAIL.VALUE = 0
        VAR.USED = 0
        VAR.USED.VALUE = 0
    END ELSE
        VAR.AVAIL = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
        VAR.AVAIL.VALUE = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>
        VAR.USED = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS>
        VAR.USED.VALUE = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.VALUE>
    END

    VAR.USED += Y.POINT
    VAR.USED.VALUE += Y.POINT.VAL

    IF Y.REST.TO.AV EQ 'Y' THEN
        VAR.AVAIL -= Y.POINT
        VAR.AVAIL.VALUE -= Y.POINT.VAL
        R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS> = VAR.AVAIL
        R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE> = VAR.AVAIL.VALUE
    END

    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS> = VAR.USED
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.VALUE> = VAR.USED.VALUE

RETURN

*----------------
ASSIGN.AUDIT.TOT:
*----------------

    CURR.NO = ''
    CUR.TIME = OCONV(TIME(), "MT")

    CHANGE ':' TO '' IN CUR.TIME
    CURR.NO = R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO>
    IF CURR.NO EQ '' THEN
        CURR.NO = 1
    END ELSE
        CURR.NO += 1
    END
    R.REDO.LY.POINTS.TOT<REDO.PT.T.RECORD.STATUS> = ''
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO> = CURR.NO
    R.REDO.LY.POINTS.TOT<REDO.PT.T.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DATE.TIME> = G.DATE[3,6]:CUR.TIME
    R.REDO.LY.POINTS.TOT<REDO.PT.T.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CO.CODE> = ID.COMPANY
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DEPT.CODE> = 1

RETURN

*----------------------------------------------------------------------------------
END
