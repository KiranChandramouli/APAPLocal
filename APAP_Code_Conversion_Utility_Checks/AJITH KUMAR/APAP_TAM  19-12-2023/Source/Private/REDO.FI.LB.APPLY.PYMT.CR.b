* @ValidationCode : Mjo4NzE3Nzk0ODg6Q3AxMjUyOjE3MDA0ODA1OTIyMDg6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Nov 2023 17:13:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
*DATE			AUTHOR					Modification                        DESCRIPTION
*28/08/2023	 CONVERSION TOOL        AUTO R22 CODE CONVERSION			  RAD.BP is removed in insertfile
*28/08/2023  VIGNESHWARI            MANUAL R22 CODE CONVERSION            DYN.TO.OFS Change to OFS.BUILD.RECORD
*17-11-2023    Santosh             R22 MANUAL CONVERSION   Change as part of For TC-309/314
*-----------------------------------------------------------------------------------------------------------------------
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
*   $INSERT I_RAPID.APP.DEV.COMMON	;*MANUAL R22 CODE CONVERSION
*   $INSERT I_RAPID.APP.DEV.EQUATE	;*MANUAL R22 CODE CONVERSION
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
*    Y.OFS.STR = DYN.TO.OFS(R.FUNDS.TRANSFER,'FUNDS.TRANSFER',ADDNL.INFO)

    APP.NAME     = 'FUNDS.TRANSFER'     ;*MANUAL R22 CODE CONVERSION-START-DYN.TO.OFS Change to OFS.BUILD.RECORD
    OFS.FUNCTION = 'I'
    OFS.PROCESS  = 'PROCESS'
    OFS.VERSION  =  APP.NAME:',':DATA.IN<5> ;*R22 MANUAL CONVERSION- For TC-309/314
    Y.GTSMODE    = ''
    NO.OF.AUTH   = ''
    TRANSACTION.ID = ""
    R.RECORD     =R.FUNDS.TRANSFER
    Y.OFS.STR   = ''
    CALL OFS.BUILD.RECORD(APP.NAME, OFS.FUNCTION, OFS.PROCESS, OFS.VERSION, Y.GTSMODE, NO.OF.AUTH, TRANSACTION.ID, R.RECORD, Y.OFS.STR)   ;*MANUAL R22 CODE CONVERSION-END
    
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
