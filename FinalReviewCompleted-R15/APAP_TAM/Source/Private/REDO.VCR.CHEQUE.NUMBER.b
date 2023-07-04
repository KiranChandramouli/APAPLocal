* @ValidationCode : MjotMzkxNzQ5NTQ6Q3AxMjUyOjE2ODQ0OTEwNDg5NDU6SVRTUzotMTotMTo1NDQ6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 544
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VCR.CHEQUE.NUMBER
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.ITEM.CODE
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*
*   GET NEXT AVAILABLE CHEQUE NUMBER
*
*   Routine rebuilt as CHECK.ID from original REDO.V.VAL.ITEM.CODE
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*
* DATE            WHO                REFERENCE          DESCRIPTION
* 19.02.2010   H GANESH              ODR-2009-12-0285   INITIAL CREATION
* 18-02.2010   KAVITHA               ODR-2009-12-0285   HD1054080
* 13-06-2011   GANESH H              13-06-2011         PACS00036499
* 16-07-2011   Marimuthu                                PACS00062902
*
* 17-11-2011   Joaquin Costa         GRUPO 4 PACS
*
* 03-09-2012   Jeeva T               Inventory Updation
* 07-08-2013   Vignesh Kumaar M R    PACS00303915       CHEQUE SEQUENCE UPDATING WRONGLY
* 20-09-2013   Vignesh Kumaar M R    PACS00320183       INVENTARY ISSUE
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        FM TO @FM, VM TO @VM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           CALL RTN FORMAT MODIFIED

*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.USER
*
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
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
    CALL F.WRITE(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.AVAILABLE.ID,R.REDO.H.ADMIN.CHEQUES)
*
RETURN
*
* ==============================
GET.NEXT.AVAILABLE.CHECK.NUMBER:
* ==============================
*
    W.ACCOUNT1 = ""
    W.ACCOUNT2 = ""
*
    BEGIN CASE
        CASE APPLICATION EQ 'TELLER'
            IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
                W.ACCOUNT1 = R.NEW(TT.TE.ACCOUNT.2)
                W.ACCOUNT2 = R.NEW(TT.TE.ACCOUNT.1)
            END ELSE
                W.ACCOUNT1 = R.NEW(TT.TE.ACCOUNT.1)
                W.ACCOUNT2 = R.NEW(TT.TE.ACCOUNT.2)
            END

*        Y.ACCOUNT = W.ACCOUNT1
*        Y.CUST    = ""
*        IF Y.ACCOUNT THEN
*            CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
*            IF R.ACCOUNT THEN
*                Y.CUST = R.ACCOUNT<AC.CUSTOMER>
*            END
*        END
*        IF Y.CUST OR NOT(Y.ACCOUNT) THEN
*            Y.ACCOUNT = W.ACCOUNT2
*        END

* Fix for PACS00320183 [INVENTARY ISSUE]

            GET.CURR.TILL.ID = R.NEW(TT.TE.TELLER.ID.1)
            IF ALPHA(W.ACCOUNT2[1,3]) AND W.ACCOUNT2[9,4] NE GET.CURR.TILL.ID THEN
                Y.ACCOUNT = W.ACCOUNT2
                Y.ALTER.ACCT = W.ACCOUNT1
            END ELSE
                Y.ACCOUNT = W.ACCOUNT1
                Y.ALTER.ACCT = W.ACCOUNT2
            END

* End of Fix

            WAPP.CHEQUE.NUMBER.FIELD = TT.TE.AMOUNT.LOCAL.1
            GOSUB GET.CHECK.NUMBER

* Fix for PACS00303915 [CHEQUE SEQUENCE UPDATING WRONGLY]

            GET.CHEQUE.NUMB = R.NEW(TT.TE.CHEQUE.NUMBER)
            GOSUB DEFAULT.CHQ.NO      ;* defaulting the cheque number based on override.
            GOSUB UPDATE.STOCK

