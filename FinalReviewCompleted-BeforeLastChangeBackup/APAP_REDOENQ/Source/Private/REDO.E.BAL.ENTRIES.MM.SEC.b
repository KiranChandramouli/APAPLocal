$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BAL.ENTRIES.MM.SEC(E.ARRAY)
*
* Byron
*
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , I to I.VAR , J to J.VAR and H to H.VAR
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.RE.TXN.CODE

*---------*
* PRINCIPAL
*---------*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    GOSUB GET.INFO

RETURN

*----------
INITIALISE:
*----------

    PROCESS.GOAHEAD = 1
    YSEP= "*"
    YSTMT.COUNT = 0
    YCONSOL.COUNT = 0
    YCATEG.COUNT = 0
    YCONTRACT.LIST = ""
    D.POS = ''
    E.ARRAY = ''

    FN.ECONT.BAL = "F.EB.CONTRACT.BALANCES"
    F.ECONT.BAL = ""

    FN.SE = "F.STMT.ENTRY"
    F.SE = ""

    FN.CE = "F.CATEG.ENTRY"
    F.CE = ""

    FN.RCSE = "F.RE.CONSOL.SPEC.ENTRY"
    F.RCSE = ""

    FN.TXNC = "F.RE.TXN.CODE"
    F.TXNC = ""

RETURN

*----------
OPEN.FILES:
*----------

    CALL OPF(FN.ECONT.BAL, F.ECONT.BAL)
    CALL OPF(FN.SE, F.SE)
    CALL OPF(FN.CE, F.CE)
    CALL OPF(FN.RCSE, F.RCSE)
    CALL OPF(FN.TXNC, F.TXNC)

RETURN

*---------
CHECK.PRELIM.CONDITIONS:
*---------
* Check for any Pre requisite conditions - like the existence of a record/parameter etc
* if not, set PROCESS.GOAHEAD to 0
*
* When adding more CASEs, remember to assign the number of CASE statements to MAX.LOOPS
*
*
    LOOP.CNT = 1 ; MAX.LOOPS = 3
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
*
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                LOCATE 'CONTRACT.ID' IN D.FIELDS<1> SETTING D.POS ELSE
                    IF D.POS NE "" THEN
                        PROCESS.GOAHEAD = 0
                    END
                END

            CASE LOOP.CNT EQ 2
                YECONTRACT.ID = D.RANGE.AND.VALUE<D.POS>
                YECONT.BAL.REC = "" ; ERR.ECONT.BAL = ""
                CALL F.READ(FN.ECONT.BAL, YECONTRACT.ID, YECONT.BAL.REC, F.ECONT.BAL, ERR.ECONT.BAL)

                IF YECONT.BAL.REC EQ "" THEN
                    PROCESS.GOAHEAD = 0
                END
            CASE LOOP.CNT EQ 3
                YSTMT.COUNT = DCOUNT(YECONT.BAL.REC<ECB.STMT.ENT.IDS>,@VM)
                YCONSOL.COUNT = DCOUNT(YECONT.BAL.REC<ECB.CONSOL.ENT.IDS>,@VM)
                YCATEG.COUNT = DCOUNT(YECONT.BAL.REC<ECB.CATEG.ENT.IDS>,@VM)

                IF (YSTMT.COUNT + YCONSOL.COUNT + YCATEG.COUNT) EQ 0 THEN
                    PROCESS.GOAHEAD = 0
                END
        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN

*---------
GET.INFO:
*---------

    IF PROCESS.GOAHEAD THEN
        GOSUB STMT.COUNTER
        GOSUB CONSOL.COUNTER
        GOSUB CATEG.COUNTER
    END

RETURN
*
*-------------------------
STMT.COUNTER:
*-------------------------
    FOR H.VAR = 1 TO YSTMT.COUNT
        YSE.KEY = FIELD(YECONT.BAL.REC<ECB.STMT.ENT.IDS,H.VAR>,"/",1)
        YSE.REC = "" ; ERR.SE = ""
        CALL F.READ(FN.SE, YSE.KEY, YSE.REC, F.SE, ERR.SE)
        IF YSE.REC THEN
*Pos 3 in Array
* YBDATE = YSE.REC<25> ;*Tus Start
            YBDATE = YSE.REC<AC.STE.BOOKING.DATE>
*Pos 4 in Array
* YACCT = YSE.REC<1>
            YACCT = YSE.REC<AC.STE.ACCOUNT.NUMBER>
*Pos 5 in Array
* YCUST = YSE.REC<8>
            YCUST = YSE.REC<AC.STE.CUSTOMER.ID>
*Pos 6 in Array
* YCOMP = YSE.REC<2>
            YCOMP = YSE.REC<AC.STE.COMPANY.CODE>
*Pos 7 in Array
* YVDATE = YSE.REC<11>
            YVDATE = YSE.REC<AC.STE.VALUE.DATE>
*Pos 8 in Array
*  YCCY = YSE.REC<12>
            YCCY = YSE.REC<AC.STE.CURRENCY>
*Pos 9 in Array
*  YFAMT = YSE.REC<13>
            YFAMT = YSE.REC<AC.STE.AMOUNT.FCY>
