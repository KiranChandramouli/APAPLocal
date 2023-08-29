* @ValidationCode : MjotMTQxODQzODQ1NDpDcDEyNTI6MTY5MzIyODI3ODMzMTpJVFNTOi0xOi0xOi01NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Aug 2023 18:41:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -55
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*28-08-2023    CONVERSION TOOL     R22 AUTO CONVERSION	   INSERT FILE MODIFIED
*28-08-2023    VICTORIA S          R22 MANUAL CONVERSION   DYN.TO.OFS to OFS.BUILD.RECORD
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.FI.LB.APPLY.PYMT.DB(DATA.IN,DATA.OUT)
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
    $INSERT I_RAPID.APP.DEV.COMMON ;*R22 AUTO CONVERSION
    $INSERT I_RAPID.APP.DEV.EQUATE ;*R22 AUTO CONVERSION
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
*    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE> = "ACRP"
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
* Y.OFS.STR = DYN.TO.OFS(R.FUNDS.TRANSFER,'FUNDS.TRANSFER',ADDNL.INFO)
    APP.NAME='FUNDS.TRANSFER' ;*R22 MANUAL CONVERSION START-DYN.TO.OFS to OFS.BUILD.RECORD
    OFS.FUNCTION='I'
    OFS.PROCESS='PROCESS'
    OFS.VERSION=DATA.IN<4>
    Y.GTSMODE=''
    NO.OF.AUTH=''
    TRANSACTION.ID=''
    R.RECORD=R.FUNDS.TRANSFER
    Y.OFS.STR=''
    CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,OFS.PROCESS,OFS.VERSION,Y.GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.RECORD, Y.OFS.STR)
*R22 MANUAL CONVERSION END

    
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
    YERROR.POS = INDEX(OFS.RESP,"-1",1)
    IF YERROR.POS GT 0 THEN
        DATA.OUT = "ERROR"
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
