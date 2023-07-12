SUBROUTINE REDO.FC.S.REV.AA
*
* ====================================================================================
*
*

* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :REVERSE COLLATERAL, COLLATERAL.RIGHT, LIMIT AND INSURANCE THAT WAS CREATE THROUGHT REDO.CREATE.ARRANGEMEMENT TEMPLETE
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:
* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
* ====================
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 2011

*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.LIMIT
    $INSERT I_F.COLLATERAL.RIGHT
    $INSERT I_REDO.FC.COMMON
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_RAPID.APP.DEV.COMMON
    $INSERT I_F.COLLATERAL

*
*************************************************************************
*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:
* ======

    IF CR.ASO THEN
        GOSUB DEL.COLLATERAL.ASO
    END
    GOSUB GET.COLLATERAL
    GOSUB REV.COLLATERAL
    GOSUB REV.COLL.RIGHT
    GOSUB REV.LIMIT
    GOSUB REV.INSURANCE
RETURN

* ======
DEL.COLLATERAL.ASO:
* ======
    Y.COUNT.CR.ASO = DCOUNT(CR.ASO,@VM)
    FOR Y.C.CR.A= 1 TO Y.COUNT.CR.ASO
        LOCATE CR.ASO<1,Y.C.CR.A> IN Y.COLL.R<1,1> SETTING CR.ASO.POS THEN
            DEL Y.COLL.R<1,CR.ASO.POS>
        END
    NEXT Y.C.CR.A

RETURN
* ======
GET.COLLATERAL:
* ======
    Y.COUNT.COLL.RIGHT.NEW = DCOUNT(Y.COLL.R,@VM)
    FOR Y.CR= 1 TO Y.COUNT.COLL.RIGHT.NEW
        Y.COLL.ID<1,Y.CR>=Y.COLL.R<1,Y.CR>:'.':'1'

    NEXT Y.CR

RETURN


* ======
REV.COLLATERAL:
* ======
    Y.COUNT.ID=DCOUNT(Y.COLL.ID,@VM)

    FOR  Y.C.ID = 1 TO Y.COUNT.ID

        Y.APPLICATION  = 'COLLATERAL'
        OFS.INFO.INPUT = ''
        OFS.INFO.INPUT<1,1> = Y.VER.COLLATERAL
        OFS.INFO.INPUT<1,2> = 'R'
        OFS.INFO.INPUT<2,1> = 'PROCESS'
        OFS.INFO.INPUT<2,6> = '0'
        OFS.INFO.INPUT<2,4> = Y.COLL.ID<1,Y.C.ID>
        R.COLL.REV = ''

        R.COLL.REV<COLL.COLLATERAL.TYPE> = Y.COLL.ID<1,Y.C.ID>



        Y.OFS.MSG.REQ = DYN.TO.OFS( R.COLL.REV,Y.APPLICATION, OFS.INFO.INPUT)

* Process OFS Message
        CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
        GOSUB CHECK.PROCESS
        IF PROCESS.ERR THEN
            Y.INT.MONT = '04'
            Y.INFO.DE='COLLATERAL'
            Y.INT.DESC = 'ERROR - REVERSO DE COLLATERAL FALLIDO'
            Y.INT.DATA = Y.OFS.MSG.RES
            Y.NRO.DOCUMENTO=Y.COLL.ID<1,Y.C.ID>
            CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INFO.OR, Y.INFO.DE, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)
*  CALL TRANSACTION.ABORT
            RETURN
        END ELSE

            Y.INT.MONT = '01'
            Y.INT.DESC = 'PROCESO DE REVERSA DE COLLATERAL EXITOSO'
            Y.INFO.DE='COLLATERAL'
            Y.INT.DATA = Y.OFS.MSG.RES
            Y.NRO.DOCUMENTO=Y.COLL.ID<1,Y.C.ID>
            CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INFO.OR, Y.INFO.DE, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC,Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)


        END
    NEXT Y.C.ID



RETURN

