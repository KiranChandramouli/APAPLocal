* @ValidationCode : MjotMTYzNDAxODkyODpDcDEyNTI6MTcwMzY4MDYwMTcwMDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Dec 2023 18:06:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.CHEQUE.NUMBER
***********************************************************************
*
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JOAQUIN COSTA C.
*
*----------------------------------------------------------------------
*
*   GET NEXT AVAILABLE CHEQUE NUMBER - UPDATES CONTROL TABLE
*
*   AUTH ROUTINE for ADMINISTRATIVE CHEQUES
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*
*    DATE         WHO              REFERENCE                           DESCRIPTION
*17-11-2011   Joaquin Costa        GRUPO 4                            PACS00172909
*06-04-2023    Conversion Tool      R22 Auto Code conversion          No Changes
* 28-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*06-04-2023     Samaran T           R22 Manual Code Conversion         No Changes
*
*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
*
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
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
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
*CALL F.READ(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.AVAILABLE.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,ERR)
    CALL F.READU(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.AVAILABLE.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,ERR,'');*R22 MANUAL CODE CONVERSION
    IF R.REDO.H.ADMIN.CHEQUES THEN
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> = "ISSUED"
        W.NEXT.AVAILABLE.ID                       = R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.SERIAL.NO>
        CALL F.WRITE(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.AVAILABLE.ID,R.REDO.H.ADMIN.CHEQUES)
    END
*
RETURN
*
* ==============================
GET.NEXT.AVAILABLE.CHECK.NUMBER:
* ==============================
*
    BEGIN CASE
        CASE APPLICATION EQ 'TELLER'
            Y.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
            Y.CUST    = ""
            CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
            IF R.ACCOUNT THEN
                Y.CUST = R.ACCOUNT<AC.CUSTOMER>
            END
            IF Y.CUST THEN
                Y.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
            END
            GOSUB GET.CHECK.NUMBER
            R.NEW(TT.TE.CHEQUE.NUMBER) = Y.NEXT.AVAILABLE.ID

        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            IF R.NEW(FT.CREDIT.THEIR.REF) THEN
                Y.ACCOUNT = R.NEW(FT.CREDIT.ACCT.NO)
                GOSUB GET.CHECK.NUMBER
                R.NEW(FT.CREDIT.THEIR.REF) = Y.NEXT.AVAILABLE.ID
            END
    END CASE
*
RETURN
*
*----------------------------------------------------------------------
GET.CHECK.NUMBER:
*----------------------------------------------------------------------
*
* To get the next available from the received list of @ID'S
*
    LOCATE Y.ACCOUNT IN R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,1> SETTING POS1 THEN
        Y.ITEM.CODE = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE,POS1>
    END
*
    SEL.CMD  = 'SSELECT ' : FN.REDO.H.ADMIN.CHEQUES
    SEL.CMD := ' WITH ITEM.CODE EQ ' : Y.ITEM.CODE
    SEL.CMD := ' AND BRANCH.DEPT EQ ' : ID.COMPANY
    SEL.CMD := ' AND STATUS EQ AVAILABLE BY SERIAL.NO'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.NEXT.AVAILABLE.ID = SEL.LIST<1,1>
*
RETURN
*
*----------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------
*
    PROCESS.GOAHEAD = "1"
*
    Y.ITEM.CODE = ''
    PGM.FLAG    = ''
*
    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM  = ''
*
    FN.REDO.H.ADMIN.CHEQUES = 'F.REDO.H.ADMIN.CHEQUES'
    F.REDO.H.ADMIN.CHEQUES  = ''
*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
*
RETURN
*
*----------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------
*
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)
    CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)
*
RETURN
*
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1;    MAX.LOOPS = 2
*
* CAMBIOS DE CONDICION
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                Y.PARAM.ID = 'SYSTEM'
                CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,Y.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,PARAM.ERR)
* -----
            CASE LOOP.CNT EQ 2
                GOSUB GET.NEXT.AVAILABLE.CHECK.NUMBER

        END CASE

        LOOP.CNT +=1
    REPEAT
*
END