*Pos 10 in Array
*  YLAMT = YSE.REC<3>
            YLAMT = YSE.REC< AC.STE.AMOUNT.LCY>;*Tus End
            E.ARRAY<-1> = "SE:":H.VAR:"-":YECONTRACT.ID:YSEP:YSE.KEY:YSEP:YBDATE:YSEP:YACCT:YSEP:YCUST:YSEP:YCOMP:YSEP:YVDATE:YSEP:YCCY:YSEP:YFAMT:YSEP:YLAMT
        END
    NEXT H.VAR
RETURN
*---------------
CONSOL.COUNTER:
*-------------------------
    FOR I.VAR = 1 TO YCONSOL.COUNT
        YRCSE.KEY = FIELD(YECONT.BAL.REC<ECB.CONSOL.ENT.IDS,I.VAR>,"/",1)
        YRCSE.REC = ""
        ERR.RCSE = ""
        CALL F.READ(FN.RCSE, YRCSE.KEY, YRCSE.REC, F.RCSE, ERR.RCSE)
        IF YRCSE.REC THEN
*   YBDATE = YRCSE.REC<25>;*Tus Start
            YBDATE = YRCSE.REC<RE.CSE.BOOKING.DATE>
*   YTXNC.KEY = YRCSE.REC<4>          ;* Transaction Code in case of CONSOL.ENTRY
            YTXNC.KEY = YRCSE.REC<RE.CSE.TRANSACTION.CODE> ;*Tus End
            IF YTXNC.KEY THEN
                YTXNC.REC = ""
                ERR.TXNC = ""
                CALL CACHE.READ(FN.TXNC, YTXNC.KEY, YTXNC.REC, ERR.TXNC)      ;*R22 Auto Conversion  - F.READ to CACHE.READ
                IF YTXNC.REC THEN
                    YTXNC.DESC = YTXNC.REC<RE.TXN.SHORT.DESC,1>
                END
            END
            IF YTXNC.DESC THEN
                YACCT = YTXNC.DESC
            END ELSE
*   YACCT = YRCSE.REC<1>;*Tus Start
                YACCT = YRCSE.REC<RE.CSE.DEAL.NUMBER>;*Tus End

            END
*  YCUST = YRCSE.REC<8>;*Tus Start
            YCUST = YRCSE.REC<RE.CSE.CUSTOMER.ID>
*  YCOMP = YRCSE.REC<2>
            YCOMP = YRCSE.REC<RE.CSE.COMPANY.CODE>
*  YVDATE = YRCSE.REC<11>
            YVDATE = YRCSE.REC<RE.CSE.VALUE.DATE>
*  YCCY = YRCSE.REC<12>
            YCCY = YRCSE.REC<RE.CSE.CURRENCY>
*  YFAMT = YRCSE.REC<13>
            YFAMT = YRCSE.REC<RE.CSE.AMOUNT.FCY>
*  YLAMT = YRCSE.REC<3>
            YLAMT = YRCSE.REC<RE.CSE.AMOUNT.LCY>;*Tus End
            E.ARRAY<-1> = "RCSE:":I.VAR:"-":YECONTRACT.ID:YSEP:YRCSE.KEY:YSEP:YBDATE:YSEP:YACCT:YSEP:YCUST:YSEP:YCOMP:YSEP:YVDATE:YSEP:YCCY:YSEP:YFAMT:YSEP:YLAMT
        END
    NEXT I.VAR
RETURN
*---------------
CATEG.COUNTER:
*-------------------------
    FOR J.VAR = 1 TO YCATEG.COUNT
        YCE.KEY = FIELD(YECONT.BAL.REC<ECB.CATEG.ENT.IDS,J.VAR>,"/",1)
        YCE.REC = ""
        ERR.CE = ""
        CALL F.READ(FN.CE, YCE.KEY, YCE.REC, F.CE, ERR.CE)
        IF YCE.REC THEN
*  YBDATE = YCE.REC<25>;*Tus Start
            YBDATE = YCE.REC<AC.CAT.BOOKING.DATE>
*  YACCT = YCE.REC<7>      ;*
            YACCT = YCE.REC<AC.CAT.PL.CATEGORY>
*  YCUST = YCE.REC<8>
            YCUST = YCE.REC<AC.CAT.CUSTOMER.ID>
*  YCOMP = YCE.REC<2>
            YCOMP = YCE.REC<AC.CAT.COMPANY.CODE>
*  YVDATE = YCE.REC<11>
            YVDATE = YCE.REC<AC.CAT.VALUE.DATE>
*  YCCY = YCE.REC<12>
            YCCY = YCE.REC<AC.CAT.CURRENCY>
*  YFAMT = YCE.REC<13>
            YFAMT = YCE.REC<AC.CAT.AMOUNT.FCY>
*  YLAMT = YCE.REC<3>
            YLAMT = YCE.REC<AC.CAT.AMOUNT.LCY>;*Tus End
            E.ARRAY<-1> = "CE:":J.VAR:"-":YECONTRACT.ID:YSEP:YCE.KEY:YSEP:YBDATE:YSEP:YACCT:YSEP:YCUST:YSEP:YCOMP:YSEP:YVDATE:YSEP:YCCY:YSEP:YFAMT:YSEP:YLAMT
        END
    NEXT J.VAR
RETURN
*---------
END
