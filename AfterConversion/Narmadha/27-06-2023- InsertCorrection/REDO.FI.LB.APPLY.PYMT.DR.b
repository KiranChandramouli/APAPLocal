* @ValidationCode : MjoxNjMwNjcwMDQ1OlVURi04OjE2ODc4NjU1MDM0ODE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Jun 2023 17:01:43
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FI.LB.APPLY.PYMT.DR(DATA.IN,DATA.OUT)
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
*27-06-2023  Narmadha V  Manual R22 Conversion - commented the variable DYN.TO.OFS
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
    $INSERT I_RAPID.APP.DEV.COMMON
    $INSERT I_RAPID.APP.DEV.EQUATE
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
    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE> = DATA.IN<7>
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>   = DATA.IN<3>
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>    = DATA.IN<1>
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>  = DATA.IN<2>
    R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>    = ABS(DATA.IN<6>)
    R.FUNDS.TRANSFER<FT.ORDERING.BANK>="PLANILLA"
*
    ADDNL.INFO<1,1> = DATA.IN<4>
    ADDNL.INFO<1,2> = "I"
*
    ADDNL.INFO<2,1>  = "PROCESS"
    ADDNL.INFO<2,2>  = COMM.USER : "/" : COMM.PW
    ADDNL.INFO<2,3>  = ID.COMPANY
    ADDNL.INFO<2,4>  = ""     ;*    Transaction ID
    ADDNL.INFO<2,5>  = 1
    ADDNL.INFO<2,6>  = "0"    ;*   Authorization Number
*
*    Y.OFS.STR = DYN.TO.OFS(R.FUNDS.TRANSFER,'FUNDS.TRANSFER',ADDNL.INFO);* Manual R22 Conversion
    YWORK.CH  = COMM.USER : "//"
    YWORK.NEW = COMM.USER : "/" : COMM.PW : "/"
    CHANGE YWORK.CH TO YWORK.NEW IN Y.OFS.STR
*


    OFS.SRC<1> = "TAM.OFS.SRC"
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
        DATA.OUT<2> = FIELD(M.VALIDA,"//",1)
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
