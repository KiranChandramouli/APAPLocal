$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.M.PROP.NONRES(Y.CUSTOMER.ID)
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description:
*-------------------------------------------------------------------------------
* Modification History
**********************
*---------------------------------------------------------------------------------------------
*   Date       Author              Modification Description
* 29/10/2014  Ashokkumar.V.P        PACS00371996 - New mapping changes. Fixed property amount issue.
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_REDO.B.M.PROP.NONRES.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_F.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.AA.ARRANGEMENT ;* R22 Auto conversion
    $INSERT I_F.AA.TERM.AMOUNT ;* R22 Auto conversion
    $INSERT I_F.COLLATERAL ;* R22 Auto conversion
    $INSERT I_F.AA.ACCOUNT.DETAILS ;* R22 Auto conversion
    $INSERT I_F.AA.BILL.DETAILS ;* R22 Auto conversion
    $INSERT I_F.COUNTRY ;* R22 Auto conversion
    $INSERT I_F.COMPANY ;* R22 Auto conversion
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT ;* R22 Auto conversion

    GOSUB PROCESS.PARA

RETURN

PROCESS.PARA:
*------------
    R.REDO.CUSTOMER.ARRANGEMENT = ''; REDO.CUS.ERR = ''
    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER.ID,R.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT,REDO.CUS.ERR)
    IF NOT(REDO.CUS.ERR) THEN
        Y.OWNER = R.REDO.CUSTOMER.ARRANGEMENT<CUS.ARR.OWNER>
        LOOP
            REMOVE Y.AA.ARRANGEMENT FROM Y.OWNER SETTING Y.POS
        WHILE Y.AA.ARRANGEMENT:Y.POS
            CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ARRANGEMENT,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
            IF R.AA.ARRANGEMENT THEN
                Y.PRODUCT.LINE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
                Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
                Y.ARR.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
                CHANGE ' ' TO @FM IN FL.PARAM.ARR.STAUS
                GOSUB MAIN.PARA
            END
        REPEAT
    END
RETURN

MAIN.PARA:
*--------

    IF (Y.PRODUCT.LINE EQ FL.PARAM.PRD.LINE) AND (Y.PRODUCT.GROUP EQ FL.PARAM.PRD.GRP) THEN
        GOSUB CHECK.ARR.STATUS
        IF Y.ARR.STAT.FLAG THEN
            GOSUB GET.PERIOD
            GOSUB GET.RES.CNTRY
            GOSUB GET.TOTAL.INVESTMENT
            GOSUB GET.DOWN.PAYMENT
            GOSUB GET.OVR.DUE.INSTLMNT.PRD
            GOSUB DO.RCL.MAPPING
        END
    END
RETURN
*
GET.PERIOD:
*---------
    Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.QUARTER.END.DATE = Y.TODAY[5,2]
*
    BEGIN CASE
        CASE Y.QUARTER.END.DATE  LE '3'
            C$SPARE(100) = 'Enero - Marzo'
        CASE Y.QUARTER.END.DATE GT '3' AND Y.QUARTER.END.DATE LE '6'
            C$SPARE(100) = 'Abril - Junio'
        CASE Y.QUARTER.END.DATE GT '6' AND Y.QUARTER.END.DATE LE '9'
            C$SPARE(100) = 'Julio - Septiembre'
        CASE Y.QUARTER.END.DATE GT '9' AND Y.QUARTER.END.DATE LE  '12'
            C$SPARE(100) = 'Octubre - Diciembre'
    END CASE
*
RETURN
*
GET.RES.CNTRY:
*-------------
*
    Y.AA.CUSTOMER = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.AA.CUSTOMER,R.AA.CUSTOMER,F.CUSTOMER,AA.CUS.ERR)
    IF NOT(AA.CUS.ERR) THEN
        Y.AA.CUS.COUNTRY = R.AA.CUSTOMER<EB.CUS.RESIDENCE>
        CALL F.READ(FN.COUNTRY,Y.AA.CUS.COUNTRY,R.COUNTRY,F.COUNTRY,C.ERR)
        IF NOT(C.ERR) THEN
            Y.LNGG =  R.COMPANY(EB.COM.LANGUAGE.CODE)
            Y.COUNTRY.VAL = R.COUNTRY<EB.COU.COUNTRY.NAME,Y.LNGG>
            IF Y.COUNTRY.VAL THEN
                C$SPARE(101) = Y.COUNTRY.VAL
            END ELSE
                C$SPARE(101) = R.COUNTRY<EB.COU.COUNTRY.NAME,LNGG>
            END
        END
    END
