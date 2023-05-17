SUBROUTINE REDO.FC.REV.VAL
*
* ====================================================================================
*
*

* ====================================================================================
*
* Subroutine Type : Routine to Validate
* Attached to     : REDO.CREATE.ARRANGEMENT.VALIDATIONS
* Attached as     : Called
* Primary Purpose : Validate what objects can be reverse
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

    GOSUB VAL.COLL.ASO.LIMIT
RETURN


* ======
VAL.COLL.ASO.LIMIT:
* ======




    FOR Y.CR = 1 TO Y.COUNT.COLL.RIGHT.NEW
        CALL F.READ(FN.COLLATERAL.RIGHT,COLL.R<1,Y.CR>,R.COLLATERAL.RIGHT,F.COLLATERAL.RIGHT,Y.ERR.COLL.RIGHT)
        IF Y.ERR.COLL.RIGHT  THEN
            ETEXT = "EB-FC-READ.ERROR" : @FM : FN.COLLATERAL.RIGHT
            CALL STORE.END.ERROR
            RETURN
        END
        MAINT.COLL.RIGHT.REF.ID = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE>
        LOCATE Y.AA.LIMIT IN MAINT.COLL.RIGHT.REF.ID<1,1> SETTING LPOS THEN
            DEL MAINT.COLL.RIGHT.REF.ID<1,LPOS>
        END

        Y.COUNT.LIMIT= DCOUNT(MAINT.COLL.RIGHT.REF.ID,@VM)

        IF Y.COUNT.LIMIT EQ "0" THEN


        END ELSE
            CR.ASO<-1>=COLL.R<1,Y.CR>
        END

    NEXT Y.CR


RETURN
*
* =========
OPEN.FILES:
* =========


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
    COLL.R=R.NEW(REDO.FC.ID.COLLATERL.RIGHT)
    Y.COUNT.COLL.RIGHT.NEW = DCOUNT(COLL.R,@VM)
    Y.LIMIT.COT.FILE = R.NEW(REDO.FC.ID.LIMIT)
    Y.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)


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
