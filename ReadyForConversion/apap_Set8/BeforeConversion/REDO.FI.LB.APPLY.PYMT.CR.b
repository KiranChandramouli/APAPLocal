*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.FI.LB.APPLY.PYMT.CR(DATA.IN,AA.ARR.ID,DATA.OUT)
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type : Multithreaded ROUTINE - PROCESS
* Attached to     : REDO.FI.COLLECT service
* Attached as     : Service
* Primary Purpose : Apply PAYMENTS reported in APAP-Planillas
*
*
* Incoming:
* ---------
*
*        AA.ARR.ID  -  Contains ID of ARRANGEMENT to be processed
*
*
* Outgoing:
* ---------
*
*        DATA.OUT  -   Process Result
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 26, 2010
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.FUNDS.TRANSFER
*
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.FI.LB.BPROC.DET
*
    $INSERT RAD.BP I_RAPID.APP.DEV.COMMON
    $INSERT RAD.BP I_RAPID.APP.DEV.EQUATE
*
*************************************************************************
*

    IF PROCESS.GOAHEAD THEN
        GOSUB INITIALISE
        GOSUB OPEN.FILES
        GOSUB CHECK.PRELIM.CONDITIONS
        IF PROCESS.GOAHEAD THEN
            GOSUB PROCESS
        END
    END
*
    RETURN
*
* ======
PROCESS:
* ======
*


    R.FUNDS.TRANSFER                      = ""
    ADDNL.INFO                            = ""
*
    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE> = DATA.IN<8>
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>   = AA.ARR.ID
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>    = DATA.IN<3>
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>  = DATA.IN<2>
    R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>    = ABS(DATA.IN<7>)
    R.FUNDS.TRANSFER<FT.ORDERING.BANK>="PLANILLA"
*
    ADDNL.INFO<1,1> = DATA.IN<5>
    ADDNL.INFO<1,2> = "I"
*
    ADDNL.INFO<2,1>  = "PROCESS"
    ADDNL.INFO<2,2>  = COMM.USER : "/" : COMM.PW
    ADDNL.INFO<2,3>  = ID.COMPANY
    ADDNL.INFO<2,4>  = ""     ;*    Transaction ID
    ADDNL.INFO<2,5>  = 1
    ADDNL.INFO<2,6>  = "0"    ;*   Authorization Number
*
    Y.OFS.STR = DYN.TO.OFS(R.FUNDS.TRANSFER,'FUNDS.TRANSFER',ADDNL.INFO)
    YWORK.CH  = COMM.USER : "//"
    YWORK.NEW = COMM.USER : "/" : COMM.PW : "/"
    CHANGE YWORK.CH TO YWORK.NEW IN Y.OFS.STR
*
    OFS.SRC<1> =    "TAM.OFS.SRC"
    OFS.RESP   = ""
    TXN.COMMIT = ""
    YERROR.POS = 0
*


    CALL OFS.CALL.BULK.MANAGER(OFS.SRC, Y.OFS.STR, OFS.RESP, TXN.COMMIT)

    M.VALIDA = FIELD(OFS.RESP,"//",1)
*    OUT.ERR<1> = OFS.RESP
    OUT.RESP<1> = M.VALIDA
    YERROR.POS = INDEX(M.VALIDA,"-1",1)

    IF YERROR.POS GT 0 THEN
        DATA.OUT<1> = "FAILURE"
    END ELSE
        DATA.OUT<1> = "SUCCESS"
        Y.FT.ID = FIELD(M.VALIDA,"//",1)
        CHANGE "<requests><request>" TO "" IN Y.FT.ID
        DATA.OUT<2> = Y.FT.ID
    END
*
    RETURN
*
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 1
*
    DATA.OUT = ""
*
    RETURN
*
* =========
OPEN.FILES:
* =========
*

    RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

        CASE LOOP.CNT EQ 1


        END CASE

        LOOP.CNT +=1
    REPEAT
*
    RETURN
*

END