*
RETURN

GET.TOTAL.INVESTMENT:
*-------------------
    AA.ARRANGEMENT.ID = Y.AA.ARRANGEMENT
    ID.PROPERTY.CLASS =  'TERM.AMOUNT'
    ID.PROPERTY =  ''
    EFF.DATE = ''
    OUT.ERR = ''; AA.COL.POS = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(AA.ARRANGEMENT.ID,ID.PROPERTY.CLASS,ID.PROPERTY,EFF.DATE,ID.OUT,OUT.COND,OUT.ERR)
    OUT.COND =   RAISE(OUT.COND)
    IF NOT(OUT.ERR) THEN
        Y.L.AA.COL.VALUE = OUT.COND<AA.AMT.LOCAL.REF,Y.L.AA.COL.POS>

        LOOP
            REMOVE Y.L.AA.COL FROM Y.L.AA.COL.VALUE SETTING AA.COL.POS
        UNTIL Y.L.AA.COL EQ ''
            CALL F.READ(FN.COLLATERAL,Y.L.AA.COL,R.COLLATERAL,F.COLLATERAL,COLL.ERR)
            IF NOT(COLL.ERR) THEN
* Value from the local field "L.COL.TOT.VALUA" stored in Y.L.CO.LOAN.AMT.POS variable.
                Y.L.CO.LOAN.AMT = R.COLLATERAL<COLL.LOCAL.REF,Y.L.CO.LOAN.AMT.POS>
            END
        REPEAT
        IF Y.L.CO.LOAN.AMT THEN
            C$SPARE(102) = Y.L.CO.LOAN.AMT
        END ELSE
            C$SPARE(102) = ''
        END
        C$SPARE(453) = ''
    END

RETURN

GET.DOWN.PAYMENT:
*-----------------
    Y.TERM.AMOUNT = OUT.COND<AA.AMT.AMOUNT>
    Y.DOWN.PYMT = ABS(Y.L.CO.LOAN.AMT-Y.TERM.AMOUNT)
    Y.DOWN.PAYMENT = FMT(Y.DOWN.PYMT,"R2")
    C$SPARE(103) = Y.DOWN.PAYMENT

RETURN