*
* =========
REV.COLL.RIGHT:
* =========
*
************************************
*      REVERSE COLLATERAL.RIGHT OFS MESSAGE
************************************

    Y.APPLICATION = 'COLLATERAL.RIGHT'
    Y.COUNT.COLL.RIGHT.NEW = DCOUNT(Y.COLL.R,@VM)
    FOR Y.COUNT.CR = 1 TO Y.COUNT.COLL.RIGHT.NEW
        OFS.INFO.INPUT =''
        OFS.INFO.INPUT<1,1> = Y.VER.COLL.RIGHT
        OFS.INFO.INPUT<1,2> = 'R'
        OFS.INFO.INPUT<2,1> = 'PROCESS'
        OFS.INFO.INPUT<2,6> = '0'
        OFS.INFO.INPUT<2,4> = Y.COLL.R<1,Y.COUNT.CR>
        R.COLL.RIGHT.REV = ''

        R.COLL.RIGHT.REV<COLL.RIGHT.COLLATERAL.CODE> = Y.COLL.R<1,Y.C.ID>



        Y.OFS.MSG.REQ = DYN.TO.OFS(R.COLL.RIGHT.REV,Y.APPLICATION, OFS.INFO.INPUT)

* Process OFS Message
        CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
        GOSUB CHECK.PROCESS
        IF PROCESS.ERR THEN

            Y.INT.MONT = '04'
            Y.INFO.DE='COLLATERAL.RIGHT'
            Y.INT.DESC = 'ERROR - REVERSO DE COLLATERAL RIGHT FALLIDO'
            Y.INT.DATA = Y.OFS.MSG.RES
            Y.NRO.DOCUMENTO=Y.COLL.R<1,Y.COUNT.CR>
            CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INFO.OR, Y.INFO.DE, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)
*  CALL TRANSACTION.ABORT
            RETURN
        END ELSE

            Y.INT.MONT = '01'
            Y.INT.DESC = 'PROCESO DE REVERSA DE COLLATERAL RIGHT EXITOSO'
            Y.INFO.DE='COLLATERAL.RIGHT'
            Y.INT.DATA = Y.OFS.MSG.RES
            Y.NRO.DOCUMENTO=Y.COLL.R<1,Y.COUNT.CR>
            CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INFO.OR, Y.INFO.DE, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)


        END
    NEXT Y.COUNT.CR
RETURN
* ======
REV.LIMIT:
* ======

    Y.APPLICATION = 'LIMIT'


    OFS.INFO.INPUT = ""
    OFS.INFO.INPUT<1,1> = Y.VER.LIMIT
    OFS.INFO.INPUT<1,2> = "R"
    OFS.INFO.INPUT<2,1> = "PROCESS"
    OFS.INFO.INPUT<2,6> = "0"
    OFS.INFO.INPUT<2,4> = Y.AA.LIMIT
    R.LIMIT.REV = ''

    R.LIMIT.REV<LI.LIMIT.CURRENCY> = Y.AA.LIMIT
    Y.OFS.MSG.REQ = DYN.TO.OFS(R.LIMIT.REV,Y.APPLICATION, OFS.INFO.INPUT)

* Process OFS Message
    CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
    GOSUB CHECK.PROCESS
    IF PROCESS.ERR THEN
        Y.INT.MONT = '04'
        Y.INFO.DE='LIMIT'
        Y.INT.DESC = 'ERROR - REVERSO DE LIMIT FALLIDO'
        Y.INT.DATA = Y.OFS.MSG.RES
        Y.NRO.DOCUMENTO=Y.AA.LIMIT
        CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INFO.OR, Y.INFO.DE, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)
*  CALL TRANSACTION.ABORT
        RETURN
    END ELSE

        Y.INT.MONT = '01'
        Y.INT.DESC = 'PROCESO DE REVERSA DE LIMIT EXITOSO'
        Y.INFO.DE='LIMIT'
        Y.INT.DATA = Y.OFS.MSG.RES
        Y.NRO.DOCUMENTO=Y.AA.LIMIT
        CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INFO.OR, Y.INFO.DE, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)

    END

RETURN