*commented because of it is restructing the cheque number defaults.
*     Y.OVERRIDE = OFS$OVERRIDES
*     IF NOT(GET.CHEQUE.NUMB) AND Y.OVERRIDE<2,1> EQ 'YES' THEN
*         R.NEW(TT.TE.CHEQUE.NUMBER)   = W.NEXT.AVAILABLE.ID
*         R.NEW(TT.TE.THEIR.REFERENCE) = W.NEXT.AVAILABLE.ID
*         R.NEW(TT.TE.NARRATIVE.1)     = Y.NEXT.AVAILABLE.ID
*         GOSUB UPDATE.STOCK
*     END

* End of Fix

        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            Y.ACCOUNT = R.NEW(FT.CREDIT.ACCT.NO)
            WAPP.CHEQUE.NUMBER.FIELD = FT.CREDIT.ACCT.NO
            GOSUB GET.CHECK.NUMBER
            R.NEW(FT.CREDIT.THEIR.REF)        = W.NEXT.AVAILABLE.ID
            R.NEW(FT.LOCAL.REF)<1,TR.REF.POS> = Y.NEXT.AVAILABLE.ID
            GOSUB UPDATE.STOCK
    END CASE
*
RETURN
*

DEFAULT.CHQ.NO:     * PACS00457562 fix
*--------------

    Y.OVERRIDE = OFS$OVERRIDES
    IF NOT(Y.OVERRIDE) THEN
        IF NOT(GET.CHEQUE.NUMB) THEN
            R.NEW(TT.TE.CHEQUE.NUMBER)   = W.NEXT.AVAILABLE.ID
            R.NEW(TT.TE.THEIR.REFERENCE) = W.NEXT.AVAILABLE.ID
            R.NEW(TT.TE.NARRATIVE.1)     = Y.NEXT.AVAILABLE.ID
        END
    END ELSE
        IF Y.OVERRIDE<2,1> EQ 'YES' AND NOT(GET.CHEQUE.NUMB) THEN
            R.NEW(TT.TE.CHEQUE.NUMBER)   = W.NEXT.AVAILABLE.ID
            R.NEW(TT.TE.THEIR.REFERENCE) = W.NEXT.AVAILABLE.ID
            R.NEW(TT.TE.NARRATIVE.1)     = Y.NEXT.AVAILABLE.ID
        END
    END


RETURN
*----------------------------------------------------------------------
GET.CHECK.NUMBER:
*----------------------------------------------------------------------
*
* To get the next available from the received list of @ID'S
*

    LOCATE Y.ACCOUNT IN R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,1> SETTING POS1 THEN
        Y.ITEM.CODE = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE,POS1>
    END

    IF Y.ITEM.CODE EQ '' AND APPLICATION EQ 'TELLER' THEN
        Y.ACCOUNT = Y.ALTER.ACCT
        LOCATE Y.ACCOUNT IN R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,1> SETTING POS1 THEN
            Y.ITEM.CODE = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE,POS1>
        END
    END

*>>>>>>>>>>>>>>>>>>>>>>>>>>> Department Values is obtained from USER application from field L.US.IDC.COD>>>>>>>>>>>>>>>>>
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Modification Starts>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*

    Y.BRANCH.LIST = R.USER<EB.USE.LOCAL.REF,Y.BRANCH.POS>
    Y.DEPT.LIST   = R.USER<EB.USE.LOCAL.REF,Y.DEPT.POS>
    LOCATE ID.COMPANY IN Y.BRANCH.LIST<1,1,1> SETTING POS.BR THEN
        Y.CODE.VAL = Y.DEPT.LIST<1,1,POS.BR>
    END ELSE
        Y.CODE.VAL = ''
    END

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Modification Ends>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

*
    SEL.CMD  = 'SSELECT ' : FN.REDO.H.ADMIN.CHEQUES
    SEL.CMD := ' WITH ITEM.CODE EQ ' : Y.ITEM.CODE
    SEL.CMD := ' AND BRANCH.DEPT EQ ' : ID.COMPANY
*>>>>>>>>>>>>>>>>>>>>>>>Department is added in Selection- Starts->>>>>>>>>>>>>>>>>>>>>>
    IF Y.CODE.VAL THEN
        SEL.CMD := ' AND CODE EQ ' : Y.CODE.VAL
    END