GET.OVR.DUE.INSTLMNT.PRD:
*------------------------
    Y.TERM.AMOUNT = FMT(Y.TERM.AMOUNT,"R2")
    C$SPARE(104) = Y.TERM.AMOUNT
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ARRANGEMENT,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACC.DTLS.ERR)
    IF NOT(ACC.DTLS.ERR) THEN
        Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
        LOOP
            REMOVE Y.AA.BILL.ID FROM Y.BILL.ID SETTING Y.BILL.POS
        UNTIL Y.AA.BILL.ID EQ ''
            R.AA.BILL.DETAILS = ''; BILL.ERR = ''
            CALL F.READ(FN.AA.BILL.DETAILS,Y.AA.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
            IF BILL.ERR THEN
                R.AA.BILL.DETAILS = ''; BILL.ERR = ''
                CALL F.READ(FN.AA.BILL.DETAILS.HST,Y.AA.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS.HST,BILL.ERR)
            END
            IF NOT(BILL.ERR) THEN
                Y.PAYMENT.DATE = R.AA.BILL.DETAILS<AA.BD.PAYMENT.DATE>
                Y.PAY.YEAR = Y.PAYMENT.DATE[1,4]
                Y.CURRENT.YEAR = Y.TODAY[1,4]
                Y.CURRENT.MNTH = Y.TODAY[5,2]
                GOSUB GET.QUARTER
                Y.TODAY.Q = Y.CURRENT.Q
                Y.CURRENT.MNTH = Y.PAYMENT.DATE[5,2]
                GOSUB GET.QUARTER
                IF Y.PAY.YEAR MATCHES Y.CURRENT.YEAR THEN
                    IF Y.CURRENT.Q MATCHES Y.TODAY.Q THEN
                        Y.PROPERTY = R.AA.BILL.DETAILS<AA.BD.PROPERTY>
                        Y.OR.PROP.AMOUNT  = R.AA.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT>
                        GOSUB CHECK.PROPERTY
                    END
                END
            END
        REPEAT

        IF Y.VAL.ACC THEN
            Y.VAL.ACC = FMT(Y.VAL.ACC,"R2")
            C$SPARE(105) = Y.VAL.ACC
            Y.VAL.ACC = ''
        END ELSE
            C$SPARE(105) = ''
            Y.VAL.ACC = ''
        END
        IF Y.VAL.INT THEN
            Y.VAL.INT = FMT(Y.VAL.INT,"R2")
            C$SPARE(451) = Y.VAL.INT
            Y.VAL.INT = ''
        END ELSE
            C$SPARE(451) = ''
            Y.VAL.INT = ''
        END
    END
RETURN

CHECK.PROPERTY:
**************
    CHANGE @VM TO @FM IN Y.PROPERTY
    CHANGE @VM TO @FM IN Y.OR.PROP.AMOUNT
    LOCATE 'ACCOUNT' IN Y.PROPERTY<1> SETTING Y.POS1 THEN
        Y.VAL.ACC += Y.OR.PROP.AMOUNT<Y.POS1>
    END
    LOCATE 'PRINCIPALINT' IN Y.PROPERTY<1> SETTING Y.POS2 THEN
        Y.VAL.INT += Y.OR.PROP.AMOUNT<Y.POS2>
    END
    Y.PROPERTY= '';Y.OR.PROP.AMOUNT = ''
RETURN
DO.RCL.MAPPING:
*--------------
    MAP.FMT = 'MAP'
    ID.RCON.L = 'REDO.M.RCL.PROP.NON.RES'
    APP = FN.AA.ARRANGEMENT
    ID.APP = Y.AA.ARRANGEMENT
    R.APP = R.AA.ARRANGEMENT
    RCL.ERR = ''
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    OUT.ARRAY = R.RETURN.MSG
    GOSUB WRITE.TO.FILE
RETURN
*
GET.QUARTER:
*-----------
    Y.CURRENT.Q = ''

    BEGIN CASE
        CASE Y.CURRENT.MNTH LE '3'
            Y.CURRENT.Q = '3'
        CASE Y.CURRENT.MNTH GT '3' AND Y.CURRENT.MNTH LE '6'
            Y.CURRENT.Q = '6'
        CASE Y.CURRENT.MNTH GT '6' AND Y.CURRENT.MNTH LE '9'
            Y.CURRENT.Q = '9'
        CASE Y.CURRENT.MNTH GT '9' AND Y.CURRENT.MNTH LE '12'
            Y.CURRENT.Q = '12'
    END CASE
RETURN

WRITE.TO.FILE:
*-------------
*
    WRITESEQ OUT.ARRAY ON SEQ.PTR ELSE
        ERR.MSG = "Unable to write to ":FILE.NAME
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP = "04"
        REC.CON = "AA.NONRES-":ERR.MSG
        DESC = "AA.NONRES-":ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
RETURN
****************
CHECK.ARR.STATUS:
****************
    Y.ARR.STAT.FLAG = ''
    Y.STAT.CNT = DCOUNT(FL.PARAM.ARR.STAUS,@FM)
    Y.CNT = '1'
    LOOP
    WHILE Y.CNT LE Y.STAT.CNT AND NOT(Y.ARR.STAT.FLAG)
        Y.PARAM.STAT = FL.PARAM.ARR.STAUS<Y.CNT>
        IF Y.PARAM.STAT EQ Y.ARR.STATUS THEN
            Y.ARR.STAT.FLAG = '1'
        END
        Y.CNT += 1 ;* R22 Auto conversion
    REPEAT
RETURN
END