* ======
REV.INSURANCE:
* ======

    Y.APPLICATION = 'APAP.H.INSURANCE.DETAILS'
    Y.C.INS=DCOUNT(Y.POLICY.NUMBER,@VM)

    FOR Y.C.I = 1 TO Y.C.INS

        OFS.INFO.INPUT =''
        OFS.INFO.INPUT<1,1> = Y.VER.INSURANCE
        OFS.INFO.INPUT<1,2> = 'R'
        OFS.INFO.INPUT<2,1> = 'PROCESS'
        OFS.INFO.INPUT<2,6> = '0'
        OFS.INFO.INPUT<2,4> = Y.POLICY.NUMBER<1,Y.C.I>
        R.INSURANCE.REV = ''

        R.INSURANCE.REV<INS.DET.INS.POLICY.TYPE> = Y.POLICY.NUMBER<1,Y.C.I>

        Y.OFS.MSG.REQ = DYN.TO.OFS(R.INSURANCE.REV,Y.APPLICATION, OFS.INFO.INPUT)

* Process OFS Message

        CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
        GOSUB CHECK.PROCESS
        IF PROCESS.ERR THEN
            Y.INT.MONT = '04'
            Y.INFO.DE='APAP.H.INSURANSE.DETAILS'
            Y.INT.DESC = 'ERROR - REVERSO DE POLIZA FALLIDO'
            Y.INT.DATA = Y.OFS.MSG.RES
            Y.NRO.DOCUMENTO=Y.POLICY.NUMBER<1,Y.C.I>
            CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INFO.OR, Y.INFO.DE, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)
*  CALL TRANSACTION.ABORT
            RETURN
        END ELSE

            Y.INT.MONT = '01'
            Y.INT.DESC = 'PROCESO DE REVERSA DE POLIZA EXITOSO'
            Y.INFO.DE='APAP.H.INSURANSE.DETAILS'
            Y.INT.DATA = Y.OFS.MSG.RES
            Y.NRO.DOCUMENTO=Y.POLICY.NUMBER<1,Y.C.I>
            CALL REDO.INTERFACE.REC.ACT(Y.INT.CODE, Y.INT.TYPE, '', '', Y.INFO.OR, Y.INFO.DE, Y.NRO.DOCUMENTO, Y.INT.MONT, Y.INT.DESC, Y.INT.DATA, Y.INT.USER, Y.INT.EXPC)

        END

    NEXT Y.C.I

RETURN

CHECK.PROCESS:
    IF E NE '' THEN
        PROCESS.ERR = 1
    END ELSE
        PROCESS.ERR = 0
    END
RETURN



*
* =========
OPEN.FILES:
* =========
*

    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.COLLATERAL.RIGHT,F.COLLATERAL.RIGHT)
    CALL OPF(FN.LIMIT,F.LIMIT)

RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    PROCESS.GOAHEAD = 1
    FN.LIMIT="F.LIMIT"
    F.LIMIT=""

    FN.COLLATERAL.RIGHT="F.COLLATERAL.RIGHT"
    F.COLLATERAL.RIGHT=""
    Y.COLL.R=R.NEW(REDO.FC.ID.COLLATERL.RIGHT)
    Y.COUNT.COLL.RIGHT.NEW = DCOUNT(Y.COLL.R,@VM)
    Y.LIMIT.COT.FILE = R.NEW(REDO.FC.ID.LIMIT)
    Y.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)
    Y.POLICY.NUMBER=R.NEW(REDO.FC.POLICY.NUMBER.AUX)
    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL  = ''
    R.COLLATERAL  = ''

    Y.VER.COLL.RIGHT = "APAP"
    Y.VER.COLLATERAL = "APAP"
    Y.VER.LIMIT   = 'APAP'
    Y.VER.INSURANCE = "FC.OFS"
    R.MSG = ''
    Y.COLL.ID=''

* Variables
    Y.INT.CODE = 'FC001'
    Y.INT.TYPE = 'ONLINE'
    Y.INFO.OR='FC'
    Y.INT.MONT = ''
    Y.INT.DESC = ''
    Y.INT.DATA = ''
    Y.INT.USER = OPERATOR
    Y.INT.EXPC = 'LOCALHOST'  ;* Temp until finding a common variable to set the current terminal which is running the proces




RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                Y.LIMIT.ID.COT.FILE = FMT(Y.LIMIT.COT.FILE,"10'0'R")
                Y.AA.LIMIT = Y.CUSTOMER:".":Y.LIMIT.ID.COT.FILE

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