*>>>>>>>>>>>>>>>>>>>Changes done sort DATE.UPDATED is added- Ends ->>>>>>>>>>>>>>>>>>>>
    SEL.CMD := ' AND STATUS EQ AVAILABLE BY SERIAL.NO BY DATE.UPDATED'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    IF NOT(SEL.LIST) THEN
        AF              = WAPP.CHEQUE.NUMBER.FIELD
        ETEXT           = "TT-ADMIN.CHEQUE.NOT.AVAILABLE.FOR.&.ACCOUNT":@FM:Y.ACCOUNT
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END ELSE
        GOSUB CONTINUE.GETTING.NUMBER
    END
*
RETURN
*
* ======================
CONTINUE.GETTING.NUMBER:
* ======================
*
    CHEQUE.FOUND = ""
*
    LOOP
        REMOVE X.NEXT.AVAILABLE.ID FROM SEL.LIST SETTING POS
    WHILE X.NEXT.AVAILABLE.ID:POS AND NOT(CHEQUE.FOUND)

        Y.NEXT.AVAILABLE.ID =           X.NEXT.AVAILABLE.ID
        CALL F.READU(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.AVAILABLE.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,ERR,"I")
        IF ERR NE 'RECORD LOCKED' AND R.REDO.H.ADMIN.CHEQUES NE '' THEN
            IF R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> EQ "AVAILABLE" THEN
                R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> = "ISSUED"
                W.NEXT.AVAILABLE.ID = R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.SERIAL.NO>
                CHEQUE.FOUND = 1      ;* exit the loop else go for next id
            END
        END

    REPEAT
*
    IF NOT(CHEQUE.FOUND) THEN
        AF              = WAPP.CHEQUE.NUMBER.FIELD
        ETEXT           = "TT-ADMIN.CHEQUE.NOT.AVAILABLE.FOR.&.ACCOUNT":@FM:Y.ACCOUNT
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END
*
RETURN
*
*===================
UPDATE.STOCK:
*===================
*
*CALL REDO.UPD.VAL.ITEM.VALUE  ;*R22 MANUAL CODE CONVERSION
    APAP.TAM.redoUpdValItemValue() ;*R22 MANUAL CODE CONVERSION
*
RETURN
*
* ===================
DELETE.FUNCTION.CASE:
* ===================
*
    IF APPLICATION EQ "TELLER" THEN
        Y.NEXT.AVAILABLE.ID = R.NEW(TT.TE.NARRATIVE.1)
    END ELSE
        Y.NEXT.AVAILABLE.ID = R.NEW(FT.LOCAL.REF)<1,TR.REF.POS>
    END
    CALL F.READU(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.AVAILABLE.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,ERR,"I")
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> = "AVAILABLE"
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
    FN.REDO.ADMIN.CHQ.DETAILS='F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS=''
*
    W.NEXT.AVAILABLE.ID = ""
*
    WAPPL = APPLICATION : @FM : "USER"
    WCAMPO    = "TRANSACTION.REF" : @FM : 'L.US.IDC.BR' : @VM : 'L.US.IDC.CODE'
    YPOS = ''
    CALL MULTI.GET.LOC.REF(WAPPL,WCAMPO,YPOS)
    TR.REF.POS   = YPOS<1,1>
    Y.BRANCH.POS = YPOS<2,1>
    Y.DEPT.POS   = YPOS<2,2>

RETURN
*
*----------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------
*
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)
    CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)
*
RETURN
*
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1;    MAX.LOOPS = 3
*
* CAMBIOS DE CONDICION
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        GOSUB CHK.OFS.FUNCTION    ;*gosub created for reduce the rating

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

CHK.OFS.FUNCTION:
*---------------
    BEGIN CASE

        CASE LOOP.CNT EQ 1

*
            IF OFS.VAL.ONLY OR V$FUNCTION EQ "R" THEN
                PROCESS.GOAHEAD = ""
                GOSUB UPDATE.STOCK
            END

        CASE LOOP.CNT EQ 2
            Y.PARAM.ID = 'SYSTEM'
            CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,Y.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,PARAM.ERR)
* -----
        CASE LOOP.CNT EQ 3
            IF V$FUNCTION NE "D" THEN
                GOSUB GET.NEXT.AVAILABLE.CHECK.NUMBER
            END ELSE
                GOSUB DELETE.FUNCTION.CASE
                GOSUB UPDATE.STOCK
            END

    END CASE

RETURN
END
